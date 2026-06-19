import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/config/appcolor.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: 'Learner');
    final emailController = TextEditingController(text: 'learner@example.com');
    final phoneController = TextEditingController(text: '+91 98765 43210');
    final gradeController = TextEditingController(text: 'Class 10');
    final bioController = TextEditingController(
        text: 'Passionate learner exploring new subjects every day.');

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
        title: Text('Edit Profile',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary)),
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(children: [
                    Icon(Icons.check_rounded, color: Colors.white, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text('Profile updated!',
                        style: GoogleFonts.poppins(fontSize: 12.sp)),
                  ]),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  backgroundColor: AppColor.success,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(8.r),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text('Save',
                  style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.r),
        child: Column(children: [
          // Avatar
          Center(
            child: Stack(children: [
              Container(
                width: 90.r,
                height: 90.r,
                decoration: BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [AppColor.buttonShadow],
                ),
                child: Center(
                    child: Text('L',
                        style: GoogleFonts.poppins(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white))),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColor.cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [AppColor.softShadow],
                  ),
                  child: Icon(Icons.camera_alt_rounded,
                      color: AppColor.buttonOneColor, size: 18.sp),
                ),
              ),
            ]),
          ),
          SizedBox(height: 28.h),

          // Name
          _buildField('Full Name', nameController, Icons.person_outline_rounded),
          SizedBox(height: 14.h),

          // Email
          _buildField('Email Address', emailController, Icons.email_outlined),
          SizedBox(height: 14.h),

          // Phone
          _buildField('Phone Number', phoneController, Icons.phone_outlined),
          SizedBox(height: 14.h),

          // Grade / Class
          _buildField('Class / Grade', gradeController, Icons.school_outlined),
          SizedBox(height: 14.h),

          // Bio
          _buildField('About Me', bioController, Icons.info_outline_rounded,
              maxLines: 3),
          SizedBox(height: 32.h),
        ]),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller,
      IconData icon,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [AppColor.softShadow],
        border: Border.all(color: AppColor.cardBorder),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColor.buttonTwoColor, size: 20.sp),
          labelText: label,
          labelStyle: GoogleFonts.poppins(
              fontSize: 12.sp, color: AppColor.textSecondary),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}
