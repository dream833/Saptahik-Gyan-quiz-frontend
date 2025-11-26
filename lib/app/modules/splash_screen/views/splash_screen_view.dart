import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(SplashScreenController());

    return Scaffold(
      backgroundColor: AppColor.buttonTwoColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- Logo Scale + Fade (TweenAnimationBuilder) ----
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.6, end: 1.0),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F1E6),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/splashs.png",
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20.h),

            Obx(() {
              final show = c.showText.value;
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: show ? 1.0 : 0.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(0, show ? 0 : 18, 0),
                  child: Text(
                    "Daily Bengali Quiz : WB PATHSHALA",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      "Cairo Play",
                      textStyle: TextStyle(
                        fontSize: 50.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
