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
              c.showQuestions.value
                  ? (c.selectedQuiz["title"] ?? "Quiz")
                  : "Live Quizzes",
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
                style: TextStyle(fontSize: 20.w, color: Colors.grey),
              ),
            );
          }

          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: c.quizList.length,
              itemBuilder: (context, index) {
                final quiz = c.quizList[index];
                final quizTimer = quiz["timer"] ?? 0;
                final attempted = quiz["attempted"] == 1;

                return GestureDetector(
                  onTap: () {
                    if (attempted) {
                      Get.snackbar(
                        "Already Attempted",
                        "You have already attempted this quiz",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.redAccent.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                    } else {
                      c.fetchQuestions(quiz["quiz_id"]);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(quiz["title"] ?? "",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text(quiz["description"] ?? "",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                ],
                              ),
                            ),
                            Center(
                              child: Icon(Icons.arrow_forward_ios,
                                  size: 18, color: AppColor.buttonOneColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.timer,
                                size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 6),
                            Text(
                              "$quizTimer sec",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700),
                            ),
                            if (attempted) ...[
                              const SizedBox(width: 12),
                              const Icon(Icons.lock, size: 16, color: Colors.red),
                              const SizedBox(width: 4),
                              const Text(
                                "Attempted",
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              )
                            ]
                          ],
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
              // ---------- HEADER ----------
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.buttonOneColor, AppColor.buttonTwoColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(32)),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.selectedQuiz["title"] ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(c.selectedQuiz["description"] ?? "",
                            style:
                                const TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 6),
                        Text("Date: ${c.selectedQuiz["quiz_date"] ?? ""}",
                            style:
                                const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    )),
                    Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColor.buttonTwoColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${c.timer.value}s",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------- QUESTION CARD ----------
              Expanded(
                child: Obx(() {
                  final question = c.currentQuestion;
                  if (question == null) return const SizedBox();

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 4))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Q${c.currentIndex.value + 1}. ${question["question"]}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 24),

                            // Options
                            ...["A", "B", "C", "D"].map((optKey) {
                              final optionText =
                                  question["option_${optKey.toLowerCase()}"];
                              final isSelected = c.selectedAnswers[
                                      question["question_id"]] ==
                                  optKey;

                              return GestureDetector(
                                onTap: () => c.selectAnswer(
                                    question["question_id"], optKey),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColor.buttonOneColor.withOpacity(0.2)
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: isSelected
                                            ? AppColor.buttonOneColor
                                            : Colors.grey.shade300,
                                        width: 2),
                                  ),
                                  child: Text(
                                    "$optKey. $optionText",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: isSelected
                                            ? AppColor.buttonTwoColor
                                            : Colors.black87),
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
                                borderRadius: BorderRadius.circular(16)),
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
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: c.currentIndex.value < c.questionList.length - 1
                            ? c.nextQuestion
                            : c.submitQuiz,
                        icon: Icon(c.currentIndex.value < c.questionList.length - 1
                            ? Icons.navigate_next
                            : Icons.check),
                        label: Text(c.currentIndex.value < c.questionList.length - 1
                            ? "Next"
                            : "Submit"),
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