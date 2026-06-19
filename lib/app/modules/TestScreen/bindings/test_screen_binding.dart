import 'package:get/get.dart';

import '../controllers/test_screen_controller.dart';

class TestScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestScreenController>(
      () => TestScreenController(),
    );
  }
}
