import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/app/modules/SpecialQuestionDetail/models/spc-question-detailmodel.dart';
import '../controllers/special_question_detail_controller.dart';

class SpecialQuestionDetailView extends StatelessWidget {
  const SpecialQuestionDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final int titleId = int.tryParse(args['titleId'].toString()) ?? 0;

    final controller = Get.put(
      SpecialQuestionDetailController(titleId),
      tag: titleId.toString(),
    );

    final List<Color> titleColors = [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
    ];

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Title Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: titleColors[titleId % titleColors.length],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      controller.title.value.isNotEmpty
                          ? controller.title.value
                          : "Questions",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Table
                  Expanded(
                    child: controller.questions.isEmpty
                        ? const Center(child: Text("No questions found"))
                        : SingleChildScrollView(
                            child: Table(
                              border: TableBorder.all(
                                color: Colors.black54,
                                width: 1,
                              ),
                              columnWidths: const {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(3),
                              },
                              children: [
                                // Table Header
                                const TableRow(
                                  decoration: BoxDecoration(color: Color(0xFFFFE082)), // light amber
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "উচ্চতম / সর্বোচ্চ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "নাম / উত্তর",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Dynamic Rows
                                ...controller.questions.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final q = entry.value;
                                  return TableRow(
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? Colors.grey.shade100
                                          : Colors.white,
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          q.question,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          q.answer,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
