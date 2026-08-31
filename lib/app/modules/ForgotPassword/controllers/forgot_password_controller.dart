import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_cons.dart';
import '../../../data/function/dio_post.dart';
import '../../SignIn/views/sign_in_view.dart';

class ForgotPasswordController extends GetxController {
  // ── Text Controllers ──
  final phoneController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ── State ──
  var currentStep = 0.obs; // 0 = phone, 1 = reset
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // ── Step 0: Submit phone number (no OTP — straight to the password step) ──
  Future<void> submitPhone() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Showsnackbar(message: "Enter your mobile number", isSuccess: false);
      return;
    }
    if (phone.length != 10) {
      Showsnackbar(message: "Mobile number must be 10 digits", isSuccess: false);
      return;
    }

    // Remember the phone and move to the password step
    await getBox.write(FORGOTFIELD, phone);
    currentStep.value = 1;
  }

  // ── Step 1: Reset Password ──
  Future<void> resetPassword() async {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty) {
      Showsnackbar(message: "Enter new password", isSuccess: false);
      return;
    }
    if (newPass.length < 6) {
      Showsnackbar(message: "Password must be at least 6 characters", isSuccess: false);
      return;
    }
    if (newPass != confirmPass) {
      Showsnackbar(message: "Passwords do not match", isSuccess: false);
      return;
    }

    try {
      isLoading.value = true;

      // Hit the API — only on success is the password actually updated
      final response = await dioPost(
        endUrl: "/forget.php",
        data: {
          "mobile": getBox.read(FORGOTFIELD),
          "new_password": newPass,
        },
      );

      if (response.data['status'] == true) {
        Showsnackbar(
          message: response.data['message'] ?? "Password reset successfully",
          isSuccess: true,
        );

        // Clear stored data
        getBox.remove(FORGOTFIELD);

        // Navigate to Sign In
        Get.offAll(() => const SignInView());
      } else {
        Showsnackbar(
          message: response.data['message'] ?? "Something went wrong",
          isSuccess: false,
        );
      }
    } catch (e) {
      log("Reset Password Error: $e");
      Showsnackbar(message: "Something went wrong. Please try again.", isSuccess: false);
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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
