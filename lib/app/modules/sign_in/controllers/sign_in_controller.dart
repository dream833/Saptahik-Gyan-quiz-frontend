import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/app_cons.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';
import 'package:quiz/app/modules/home/views/home_view.dart';

class SignInController extends GetxController {
  var mobileController = TextEditingController();
  final passwordController = TextEditingController();
  var isfiled = true.obs;

  Future signIn() async {
    try {
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

        Get.offAll(() => const HomeView());
        Get.snackbar(
          "Success",
          "Login Successful",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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
    }
  }
}
