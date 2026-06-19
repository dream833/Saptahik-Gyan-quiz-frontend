import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/config/appcolor.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [AppColor.softShadow],
            ),
            child: Icon(Icons.arrow_back_rounded,
                color: AppColor.buttonTwoColor, size: 22.sp),
          ),
        ),
        title: Text('About',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        child: Column(children: [
          // Logo
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [AppColor.buttonShadow],
            ),
            child: Center(
                child: Text('WB',
                    style: GoogleFonts.poppins(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white))),
          ),
          SizedBox(height: 16.h),
          Text('WB PATHSHALA',
              style: GoogleFonts.poppins(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary)),
          SizedBox(height: 4.h),
          Text('Learn & Grow',
              style: GoogleFonts.poppins(
                  fontSize: 13.sp, color: AppColor.textSecondary)),
          SizedBox(height: 8.h),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColor.buttonOneColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text('Version 1.0.0',
                style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.buttonOneColor)),
          ),
          SizedBox(height: 28.h),

          // Description
          _infoCard(
            icon: Icons.info_outline_rounded,
            title: 'About the App',
            content:
                'WB PATHSHALA is a comprehensive learning platform designed for students in West Bengal. '
                'We provide chapter-wise questions, previous year papers, study suggestions, '
                'and daily mock tests to help students prepare effectively for their exams.',
          ),
          SizedBox(height: 14.h),

          // Features
          _infoCard(
            icon: Icons.star_rounded,
            title: 'Key Features',
            content:
                '• Chapter-wise Q&A with detailed answers\n'
                '• Previous year question papers with solutions\n'
                '• Daily mock tests for practice\n'
                '• Expert study suggestions\n'
                '• Copy & share functionality\n'
                '• Multi-class and subject support',
          ),
          SizedBox(height: 14.h),

          // Contact
          _infoCard(
            icon: Icons.mail_outline_rounded,
            title: 'Contact Us',
            content: 'support@wbpathshala.com\n'
                'www.wbpathshala.com',
          ),
          SizedBox(height: 28.h),

          // Footer
          Center(
            child: Text('Made with ❤️ for students of West Bengal',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 11.sp, color: AppColor.textLight)),
          ),
        ]),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [AppColor.cardShadow],
        border: Border.all(color: AppColor.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColor.buttonTwoColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon,
                  color: AppColor.buttonTwoColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary)),
          ]),
          SizedBox(height: 12.h),
          Text(content,
              style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary,
                  height: 1.6)),
        ],
      ),
    );
  }
}
