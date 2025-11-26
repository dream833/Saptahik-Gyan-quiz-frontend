import 'dart:async';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';
import 'package:quiz/app/data/config/app_cons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz/app/data/config/appcolor.dart';

class LivequizController extends GetxController {
  var quizList = [].obs;
  var isLoading = false.obs;
  var showQuestions = false.obs;

  var selectedQuiz = {}.obs;
  var questionList = [].obs;

  var currentIndex = 0.obs;
  var selectedAnswers = <int, String>{}.obs;

  var timer = 0.obs;
  Timer? quizTimer;

  var isAttempted = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
  try {
    isLoading.value = true;
    final userId = getBox.read("user_id");
    if (userId == null) return;

    final response = await dioPost(endUrl: "/getapp-quiz.php", data: {
      "user_id": userId,
    });

    final data = response.data;
    if (data["status"] == "success") {
      quizList.value = (data["quizzes"] as List).map((q) {
        return {
          ...q,
          "isAttempted": int.tryParse(q["attempted"].toString()) == 1,
        };
      }).toList();
    } else {
      quizList.clear();
    }
  } catch (e) {
    quizList.clear();
  } finally {
    isLoading.value = false;
  }
}
  Future<void> fetchQuestions(dynamic quizId) async {
    try {
      isLoading.value = true;
      final userId = getBox.read("user_id");
      if (userId == null) return;

      final qId = int.tryParse(quizId.toString()) ?? 0;

      final response = await dioPost(
        endUrl: "/get-live-quiz-questions.php",
        data: {"quizid": qId, "user_id": userId},
      );

      final data = response.data;

      if (data["status"] == "success") {
        final attempted = data["quiz"]["attempted"] == 1;

        if (attempted) {
          // prevent opening attempted quiz
          Get.snackbar(
            "Info",
            "You have already attempted this quiz",
            backgroundColor: Colors.grey.shade200,
            colorText: Colors.black87,
          );
          return;
        }

        selectedQuiz.value = data["quiz"] ?? {};
        final questions = data["quiz"]?["questions"];
        questionList.value = questions is List ? questions : [questions];
        currentIndex.value = 0;
        selectedAnswers.clear();

        startTimer(int.tryParse("${selectedQuiz["timer"] ?? 30}") ?? 30);
        showQuestions.value = true;
        isAttempted.value = false;
      } else {
        selectedQuiz.clear();
        questionList.clear();
        showQuestions.value = false;
      }
    } catch (e) {
      selectedQuiz.clear();
      questionList.clear();
      showQuestions.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>? get currentQuestion {
    if (questionList.isNotEmpty && currentIndex.value < questionList.length) {
      return questionList[currentIndex.value] as Map<String, dynamic>;
    }
    return null;
  }

  void startTimer(int seconds) {
    timer.value = seconds;
    quizTimer?.cancel();

    quizTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timer.value > 0) {
        timer.value--;
      } else {
        t.cancel();
        submitQuiz();
      }
    });
  }

  void selectAnswer(dynamic questionId, String option) {
    final qId = int.tryParse(questionId.toString()) ?? 0;
    if (isAttempted.value) return;
    selectedAnswers[qId] = option;
    questionList.refresh();
  }

  void nextQuestion() {
    if (currentIndex.value < questionList.length - 1) currentIndex.value++;
  }

  void previousQuestion() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  Future<void> submitQuiz() async {
    if (isAttempted.value) return;
    try {
      quizTimer?.cancel();

      final quizId = selectedQuiz["quiz_id"];
      final userId = getBox.read("user_id");

      final answersPayload = selectedAnswers.entries
          .map((e) => {"question_id": e.key, "user_answer": e.value})
          .toList();

      final response = await dioPost(
        endUrl: "/submit-quiz.php",
        data: {
          "quizid": quizId,
          "userid": userId,
          "time_taken": timer.value,
          "answers": answersPayload,
        },
      );

      final data = response.data;

      if (data["status"] == "success") {
        isAttempted.value = true;

        // prettier dialog
        Get.dialog(
          Center(
            child: Container(
              width: 0.85.sw,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events,
                      size: 60.sp, color: Colors.amber.shade700),
                  SizedBox(height: 16.h),
                  Text(
                    "Quiz Submitted!",
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.buttonOneColor),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Score: ${data['result']['score']}\n"
                    "Total Questions: ${data['result']['total_questions']}\n"
                    "Correct: ${data['result']['correct_answers']}\n"
                    "Wrong: ${data['result']['wrong_answers']}\n"
                    "Time: ${data['result']['time_taken']} sec",
                    style: TextStyle(fontSize: 18.sp, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonOneColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        backToQuizList();
                      },
                      child: Text(
                        "OK",
                        style:
                            TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar("Error", data["message"] ?? "Failed to submit quiz");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong while submitting quiz");
    }
  }

  void backToQuizList() {
    quizTimer?.cancel();
    showQuestions.value = false;
    selectedQuiz.clear();
    questionList.clear();
    currentIndex.value = 0;
    selectedAnswers.clear();
    isAttempted.value = false;
  }

  @override
  void onClose() {
    quizTimer?.cancel();
    super.onClose();
  }
}