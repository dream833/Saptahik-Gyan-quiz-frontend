import 'package:get/get.dart';

import '../controllers/joinwithus_controller.dart';

class JoinwithusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JoinwithusController>(
      () => JoinwithusController(),
    );
  }
}
