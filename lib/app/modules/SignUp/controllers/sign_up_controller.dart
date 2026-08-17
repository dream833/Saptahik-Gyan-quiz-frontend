import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/function/dio_post.dart';
import '../../SignIn/views/sign_in_view.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;

  /// ✅ MUST BE RxBool
  var isLoading = false.obs;

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    /// VALIDATION
    if (name.isEmpty || email.isEmpty || mobile.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    if (mobile.length != 10) {
      Get.snackbar("Error", "Mobile number must be 10 digits");
      return;
    }

    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/signup.php",
        data: {
          "full_name": name,
          "email": email,
          "mobile": mobile,
          "password": password,
        },
      );

      log("Signup Response: ${response.data}");

      if (response.data['success'] == true) {
        Get.showSnackbar(
          GetSnackBar(
            title: "",
            message: response.data['message'] ?? "SignUp Done",
            duration: const Duration(seconds: 2),
          ),
        );

        Get.offAll(() => const SignInView());
      } else {
        Get.showSnackbar(
          GetSnackBar(
            title: "Error",
            message: response.data['message'] ?? "Signup failed",
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      log("Signup error: $e");
      Get.showSnackbar(
        const GetSnackBar(
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
