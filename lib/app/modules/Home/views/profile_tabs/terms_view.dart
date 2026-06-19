import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/config/appcolor.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

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
        title: Text('Terms & Conditions',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  gradient: AppColor.navyGradient,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [AppColor.buttonShadowNavy],
                ),
                child: Icon(Icons.description_rounded,
                    color: Colors.white, size: 36.sp),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text('Terms & Conditions',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary)),
            ),
            SizedBox(height: 4.h),
            Center(
              child: Text('Last updated: June 2026',
                  style: GoogleFonts.poppins(
                      fontSize: 10.sp, color: AppColor.textLight)),
            ),
            SizedBox(height: 28.h),

            _section('1. Acceptance of Terms',
                'By accessing and using WB PATHSHALA, you agree to comply with and be bound by these Terms and Conditions. '
                    'If you do not agree with any part of these terms, you must not use our platform.'),
            SizedBox(height: 20.h),

            _section('2. User Accounts',
                'To access certain features, you must create an account. You are responsible for maintaining the confidentiality '
                    'of your login credentials and for all activities under your account. You must provide accurate and complete '
                    'information during registration.'),
            SizedBox(height: 20.h),

            _section('3. Educational Content',
                'All educational content provided on WB PATHSHALA is for personal learning purposes only. '
                    'You may not reproduce, distribute, or commercialize the content without prior written consent. '
                    'While we strive for accuracy, we do not guarantee that all content is error-free.'),
            SizedBox(height: 20.h),

            _section('4. User Conduct',
                'You agree to use the platform responsibly. Prohibited activities include:\n'
                    '• Sharing account credentials with others\n'
                    '• Attempting to manipulate test results\n'
                    '• Using the platform for any unlawful purpose\n'
                    '• Uploading malicious content\n'
                    '• Harassing other users or staff'),
            SizedBox(height: 20.h),

            _section('5. Privacy Policy',
                'Your privacy is important to us. We collect and store personal information as described in our Privacy Policy. '
                    'By using the platform, you consent to our data practices outlined in the Privacy Policy.'),
            SizedBox(height: 20.h),

            _section('6. Intellectual Property',
                'All trademarks, logos, and content on WB PATHSHALA are the property of their respective owners. '
                    'The platform name, logo, and design are protected by applicable copyright and trademark laws.'),
            SizedBox(height: 20.h),

            _section('7. Limitation of Liability',
                'WB PATHSHALA shall not be liable for any indirect, incidental, or consequential damages arising from '
                    'your use of the platform. We provide the service "as is" without any warranty of any kind.'),
            SizedBox(height: 20.h),

            _section('8. Modifications',
                'We reserve the right to modify these terms at any time. Changes will be effective immediately upon posting. '
                    'Your continued use of the platform after any modifications constitutes acceptance of the new terms.'),
            SizedBox(height: 20.h),

            _section('9. Termination',
                'We may suspend or terminate your access to the platform at any time for violations of these terms, '
                    'without prior notice. Upon termination, your right to use the platform will immediately cease.'),
            SizedBox(height: 20.h),

            _section('10. Contact',
                'For any questions regarding these Terms & Conditions, please contact us at:\n'
                    'Email: support@wbpathshala.com\n'
                    'Website: www.wbpathshala.com'),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary)),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColor.cardBorder),
          ),
          child: Text(content,
              style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary,
                  height: 1.7)),
        ),
      ],
    );
  }
}
