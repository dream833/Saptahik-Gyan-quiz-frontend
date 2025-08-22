import 'package:get/get.dart';

import '../controllers/livequiz_controller.dart';

class LivequizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LivequizController>(
      () => LivequizController(),
    );
  }
}
