import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';
import 'package:quiz/app/modules/home/views/home_view.dart';

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
      Get.snackbar("Error", "সব ক্ষেত্র পূরণ করুন");
      return;
    }

    if (mobile.length != 10) {
      Get.snackbar("Error", "মোবাইল নম্বর অবশ্যই ১০ সংখ্যার হতে হবে");
      return;
    }

    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/signup.php",
        data: {
          "name": name,
          "email": email,
          "phone": mobile,
          "password": password,
        },
      );

      if (response.data['message'] == "Signup successful") {
        Get.snackbar(
          "Success",
          "সাইনআপ সফল হয়েছে",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAll(() => const HomeView());
      } else {
        Get.snackbar(
          "Error",
          response.data['message'] ?? "Signup failed",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Signup error: $e");

      Get.snackbar(
        "Error",
        "কিছু ভুল হয়েছে",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
