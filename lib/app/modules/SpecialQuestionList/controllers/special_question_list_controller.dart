import 'package:get/get.dart';
import 'package:quiz/app/data/config/function/dio_get.dart';
import 'package:quiz/app/modules/SpecialQuestionList/models/titlemodel.dart';


class SpecialQuestionListController extends GetxController {
  var isLoading = false.obs;
  var titles = <TitleModel>[].obs;

  Future<void> fetchTitles() async {
    try {
      isLoading.value = true;
      final res = await dioGet("/get-all-spc-question-title.php");
      final data = res.data;

      if (data["status"] == "success") {
        var list = data["titles"] as List;
        titles.value = list.map((e) => TitleModel.fromJson(e)).toList();
      } else {
        titles.clear();
      }
    } catch (e) {
      titles.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTitles();
  }
}