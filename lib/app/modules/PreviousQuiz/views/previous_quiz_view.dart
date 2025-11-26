import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import 'package:quiz/app/modules/PreviousQuiz/controllers/previous_quiz_controller.dart';

class PreviousQuizView extends StatelessWidget {
  final PreviousQuizController c = Get.put(PreviousQuizController());

  PreviousQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColor.buttonOneColor,
        title: const Text(
          "Previous Quizzes",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
       
        if (c.selectedQuiz.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: c.questionList.length,
            itemBuilder: (context, index) {
              final q = c.questionList[index];
              final userAns = q["user_answer"];
              final correctAns = q["correct_option"];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question number + text
                      Text(
                        "${index + 1}. ${q["question"]}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Options
                      Column(
                        children: [
                          buildOptionTile("A", q["option_a"], userAns, correctAns),
                          buildOptionTile("B", q["option_b"], userAns, correctAns),
                          buildOptionTile("C", q["option_c"], userAns, correctAns),
                          buildOptionTile("D", q["option_d"], userAns, correctAns),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        // 🔹 Otherwise show date picker + quiz list
        return Column(
          children: [
            // Date Picker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.deepPurple),
                      const SizedBox(width: 10),
                      Text(
                        "${c.selectedDate.value.toLocal()}".split(' ')[0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_calendar, color: Colors.deepPurple),
                    onPressed: () => c.pickDate(context),
                  ),
                ],
              ),
            ),

            // Quiz list
            Expanded(
              child: Obx(() {
                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (c.quizList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No quizzes found",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  itemCount: c.quizList.length,
                  itemBuilder: (context, index) {
                    final quiz = c.quizList[index];
                    return GestureDetector(
                      onTap: () => c.fetchQuizDetails(quiz["quiz_id"].toString()),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Text(
                                quiz["title"][0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quiz["title"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    quiz["description"],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              quiz["played"] == true ? Icons.check_circle : Icons.cancel,
                              color: quiz["played"] == true ? Colors.green : Colors.red,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  // 🔹 Helper Widget for Option Box
  Widget buildOptionTile(String optionKey, String optionText, String? userAns, String correctAns) {
    Color borderColor = Colors.grey.shade400;
    Color bgColor = Colors.white;
    Color textColor = Colors.black;

    if (userAns != null) {
      if (optionKey == correctAns) {
        bgColor = Colors.green.shade50;
        borderColor = Colors.green;
        textColor = Colors.green.shade800;
      } else if (optionKey == userAns && userAns != correctAns) {
        bgColor = Colors.red.shade50;
        borderColor = Colors.red;
        textColor = Colors.red.shade800;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(
            "$optionKey. ",
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          Expanded(
            child: Text(
              optionText,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}