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
        endUrl: "/login.php",
        data: {
          "mobile": mobileController.text,
          "password": passwordController.text,
        },
      );

      log("Response: ${responses.data}");

      if (responses.data['status'] == true) {
        getBox.write(IS_USER_LOGGED_IN, true);
        getBox.write(USER_ID, responses.data['user']['id'].toString());

        log("IS_USER_LOGGED_IN: ${getBox.read(IS_USER_LOGGED_IN)}");
        log("USER_ID: ${getBox.read(USER_ID)}");

        Get.snackbar(
          "Success",
          responses.data['message'] ?? "Login Successful",
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
