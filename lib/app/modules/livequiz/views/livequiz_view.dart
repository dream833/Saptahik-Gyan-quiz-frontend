import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import 'package:quiz/app/modules/livequiz/controllers/livequiz_controller.dart';

class LivequizView extends GetView<LivequizController> {
  const LivequizView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(LivequizController());

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.buttonOneColor,
        centerTitle: true,
        title: Obx(() => Text(
              c.showQuestions.value ? (c.selectedQuiz["title"] ?? "") : "Live Quizzes",
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        leading: Obx(() => c.showQuestions.value
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => c.backToQuizList(),
              )
            : const SizedBox()),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ---------------- QUIZ LIST ----------------
        if (!c.showQuestions.value) {
          if (c.quizList.isEmpty) {
            return Center(
              child: Text(
                "No quizzes available right now.",
                style: TextStyle(fontSize: 40.w, color: Colors.grey),
              ),
            );
          }

          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: c.quizList.length,
              itemBuilder: (context, index) {
                final quiz = c.quizList[index];
                final attempted = quiz["isAttempted"] ?? false;
                final quizTimer = quiz["timer"] ?? 0;

                return GestureDetector(
                  onTap: attempted
                      ? null
                      : () => c.fetchQuestions(quiz["quiz_id"].toString()),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: attempted ? Colors.grey.shade200 : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title + Timer
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quiz["title"] ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: attempted ? Colors.grey : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.timer,
                                    size: 16, color: Colors.grey.shade700),
                                const SizedBox(width: 6),
                                Text(
                                  "$quizTimer sec",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Lock or Arrow
                        attempted
                            ? const Icon(Icons.lock, color: Colors.red)
                            : Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: AppColor.buttonOneColor,
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        // ---------------- QUIZ QUESTIONS ----------------
        if (c.selectedQuiz.isEmpty || c.questionList.isEmpty) {
          return const Center(child: Text("No quiz details found."));
        }

        final q = c.currentQuestion;
        if (q == null) return const SizedBox();

        return SafeArea(
          child: Column(
            children: [
              // TIMER CIRCLE
              Padding(
                padding: EdgeInsets.all(50.sp),
                child: Obx(() => Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.buttonTwoColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${c.timer.value}",
                        style: TextStyle(
                          fontSize: 50.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )),
              ),

              // QUESTIONS
              Expanded(
                child: Obx(() {
                  final question = c.currentQuestion;
                  if (question == null) return const SizedBox();

                  final attempted = c.isAttempted.value;

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(34.sp),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // QUESTION TEXT
                            Text(
                              "${c.currentIndex.value + 1}. ${question["question"]}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),

                            // OPTIONS
                            ...["A", "B", "C", "D"].map((optKey) {
                              final optionText =
                                  question["option_${optKey.toLowerCase()}"];
                              final isSelected = c.selectedAnswers[
                                      question["question_id"]] ==
                                  optKey;

                              return GestureDetector(
                                onTap: attempted
                                    ? null
                                    : () => c.selectAnswer(
                                        question["question_id"], optKey),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColor.buttonOneColor
                                            .withOpacity(0.2)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColor.buttonOneColor
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    "$optKey. $optionText",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected
                                          ? AppColor.buttonTwoColor
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),

              // ---------- BOTTOM BUTTONS ----------
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (c.currentIndex.value > 0)
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: c.previousQuestion,
                          icon: const Icon(Icons.arrow_back),
                          label: const Text("Previous"),
                        ),
                      ),
                    if (c.currentIndex.value > 0) const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.buttonOneColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: c.currentIndex.value < c.questionList.length - 1
                            ? c.nextQuestion
                            : c.submitQuiz,
                        icon: Icon(
                          c.currentIndex.value < c.questionList.length - 1
                              ? Icons.navigate_next
                              : Icons.check,
                        ),
                        label: Text(
                          c.currentIndex.value < c.questionList.length - 1
                              ? "Next"
                              : "Submit",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}