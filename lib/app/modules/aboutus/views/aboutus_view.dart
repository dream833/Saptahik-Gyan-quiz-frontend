import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/appcolor.dart';

import '../controllers/aboutus_controller.dart';

class AboutusView extends GetView<AboutusController> {
  const AboutusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: AppColor.buttonOneColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// App Intro
              Text(
                "Welcome to Daily Bengali Quiz : WB PATHSHALA",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16.h),

              Text(
                "Your trusted companion for daily learning and job preparation. "
                "We provide high-quality quizzes, study notes, and practice materials "
                "designed to help students and job aspirants improve their general "
                "knowledge and academic understanding.",
                style: TextStyle(fontSize: 16.sp, height: 1.5),
              ),

              SizedBox(height: 16.h),

              Text(
                "Our mission is to make education engaging, accessible, and bilingual "
                "— offering content in Bengali. Whether you’re preparing for school exams "
                "or competitive tests, you’ll find everything you need here to stay ahead.",
                style: TextStyle(fontSize: 16.sp, height: 1.5),
              ),

              SizedBox(height: 16.h),

              Text(
                "Stay consistent. Learn daily. Grow smarter with "
                "Daily Bengali Quiz : WB PATHSHALA!",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),

              SizedBox(height: 28.h),

              /// Divider
              Divider(thickness: 1),

              SizedBox(height: 20.h),

              /// Disclaimer Title
              Text(
                "Disclaimer",
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12.h),

              /// Disclaimer Text (Policy Safe)
              Text(
                "Daily Bengali Quiz : WB PATHSHALA is an independent educational "
                "and quiz application. This app is not affiliated with, endorsed by, "
                "or representing any government entity or organization.\n\n"
                "All quiz questions, study materials, and practice content are provided "
                "for educational and informational purposes only.\n\n"
                "Some content may be based on publicly available educational and general "
                "knowledge information.",
                style: TextStyle(fontSize: 25.sp, height: 1.6),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
