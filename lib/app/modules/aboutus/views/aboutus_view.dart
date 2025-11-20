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
        padding: EdgeInsets.all(16.0.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Welcome to Daily Bengali Quiz : WB PATHSHALA",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              Text(
                "Your trusted companion for daily learning and job preparation. "
                "We provide high-quality quizzes, study notes, and practice materials "
                "designed to help students and job aspirants improve their general "
                "knowledge and academic understanding.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 16),

              Text(
                "Our mission is to make education engaging, accessible, and bilingual "
                "— offering content in Bengali. Whether you’re preparing for school exams "
                "or competitive tests, you’ll find everything you need here to stay ahead.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 16),

              Text(
                "Stay consistent. Learn daily. Grow smarter with "
                "Daily Bengali Quiz : WB PATHSHALA!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
