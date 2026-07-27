import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/appcolor.dart';
import '../../../data/widgets/decorative_background.dart';
import '../../../data/widgets/shimmer_widget.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());

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
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColor.buttonTwoColor,
              size: 22.sp,
            ),
          ),
        ),
      ),
      body: DecorativeBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(() => Column(
                  children: [
                    SizedBox(height: 8.h),

                    // 🔹 Step Indicator
                    _buildStepIndicator(controller),

                    SizedBox(height: 24.h),

                    // 🔹 Step Content
                    if (controller.currentStep.value == 0)
                      _buildPhoneStep(controller)
                    else if (controller.currentStep.value == 1)
                      _buildOtpStep(controller)
                    else
                      _buildResetStep(controller),

                    SizedBox(height: 30.h),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  //  STEP INDICATOR
  // ───────────────────────────────────────────────

  Widget _buildStepIndicator(ForgotPasswordController c) {
    return Column(
      children: [
        // Icon header
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFB96237), Color(0xFFD4845A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.buttonOneColor.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            c.currentStep.value == 2
                ? Icons.lock_reset_rounded
                : Icons.lock_outline_rounded,
            color: Colors.white,
            size: 32.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          c.currentStep.value == 0
              ? "পাসওয়ার্ড ভুলে গেছেন?"
              : c.currentStep.value == 1
                  ? "OTP যাচাই করুন"
                  : "নতুন পাসওয়ার্ড সেট করুন",
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          c.currentStep.value == 0
              ? "আপনার মোবাইল নম্বর দিয়ে OTP পাঠানো হবে"
              : c.currentStep.value == 1
                  ? "আপনার মোবাইলে পাঠানো OTP টি দিন"
                  : "আপনার নতুন পাসওয়ার্ড দুবার দিন",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColor.textSecondary,
          ),
        ),
        SizedBox(height: 24.h),

        // Progress dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final isActive = i <= c.currentStep.value;
            final isCurrent = i == c.currentStep.value;
            return GestureDetector(
              onTap: isActive ? () => c.goToStep(i) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: isCurrent ? 24.w : 10.r,
                height: 10.r,
                decoration: BoxDecoration(
                  gradient: isActive ? AppColor.primaryGradient : null,
                  color: isActive ? null : AppColor.shimmerBase,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: isActive && isCurrent
                    ? Center(
                        child: Text(
                          '${i + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  //  STEP 0: PHONE NUMBER
  // ───────────────────────────────────────────────

  Widget _buildPhoneStep(ForgotPasswordController c) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [AppColor.cardShadow],
      ),
      child: Column(
        children: [
          // Phone icon
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColor.buttonOneColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.phone_android_rounded,
              color: AppColor.buttonOneColor,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 16.h),

          // Phone field
          TextField(
            controller: c.phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            style: GoogleFonts.poppins(fontSize: 14.sp),
            decoration: InputDecoration(
              counterText: "",
              prefixIcon: Icon(
                Icons.phone_rounded,
                color: AppColor.buttonTwoColor,
                size: 20.sp,
              ),
              hintText: "মোবাইল নম্বর",
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
            ),
          ),
          SizedBox(height: 16.h),

          // Send OTP Button
          Obx(() {
            if (c.isLoading.value) {
              return ShimmerWidget.button(height: 44);
            }
            return SizedBox(
              width: double.infinity,
              height: 44.h,
              child: ElevatedButton(
                onPressed: c.sendOtp,
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
                  "OTP পাঠান",
                  style: GoogleFonts.poppins(
                    color: AppColor.textOnPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  //  STEP 1: OTP VERIFICATION
  // ───────────────────────────────────────────────

  Widget _buildOtpStep(ForgotPasswordController c) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [AppColor.cardShadow],
      ),
      child: Column(
        children: [
          // OTP icon
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColor.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.sms_rounded,
              color: AppColor.success,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "OTP এসেছে ${c.phoneController.text} নম্বরে",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              color: AppColor.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          // OTP field
          TextField(
            controller: c.otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              counterText: "",
              hintText: "- - - - - -",
              hintStyle: GoogleFonts.poppins(
                color: AppColor.textLight,
                fontSize: 20.sp,
                letterSpacing: 8,
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
                  color: AppColor.success,
                  width: 1.2,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Verify OTP Button
          Obx(() {
            if (c.isLoading.value) {
              return ShimmerWidget.button(height: 44);
            }
            return SizedBox(
              width: double.infinity,
              height: 44.h,
              child: ElevatedButton(
                onPressed: c.verifyOtp,
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
                  "OTP যাচাই করুন",
                  style: GoogleFonts.poppins(
                    color: AppColor.textOnPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 12.h),

          // Resend OTP
          GestureDetector(
            onTap: () => c.sendOtp(),
            child: RichText(
              text: TextSpan(
                text: "OTP না পেয়েছেন? ",
                style: GoogleFonts.poppins(
                  color: AppColor.textSecondary,
                  fontSize: 12.sp,
                ),
                children: [
                  TextSpan(
                    text: "পুনরায় পাঠান",
                    style: GoogleFonts.poppins(
                      color: AppColor.buttonOneColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  //  STEP 2: RESET PASSWORD
  // ───────────────────────────────────────────────

  Widget _buildResetStep(ForgotPasswordController c) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [AppColor.cardShadow],
      ),
      child: Column(
        children: [
          // Key icon
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColor.buttonTwoColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.key_rounded,
              color: AppColor.buttonTwoColor,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 16.h),

          // New Password field
          Obx(() => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: TextField(
                  controller: c.newPasswordController,
                  obscureText: c.isPasswordHidden.value,
                  style: GoogleFonts.poppins(fontSize: 14.sp),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: AppColor.buttonTwoColor,
                      size: 20.sp,
                    ),
                    hintText: "নতুন পাসওয়ার্ড",
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
                        c.isPasswordHidden.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColor.textSecondary,
                        size: 20.sp,
                      ),
                      onPressed: () => c.isPasswordHidden.toggle(),
                    ),
                  ),
                ),
              )),

          // Confirm Password field
          Obx(() => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: TextField(
                  controller: c.confirmPasswordController,
                  obscureText: c.isConfirmPasswordHidden.value,
                  style: GoogleFonts.poppins(fontSize: 14.sp),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: AppColor.buttonTwoColor,
                      size: 20.sp,
                    ),
                    hintText: "পাসওয়ার্ড নিশ্চিত করুন",
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
                        c.isConfirmPasswordHidden.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColor.textSecondary,
                        size: 20.sp,
                      ),
                      onPressed: () => c.isConfirmPasswordHidden.toggle(),
                    ),
                  ),
                ),
              )),

          // Password hint
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColor.textLight,
                size: 12.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                "কমপক্ষে ৬ অক্ষরের পাসওয়ার্ড দিন",
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color: AppColor.textLight,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Reset Button
          Obx(() {
            if (c.isLoading.value) {
              return ShimmerWidget.button(height: 44);
            }
            return SizedBox(
              width: double.infinity,
              height: 44.h,
              child: ElevatedButton(
                onPressed: c.resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonOneColor,
                  elevation: 2,
                  shadowColor:
                      AppColor.buttonOneColor.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                ),
                child: Text(
                  "পাসওয়ার্ড রিসেট করুন",
                  style: GoogleFonts.poppins(
                    color: AppColor.textOnPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
