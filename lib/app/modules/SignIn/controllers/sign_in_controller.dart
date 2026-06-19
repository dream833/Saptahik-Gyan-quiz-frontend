import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/app_cons.dart';
import '../../../data/function/dio_post.dart';

class SignInController extends GetxController {
  var mobileController = TextEditingController();
  final passwordController = TextEditingController();
  var isfiled = true.obs;
  var ispwshow = true.obs;
  var isLoading = false.obs;

  Future signIn() async {
    try {
      isLoading.value = true;
      var responses = await dioPost(
        endUrl: "/applogin.php",
        data: {
          "phone": mobileController.text,
          "password": passwordController.text,
        },
      );

      log("Response: ${responses.data}");

      if (responses.data['message'] == "Login successful") {
        getBox.write(IS_USER_LOGGED_IN, true);
        getBox.write(USER_ID, responses.data['data']['user']['id']);

        log("IS_USER_LOGGED_IN: ${getBox.read(IS_USER_LOGGED_IN)}");
        log("USER_ID: ${getBox.read(USER_ID)}");

        Get.snackbar(
          "Success",
          "Login Successful",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed("/home");
      } else {
        Get.snackbar(
          "Error",
          responses.data['message'] ?? "Login Failed",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Login Error: $e");
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
