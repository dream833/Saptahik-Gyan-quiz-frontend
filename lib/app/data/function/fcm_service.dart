import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_cons.dart';
import 'dio_post.dart';

/// Top-level background handler — REQUIRED by firebase_messaging.
/// Must be a top-level/static function (no context allowed).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log(
    "FCM Background: ${message.notification?.title} | ${message.notification?.body}",
  );
}

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? _token;

  /// Call once in `main()` after `Firebase.initializeApp()`.
  static Future<void> initialize() async {
    // iOS permission prompt (harmless no-op on Android)
    if (Platform.isIOS) {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Grab the current device token
    try {
      _token = await _messaging.getToken();
      log("FCM Token: $_token");
    } catch (e) {
      log("FCM getToken error: $e");
    }

    // Re-register if token refreshes
    _messaging.onTokenRefresh.listen((newToken) {
      _token = newToken;
      log("FCM Token refreshed: $newToken");
      _registerIfLoggedIn();
    });

    // Foreground message → show in-app banner
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("FCM Foreground: ${message.notification?.title}");
      final title = message.notification?.title ?? 'New Notification';
      final body = message.notification?.body ?? '';
      Get.snackbar(
        title,
        body,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.only(top: 12),
        borderRadius: 14,
      );
    });

    // App opened from notification (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("FCM Opened: ${message.data}");
      _handleNotificationTap(message);
    });

    // App launched from notification (app killed)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      log("FCM Initial: ${initialMessage.data}");
      _handleNotificationTap(initialMessage);
    }

    // If a user is already logged in, register the token on app open
    _registerIfLoggedIn();
  }

  /// Register the device token with the backend.
  static Future<void> registerDevice({
    required String userId,
    String? token,
  }) async {
    final t = token ?? _token;
    if (t == null || t.isEmpty) return;
    try {
      final response = await dioPost(
        endUrl: "/register-device.php",
        data: {
          'user_id': int.tryParse(userId) ?? 0,
          'token': t,
          'platform': Platform.isIOS ? 'ios' : 'android',
        },
      );
      log("register-device: ${response.data}");
    } catch (e) {
      log("register-device error: $e");
    }
  }

  /// Remove the device token on logout.
  static Future<void> unregisterDevice() async {
    final t = _token;
    if (t == null || t.isEmpty) return;
    try {
      final response = await dioPost(
        endUrl: "/unregister-device.php",
        data: {'token': t},
      );
      log("unregister-device: ${response.data}");
    } catch (e) {
      log("unregister-device error: $e");
    }
  }

  static String? get token => _token;

  // ─────────────────────────── helpers ───────────────────────────

  static void _registerIfLoggedIn() {
    final loggedIn = getBox.read(IS_USER_LOGGED_IN) ?? false;
    final userId = getBox.read(USER_ID);
    if (loggedIn && userId != null) {
      registerDevice(userId: userId.toString());
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    // Slight delay so navigation is ready after cold start
    Future.delayed(const Duration(milliseconds: 600), () {
      Get.toNamed('/notifications');
    });
  }
}
