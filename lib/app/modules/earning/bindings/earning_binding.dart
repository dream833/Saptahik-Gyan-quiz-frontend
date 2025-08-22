import 'package:get/get.dart';

import '../controllers/earning_controller.dart';

class EarningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EarningController>(
      () => EarningController(),
    );
  }
}
