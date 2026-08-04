import 'dart:async';

import 'package:get/get.dart';

import '../../../data/config/app_cons.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    // Give the branded splash a moment to breathe, then navigate.
    _timer = Timer(const Duration(seconds: 3), _navigate);
  }

  void _navigate() {
    final isLoggedIn = getBox.read(IS_USER_LOGGED_IN) ?? false;
    Get.offAllNamed(isLoggedIn ? '/home' : '/sign-in');
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
