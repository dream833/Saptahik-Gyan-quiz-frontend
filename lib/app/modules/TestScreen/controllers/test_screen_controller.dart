import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_cons.dart';
import '../../../data/config/appcolor.dart';
import '../../../data/models/mock_data.dart';

class TestScreenController extends GetxController {
  // Timer
  final totalSeconds = 200; // 3 minutes 20 seconds
  var remainingSeconds = 200.obs;
  late Timer _timer;
  var isTimerRunning = false.obs;

  // Questions
  var questions = <Question>[].obs;
  var currentQuestionIndex = 0.obs;
  var selectedAnswers = <int, int>{}.obs; // question index -> selected option index

  // Results
  var isTestCompleted = false.obs;
  var score = 0.obs;
  var correctCount = 0.obs;
  var wrongCount = 0.obs;
  var unansweredCount = 0.obs;
  var timeTaken = 0.obs;

  // Arguments
  late MockTestInfo testInfo;
  late String className;
  late String subjectName;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    testInfo = args['test'] as MockTestInfo;
    className = args['className'] as String;

    final subjectArg = args['subject'];
    if (subjectArg is AppSubject) {
      subjectName = subjectArg.name;
    } else {
      subjectName = subjectArg?.toString() ?? '';
    }

    // Use custom questions if provided, otherwise generate sample
    final customQuestions = args['questions'] as List<Question>?;
    if (customQuestions != null && customQuestions.isNotEmpty) {
      questions.value = customQuestions;
    } else {
      questions.value = Question.generateSample();
    }
    _startTimer();
  }

  void _startTimer() {
    isTimerRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _submitTest();
      }
    });
  }

  String get formattedTime {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get progressValue => remainingSeconds.value / totalSeconds;

  int get totalQuestions => questions.length;

  Question get currentQuestion => questions[currentQuestionIndex.value];

  int? get selectedAnswerForCurrent => selectedAnswers[currentQuestionIndex.value];

  bool get isLastQuestion => currentQuestionIndex.value == totalQuestions - 1;

  bool get isFirstQuestion => currentQuestionIndex.value == 0;

  void selectAnswer(int optionIndex) {
    selectedAnswers[currentQuestionIndex.value] = optionIndex;
    // Auto-advance after selection with a short delay
    if (!isLastQuestion) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (isTimerRunning.value) {
          nextQuestion();
        }
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < totalQuestions - 1) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      currentQuestionIndex.value = index;
    }
  }

  void submitTest() {
    _submitTest();
  }

  void _submitTest() {
    _timer.cancel();
    isTimerRunning.value = false;
    timeTaken.value = totalSeconds - remainingSeconds.value;

    // Calculate results
    int correct = 0;
    int wrong = 0;
    int unanswered = 0;

    for (int i = 0; i < totalQuestions; i++) {
      if (selectedAnswers.containsKey(i)) {
        if (selectedAnswers[i] == questions[i].correctIndex) {
          correct++;
        } else {
          wrong++;
        }
      } else {
        unanswered++;
      }
    }

    correctCount.value = correct;
    wrongCount.value = wrong;
    unansweredCount.value = unanswered;
    score.value = correct * 2; // 2 marks per correct answer
    isTestCompleted.value = true;

    // Show the thank you popup dialog
    _showThankYouDialog();
  }

  void _showThankYouDialog() {
    final showButtons = false.obs;

    // Show buttons after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      showButtons.value = true;
    });

    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Obx(() {
            return Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thank You section
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: 1.0,
                    child: Column(
                      children: [
                        // Checkmark icon
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColor.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.buttonOneColor.withValues(alpha: 0.3),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 36.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Thank You!',
                          style: GoogleFonts.poppins(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Your test has been submitted',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            color: AppColor.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Score: ${score.value}/${totalQuestions * 2}',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.buttonOneColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Divider
                  Container(
                    height: 1.h,
                    color: AppColor.cardBorder,
                  ),

                  SizedBox(height: 20.h),

                  // Action buttons (appear after 1.5s)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: showButtons.value ? 1.0 : 0.0,
                    child: showButtons.value
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Check Answers
                              _actionButton(
                                icon: Icons.rate_review_rounded,
                                label: 'Check Answers',
                                color: AppColor.buttonTwoColor,
                                onTap: () {
                                  Get.back(); // close dialog
                                  // Navigate to answer review
                                  Get.to(
                                    () => _AnswerReviewScreen(
                                      controller: this,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 12.h),
                              // Retake Test
                              _actionButton(
                                icon: Icons.refresh_rounded,
                                label: 'Retake Test',
                                color: AppColor.buttonOneColor,
                                onTap: () {
                                  Get.back(); // close dialog
                                  retakeTest();
                                },
                              ),
                              SizedBox(height: 12.h),
                              // Share
                              _actionButton(
                                icon: Icons.share_rounded,
                                label: 'Share App',
                                color: const Color(0xFF1565C0),
                                onTap: () {
                                  shareApp();
                                  Get.back(); // close dialog
                                },
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 120.h,
                            child: Center(
                              child: Text(
                                'Preparing your results...',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColor.textLight,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void retakeTest() {
    // Reset all state
    remainingSeconds.value = totalSeconds;
    currentQuestionIndex.value = 0;
    selectedAnswers.clear();
    isTestCompleted.value = false;
    score.value = 0;
    correctCount.value = 0;
    wrongCount.value = 0;
    unansweredCount.value = 0;
    timeTaken.value = 0;

    // Regenerate questions
    questions.value = Question.generateSample();
    _startTimer();
  }

  void shareApp() {
    final appLink = 'https://saptahikgyan.space/quizadmin';
    Clipboard.setData(ClipboardData(text: appLink));
    Showsnackbar(message: 'App link copied to clipboard!', isSuccess: true);
  }

  Color getAnswerColor(int questionIndex, int optionIndex) {
    if (!isTestCompleted.value) {
      if (selectedAnswers[questionIndex] == optionIndex) {
        return AppColor.buttonOneColor;
      }
      return Colors.transparent;
    }

    // Show results
    final question = questions[questionIndex];
    if (optionIndex == question.correctIndex) {
      return AppColor.success;
    }
    if (selectedAnswers[questionIndex] == optionIndex && optionIndex != question.correctIndex) {
      return AppColor.error;
    }
    return Colors.transparent;
  }

  Color getAnswerTextColor(int questionIndex, int optionIndex) {
    if (!isTestCompleted.value) {
      if (selectedAnswers[questionIndex] == optionIndex) {
        return Colors.white;
      }
      return AppColor.textPrimary;
    }

    final question = questions[questionIndex];
    if (optionIndex == question.correctIndex) {
      return Colors.white;
    }
    if (selectedAnswers[questionIndex] == optionIndex && optionIndex != question.correctIndex) {
      return Colors.white;
    }
    return AppColor.textPrimary;
  }

  bool isOptionCorrect(int questionIndex, int optionIndex) {
    return questions[questionIndex].correctIndex == optionIndex;
  }

  bool isOptionWrong(int questionIndex, int optionIndex) {
    return selectedAnswers[questionIndex] == optionIndex &&
        optionIndex != questions[questionIndex].correctIndex;
  }

  @override
  void onClose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.onClose();
  }
}

// ───────────────────────────────────────────────
//  ANSWER REVIEW SCREEN
// ───────────────────────────────────────────────

class _AnswerReviewScreen extends StatelessWidget {
  final TestScreenController controller;

  const _AnswerReviewScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: AppColor.cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [AppColor.softShadow],
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 22.sp,
                        color: AppColor.buttonTwoColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Answer Review',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.totalQuestions,
                itemBuilder: (context, qIndex) {
                  final question = controller.questions[qIndex];
                  final selected = controller.selectedAnswers[qIndex];
                  final isCorrect = selected == question.correctIndex;
                  final isUnanswered = selected == null;

                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColor.cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isUnanswered
                            ? AppColor.textLight.withValues(alpha: 0.3)
                            : isCorrect
                                ? AppColor.success.withValues(alpha: 0.3)
                                : AppColor.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isUnanswered
                                    ? AppColor.textLight.withValues(alpha: 0.1)
                                    : isCorrect
                                        ? AppColor.success.withValues(alpha: 0.1)
                                        : AppColor.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Q${qIndex + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isUnanswered
                                      ? AppColor.textLight
                                      : isCorrect
                                          ? AppColor.success
                                          : AppColor.error,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (!isUnanswered)
                              Icon(
                                isCorrect
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: isCorrect ? AppColor.success : AppColor.error,
                                size: 18.sp,
                              ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          question.text,
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ...List.generate(question.options.length, (optIndex) {
                          final isSelected = selected == optIndex;
                          final isRight = question.correctIndex == optIndex;

                          return Container(
                            margin: EdgeInsets.only(bottom: 6.h),
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isRight
                                  ? AppColor.success.withValues(alpha: 0.1)
                                  : isSelected && !isRight
                                      ? AppColor.error.withValues(alpha: 0.1)
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: isRight
                                    ? AppColor.success.withValues(alpha: 0.5)
                                    : isSelected && !isRight
                                        ? AppColor.error.withValues(alpha: 0.5)
                                        : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isRight
                                      ? Icons.check_circle_rounded
                                      : isSelected && !isRight
                                          ? Icons.cancel_rounded
                                          : Icons.radio_button_unchecked_rounded,
                                  size: 14.sp,
                                  color: isRight
                                      ? AppColor.success
                                      : isSelected && !isRight
                                          ? AppColor.error
                                          : AppColor.textLight,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  question.options[optIndex],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: isRight
                                        ? AppColor.success
                                        : isSelected && !isRight
                                            ? AppColor.error
                                            : AppColor.textPrimary,
                                    fontWeight: isRight || (isSelected && !isRight)
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
