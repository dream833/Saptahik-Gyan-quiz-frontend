import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/app/modules/Question/controllers/question_controller.dart';


class QuestionView extends StatelessWidget {
  final int categoryId;
  final int subCategoryId;

  const QuestionView({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Use Get.put only if not already registered
    final controller = Get.put(QuestionController(), permanent: false);

    // ✅ Ensure API call runs once after build
    Future.delayed(Duration.zero, () {
      if (controller.questions.isEmpty && !controller.isLoading.value) {
        controller.loadQuestions(
          categoryId: categoryId,
          subCategoryId: subCategoryId,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Questions')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.questions.isEmpty) {
          return const Center(
            child: Text(
              'No questions found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.questions.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final q = controller.questions[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Text(
                  q.question,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(" ${q.answer}"),
              ),
            );
          },
        );
      }),
    );
  }
}