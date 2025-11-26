import 'package:get/get.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';
import 'package:quiz/app/modules/sign_in/views/sign_in_view.dart';

class ForgetPasswordController extends GetxController {
  var isLoading = false.obs;

  var phone = ''.obs;
  var newPassword = ''.obs;

  Future<void> resetPassword() async {
    if (phone.value.isEmpty || newPassword.value.isEmpty) {
      Get.snackbar("Error", "Phone number and password required");
      return;
    }

    try {
      isLoading.value = true;
      final res = await dioPost(
        endUrl: "/forgetpassword.php",
        data: {
          "phone": phone.value,
          "new_password": newPassword.value,
        },
      );

      final data = res.data;

      if (data["status"] == "success") {
        Get.snackbar("Success", data["message"]);
        Get.offAll(() => const SignInView());
      } else {
        Get.snackbar("Error", data["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}