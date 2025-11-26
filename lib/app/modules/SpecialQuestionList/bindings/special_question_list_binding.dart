import 'package:get/get.dart';

import '../controllers/special_question_list_controller.dart';

class SpecialQuestionListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpecialQuestionListController>(
      () => SpecialQuestionListController(),
    );
  }
}
