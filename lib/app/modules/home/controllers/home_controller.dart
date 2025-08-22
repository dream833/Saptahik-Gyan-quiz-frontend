import 'package:get/get.dart';
import 'package:quiz/app/data/config/app_cons.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';
import 'package:quiz/app/modules/earning/views/earning_view.dart';
import 'package:quiz/app/modules/learning/views/learning_view.dart';

class HomeController extends GetxController {
  var userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile(); 
  }

  void playForLearning() {
    Get.snackbar("Learning", "");
    Get.to(() => LearningView());
  }

  void playForEarning() {
    Get.snackbar("Quiz is Ongoing", "");
    Get.to(() => EarningView());

  }

  Future<void> fetchUserProfile() async {
    final userId = getBox.read(USER_ID);

    if (userId == null) {
      print("User ID not found in storage");
      return;
    }

    try {
      final response = await dioPost(
        isPost: true,
        endUrl: '/getprofile.php',
        data: {"id": userId},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == true) {
          userName.value = data['data']['name'];
          print("User Name: ${userName.value}");
        } else {
          print('API Error: ${data['message']}');
        }
      } else {
        print('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in fetchUserProfile: $e');
    }
  }
}