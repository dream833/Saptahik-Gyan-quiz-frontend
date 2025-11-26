import 'package:get/get.dart';

import '../controllers/special_question_detail_controller.dart';

class SpecialQuestionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpecialQuestionDetailController>(
      () => SpecialQuestionDetailController(Get.arguments['titleId']),
    );
  }
}
