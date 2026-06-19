import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/appcolor.dart';
import '../../../data/widgets/decorative_background.dart';
import '../../../data/widgets/shimmer_widget.dart';
import '../../SignUp/views/sign_up_view.dart';
import '../controllers/sign_in_controller.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: DecorativeBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),

                // 🔹 Logo - smaller
                const AppLogo(size: 65),
                SizedBox(height: 14.h),

                // 🔹 Welcome Text - smaller
                Text(
                  "Welcome Back",
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Sign in to continue",
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
                SizedBox(height: 24.h),

                // 🔹 Form Card - tighter padding
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
                      // Mobile Field - tighter
                      _buildTextField(
                        controller.mobileController,
                        "Mobile Number",
                        Icons.phone_rounded,
                        AppColor.buttonTwoColor,
                        maxLength: 10,
                      ),

                      // Password Field - tighter
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: TextField(
                            controller: controller.passwordController,
                            obscureText: !controller.ispwshow.value,
                            style: GoogleFonts.poppins(fontSize: 14.sp),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: AppColor.buttonTwoColor,
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
                                  color: AppColor.buttonTwoColor,
                                  width: 1.2,
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.ispwshow.value
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: AppColor.textSecondary,
                                  size: 20.sp,
                                ),
                                onPressed: () {
                                  controller.ispwshow.toggle();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Sign In Button - smaller height
                      Obx(() {
                        if (controller.isLoading.value) {
                          return ShimmerWidget.button(height: 44);
                        }
                        return SizedBox(
                          width: double.infinity,
                          height: 44.h,
                          child: ElevatedButton(
                            onPressed: controller.signIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.buttonTwoColor,
                              elevation: 2,
                              shadowColor:
                                  AppColor.buttonTwoColor.withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.r),
                              ),
                            ),
                            child: Text(
                              "SIGN IN",
                              style: GoogleFonts.poppins(
                                color: AppColor.textOnPrimary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // 🔹 Sign Up Link - simpler
                GestureDetector(
                  onTap: () => Get.to(() => SignUpView()),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.poppins(
                        color: AppColor.textSecondary,
                        fontSize: 13.sp,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: GoogleFonts.poppins(
                            color: AppColor.buttonOneColor,
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
    IconData icon,
    Color accentColor, {
    int? maxLength,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        maxLength: maxLength,
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 14.sp),
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: Icon(icon, color: accentColor, size: 20.sp),
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
              color: accentColor,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
