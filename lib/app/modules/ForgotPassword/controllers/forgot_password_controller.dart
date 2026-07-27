import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_cons.dart';
import '../../../data/function/dio_post.dart';
import '../../SignIn/views/sign_in_view.dart';

class ForgotPasswordController extends GetxController {
  // ── Text Controllers ──
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ── State ──
  var currentStep = 0.obs; // 0 = phone, 1 = OTP, 2 = reset
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // ── Step 0: Send OTP ──
  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Showsnackbar(message: "মোবাইল নম্বর দিন", isSuccess: false);
      return;
    }
    if (phone.length != 10) {
      Showsnackbar(message: "মোবাইল নম্বর অবশ্যই ১০ সংখ্যার হতে হবে", isSuccess: false);
      return;
    }

    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/forgotpass.php",
        data: {"phone": phone},
      );

      if (response.data['message'] == "OTP sent successfully") {
        getBox.write(USER_OTP, response.data['otp'] ?? '');
        getBox.write(FORGOTFIELD, phone);

        Showsnackbar(message: "OTP পাঠানো হয়েছে আপনার মোবাইলে", isSuccess: true);
        currentStep.value = 1;
      } else {
        Showsnackbar(
          message: response.data['message'] ?? "কিছু ভুল হয়েছে",
          isSuccess: false,
        );
      }
    } catch (e) {
      log("Send OTP Error: $e");
      Showsnackbar(message: "কিছু ভুল হয়েছে। আবার চেষ্টা করুন।", isSuccess: false);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Step 1: Verify OTP ──
  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Showsnackbar(message: "OTP দিন", isSuccess: false);
      return;
    }

    // In production, you'd verify against the API
    // For now, we let the user proceed to set new password
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/forgotpass.php",
        data: {
          "phone": getBox.read(FORGOTFIELD),
          "otp": otp,
          "action": "verify_otp",
        },
      );

      if (response.data['message'] == "OTP verified successfully") {
        Showsnackbar(message: "OTP সঠিক হয়েছে", isSuccess: true);
        currentStep.value = 2;
      } else {
        Showsnackbar(
          message: response.data['message'] ?? "OTP ভুল হয়েছে",
          isSuccess: false,
        );
      }
    } catch (e) {
      log("Verify OTP Error: $e");
      Showsnackbar(message: "OTP যাচাই করতে সমস্যা হয়েছে। আবার চেষ্টা করুন।", isSuccess: false);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Step 2: Reset Password ──
  Future<void> resetPassword() async {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty) {
      Showsnackbar(message: "নতুন পাসওয়ার্ড দিন", isSuccess: false);
      return;
    }
    if (newPass.length < 6) {
      Showsnackbar(message: "পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে", isSuccess: false);
      return;
    }
    if (newPass != confirmPass) {
      Showsnackbar(message: "পাসওয়ার্ড মিলছে না", isSuccess: false);
      return;
    }

    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/forgotpass.php",
        data: {
          "phone": getBox.read(FORGOTFIELD),
          "password": newPass,
          "action": "reset_password",
        },
      );

      if (response.data['message'] == "Password reset successfully") {
        Showsnackbar(message: "পাসওয়ার্ড রিসেট হয়েছে", isSuccess: true);

        // Clear stored data
        getBox.remove(USER_OTP);
        getBox.remove(FORGOTFIELD);

        // Navigate to Sign In
        Get.offAll(() => const SignInView());
      } else {
        Showsnackbar(
          message: response.data['message'] ?? "কিছু ভুল হয়েছে",
          isSuccess: false,
        );
      }
    } catch (e) {
      log("Reset Password Error: $e");
      Showsnackbar(message: "কিছু ভুল হয়েছে। আবার চেষ্টা করুন।", isSuccess: false);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Go back to previous step ──
  void goToStep(int step) {
    if (step >= 0 && step < currentStep.value) {
      currentStep.value = step;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
