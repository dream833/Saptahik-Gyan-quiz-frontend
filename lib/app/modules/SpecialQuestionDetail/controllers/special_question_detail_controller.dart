import 'package:get/get.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';
import 'package:quiz/app/modules/SpecialQuestionDetail/models/spc-question-detailmodel.dart';


class SpecialQuestionDetailController extends GetxController {
  final int titleId;

  SpecialQuestionDetailController(this.titleId);

  var isLoading = false.obs;
  var questions = <QuestionItem>[].obs;
  var title = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoading.value = true;

      final res = await dioPost(
        endUrl: "/get-all-spc-question.php",
        data: {"title_id": titleId},
      );

      print("API Response: ${res.data}"); 

      final data = res.data;

      if (data["status"] == "success") {
        final detail = SpecialQuestionDetail.fromJson(data);
        questions.value = detail.questions;
        title.value = detail.title;
      } else {
        questions.clear();
        title.value = "No Title";
      }
    } catch (e) {
      print("Error fetching questions: $e");
      questions.clear();
      title.value = "No Title";
    } finally {
      isLoading.value = false;
    }
  }
}