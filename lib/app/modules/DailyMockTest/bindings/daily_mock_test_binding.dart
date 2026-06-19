import 'package:get/get.dart';

import '../controllers/daily_mock_test_controller.dart';

class DailyMockTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyMockTestController>(
      () => DailyMockTestController(),
    );
  }
}
