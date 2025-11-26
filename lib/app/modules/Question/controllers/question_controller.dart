import 'package:get/get.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';

import 'package:quiz/app/modules/Question/views/question_model.dart';

class QuestionController extends GetxController {
  var questions = <QuestionModel>[].obs;
  var isLoading = false.obs;

  Future<void> loadQuestions({
    required int categoryId,
    required int subCategoryId,
  }) async {
    isLoading.value = true;

    try {
      final response = await dioPost(
        endUrl: '/getquestions.php',
        data: {'category_id': categoryId, 'sub_category_id': subCategoryId},
      );

      if (response.statusCode == 200 &&
          response.data['status'] == 'success' &&
          response.data['data'] != null) {
        questions.value = List<QuestionModel>.from(
          response.data['data'].map((e) => QuestionModel.fromJson(e)),
        );
      } else {
        questions.clear();
        Get.snackbar('No Data', 'No questions found.');
      }
    } catch (e) {
      questions.clear();
      Get.snackbar('Error', 'Failed to load questions.');
    } finally {
      isLoading.value = false;
    }
  }
}
