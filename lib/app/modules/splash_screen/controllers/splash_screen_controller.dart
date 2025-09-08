import 'dart:async';
import 'package:get/get.dart';
import 'package:quiz/app/modules/SignUp/views/sign_up_view.dart';
import 'package:quiz/app/modules/home/views/home_view.dart'; // যদি HomeView আলready থাকে

class SplashScreenController extends GetxController {
  final RxBool showText = false.obs;

  @override
  void onInit() {
    super.onInit();


    Future.delayed(const Duration(milliseconds: 800), () {
      showText.value = true;
    });

    Future.delayed(const Duration(seconds: 4), () {
    
      Get.offAll(() => const SignUpView());
    });
  }
}