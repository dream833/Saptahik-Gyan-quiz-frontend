import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdateService {
  /// Checks for official Google Play in-app updates using Play Core API.
  /// If an update is available on Google Play, triggers the update flow.
  static Future<void> checkPlayStoreUpdate() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;

    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      log("Play In-App Update check: $e");
    }
  }
}
