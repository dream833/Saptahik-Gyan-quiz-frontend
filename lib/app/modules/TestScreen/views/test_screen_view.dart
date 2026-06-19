import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/appcolor.dart';
import '../../../data/widgets/decorative_background.dart';
import '../controllers/test_screen_controller.dart';

class TestScreenView extends StatelessWidget {
  const TestScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TestScreenController>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: _buildQuizScreen(controller),
    );
  }

  // ───────────────────────────────────────────
  //  QUIZ SCREEN
  // ───────────────────────────────────────────

  Widget _buildQuizScreen(TestScreenController controller) {
    return DecorativeBackground(
      child: SafeArea(
        child: Column(
          children: [
            // Top bar: Question number + Timer
            _buildTopBar(controller),
            // Timer progress bar
            _buildTimerBar(controller),
            // Question content
            Expanded(
              child: _buildQuestionContent(controller),
            ),
            // Bottom navigation
            _buildBottomNav(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(TestScreenController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => _showExitDialog(controller),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [AppColor.softShadow],
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColor.error,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Question number - Top Left
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${controller.currentQuestionIndex.value + 1} / ${controller.totalQuestions}',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),

          const Spacer(),

          // Timer - Top Right
          Obx(() {
            final timeColor = controller.remainingSeconds.value <= 30
                ? AppColor.error
                : controller.remainingSeconds.value <= 60
                    ? AppColor.warning
                    : AppColor.buttonTwoColor;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [AppColor.softShadow],
                border: Border.all(
                  color: timeColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_rounded,
                    color: timeColor,
                    size: 18.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    controller.formattedTime,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: timeColor,
                    ),
                  ),
                ],
              ),
            );
          }),


        ],
      ),
    );
  }

  Widget _buildTimerBar(TestScreenController controller) {
    return Obx(() {
      final progress = controller.progressValue;
      final timeColor = controller.remainingSeconds.value <= 30
          ? AppColor.error
          : controller.remainingSeconds.value <= 60
              ? AppColor.warning
              : AppColor.buttonTwoColor;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColor.shimmerBase,
            valueColor: AlwaysStoppedAnimation<Color>(timeColor),
            minHeight: 4.h,
          ),
        ),
      );
    });
  }

  Widget _buildQuestionContent(TestScreenController controller) {
    return Obx(() {
      final question = controller.currentQuestion;
      final selectedIdx = controller.selectedAnswerForCurrent;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question text
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [AppColor.cardShadow],
                border: Border.all(color: AppColor.cardBorder),
              ),
              child: Text(
                question.text,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 18.h),

            // Options
            ...List.generate(question.options.length, (index) {
              final isSelected = selectedIdx == index;
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: GestureDetector(
                  onTap: () => controller.selectAnswer(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.buttonOneColor.withValues(alpha: 0.1)
                          : AppColor.cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.buttonOneColor
                            : AppColor.cardBorder,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? [AppColor.softShadow] : [],
                    ),
                    child: Row(
                      children: [
                        // Option letter
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.buttonOneColor
                                : AppColor.backgroundColorLight,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index),
                              style: GoogleFonts.poppins(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : AppColor.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Text(
                            question.options[index],
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? AppColor.buttonOneColor : AppColor.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColor.buttonOneColor,
                            size: 20.sp,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildBottomNav(TestScreenController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button
          Obx(() {
            final isFirst = controller.isFirstQuestion;
            return GestureDetector(
              onTap: isFirst ? null : () => controller.previousQuestion(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isFirst
                      ? AppColor.shimmerBase
                      : AppColor.cardColor,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isFirst ? Colors.transparent : AppColor.buttonTwoColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      size: 16.sp,
                      color: isFirst ? AppColor.textLight : AppColor.buttonTwoColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Previous',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isFirst ? AppColor.textLight : AppColor.buttonTwoColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const Spacer(),

          // Next / Submit button
          Obx(() {
            final isLast = controller.isLastQuestion;
            if (isLast) {
              return GestureDetector(
                onTap: () => _showSubmitConfirmation(controller),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    gradient: AppColor.primaryGradient,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [AppColor.buttonShadow],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Submit',
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.check_circle_rounded, size: 16.sp, color: Colors.white),
                    ],
                  ),
                ),
              );
            }

            return GestureDetector(
              onTap: () => controller.nextQuestion(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: AppColor.navyGradient,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [AppColor.buttonShadowNavy],
                ),
                child: Row(
                  children: [
                    Text(
                      'Next',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(Icons.arrow_forward_rounded, size: 16.sp, color: Colors.white),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }


  // ───────────────────────────────────────────
  //  SUBMIT CONFIRMATION
  // ───────────────────────────────────────────

  void _showSubmitConfirmation(TestScreenController controller) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flag_rounded,
                  color: AppColor.warning,
                  size: 36.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Submit Test?',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() {
                final answered = controller.selectedAnswers.length;
                final unanswered = controller.totalQuestions - answered;
                return Text(
                  '$answered answered, $unanswered unanswered',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColor.textSecondary,
                  ),
                );
              }),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColor.shimmerBase,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: Text(
                            'Review',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        controller.submitTest();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          gradient: AppColor.primaryGradient,
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [AppColor.buttonShadow],
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  //  EXIT CONFIRMATION
  // ───────────────────────────────────────────

  void _showExitDialog(TestScreenController controller) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColor.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.exit_to_app_rounded,
                  color: AppColor.error,
                  size: 36.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Exit Test?',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your progress will be lost',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColor.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColor.shimmerBase,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColor.error,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Center(
                          child: Text(
                            'Exit',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
