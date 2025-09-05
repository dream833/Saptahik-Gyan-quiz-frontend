import 'package:get/get.dart';

import '../controllers/previous_quiz_controller.dart';

class PreviousQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreviousQuizController>(
      () => PreviousQuizController(),
    );
  }
}
