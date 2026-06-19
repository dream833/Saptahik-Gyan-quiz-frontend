import 'package:get/get.dart';

import '../controllers/all_mock_test_controller.dart';

class AllMockTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllMockTestController>(
      () => AllMockTestController(),
    );
  }
}
