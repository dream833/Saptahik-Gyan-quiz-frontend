import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/appcolor.dart';
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
      appBar: AppBar(
        title: const Text('Questions', textAlign: TextAlign.center),
        backgroundColor: AppColor.buttonOneColor,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.questions.isEmpty) {
          return Center(
            child: Text(
              'No questions found',
              style: TextStyle(fontSize: 29.w, color: Colors.grey),
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                title: Text(
                  q.question,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 33.w),
                ),
                subtitle: Text(
                  " ${q.answer}",
                  style: TextStyle(
                    fontSize: 30.w,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
