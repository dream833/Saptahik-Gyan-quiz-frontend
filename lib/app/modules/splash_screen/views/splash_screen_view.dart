import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:quiz/app/data/config/appimage.dart';
import 'package:quiz/app/modules/home/views/home_view.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
@override
Widget build(BuildContext context) {
  Future.delayed(Duration(seconds: 3), () {
    Get.offAll(HomeView());
  },);

  return Scaffold(
    backgroundColor: Colors.lightGreen,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Image(
            image: AssetImage(Appimage.bglogo),
            width: Get.width,
            height: 300.h,
          )
        ],
      ),
    ),
  );
}
}