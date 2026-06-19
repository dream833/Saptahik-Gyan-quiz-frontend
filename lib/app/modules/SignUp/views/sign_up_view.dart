import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/appcolor.dart';
import '../../../data/widgets/decorative_background.dart';
import '../../../data/widgets/shimmer_widget.dart';
import '../../SignIn/views/sign_in_view.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: DecorativeBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 30.h),

                // 🔹 Logo - smaller
                const AppLogo(size: 55),
                SizedBox(height: 12.h),

                // 🔹 Title - smaller
                Text(
                  "Create Account",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Join WB PATHSHALA today",
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
                SizedBox(height: 20.h),

                // 🔹 Form Card - tighter
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.r),
                  decoration: BoxDecoration(
                    color: AppColor.cardColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [AppColor.cardShadow],
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller.nameController,
                        "Full Name",
                        Icons.person_rounded,
                      ),
                      _buildTextField(
                        controller.emailController,
                        "Email Address",
                        Icons.email_rounded,
                      ),
                      _buildTextField(
                        controller.mobileController,
                        "Mobile Number",
                        Icons.phone_rounded,
                        maxLength: 10,
                      ),
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: TextField(
                            controller: controller.passwordController,
                            obscureText: controller.isPasswordHidden.value,
                            style: GoogleFonts.poppins(fontSize: 14.sp),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: AppColor.buttonOneColor,
                                size: 20.sp,
                              ),
                              hintText: "Password",
                              hintStyle: GoogleFonts.poppins(
                                color: AppColor.textLight,
                                fontSize: 13.sp,
                              ),
                              filled: true,
                              fillColor: AppColor.backgroundColorLight,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: AppColor.buttonOneColor,
                                  width: 1.2,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordHidden.value
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: AppColor.textSecondary,
                                  size: 20.sp,
                                ),
                                onPressed: () {
                                  controller.isPasswordHidden.toggle();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Sign Up Button - smaller
                      Obx(() {
                        if (controller.isLoading.value) {
                          return ShimmerWidget.button(height: 44);
                        }
                        return SizedBox(
                          width: double.infinity,
                          height: 44.h,
                          child: ElevatedButton(
                            onPressed: controller.signUp,
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor: AppColor.buttonOneColor,
                              shadowColor:
                                  AppColor.buttonOneColor.withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.r),
                              ),
                            ),
                            child: Text(
                              "SIGN UP",
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: AppColor.textOnPrimary,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // 🔹 Sign In Link - simpler
                GestureDetector(
                  onTap: () => Get.to(() => const SignInView()),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: GoogleFonts.poppins(
                        color: AppColor.textSecondary,
                        fontSize: 13.sp,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign In",
                          style: GoogleFonts.poppins(
                            color: AppColor.buttonTwoColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    int? maxLength,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        style: GoogleFonts.poppins(fontSize: 14.sp),
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: Icon(icon, color: AppColor.buttonOneColor, size: 20.sp),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: AppColor.textLight,
            fontSize: 13.sp,
          ),
          filled: true,
          fillColor: AppColor.backgroundColorLight,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColor.buttonOneColor,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
