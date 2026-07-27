import 'dart:developer';

import 'package:get/get.dart';

import '../../../data/config/app_cons.dart';
import '../../../data/function/dio_post.dart';
import '../../../data/models/mock_data.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  // Dashboard Data
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhone = ''.obs;
  var totalTestsTaken = 0.obs;
  var averageScore = 0.obs;
  var totalCorrect = 0.obs;
  var totalWrong = 0.obs;
  var isLoading = false.obs;

  // Dashboard banners
  var banners = <Map<String, dynamic>>[].obs;

  // Previous test records
  var previousTestRecords = <PreviousTestRecord>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;

      final userId = getBox.read(USER_ID);
      if (userId == null) return;

      final response = await dioPost(
        endUrl: "/dashboard.php",
        data: {"user_id": int.tryParse(userId.toString()) ?? 0},
      );

      log("Dashboard Response: ${response.data}");

      if (response.data['data'] != null) {
        final data = response.data['data'];

        // User info
        if (data['user'] != null) {
          userName.value = data['user']['name'] ?? '';
          userEmail.value = data['user']['email'] ?? '';
          userPhone.value = data['user']['phone'] ?? '';
        }

        // Stats
        if (data['stats'] != null) {
          totalTestsTaken.value = data['stats']['total_tests_taken'] ?? 0;
          averageScore.value = data['stats']['average_score'] ?? 0;
          totalCorrect.value = data['stats']['total_correct'] ?? 0;
          totalWrong.value = data['stats']['total_wrong'] ?? 0;
        }

        // Banners
        if (data['banners'] != null) {
          banners.value = (data['banners'] as List)
              .map((b) => {
                    'title': b['title'] ?? '',
                    'subtitle': b['subtitle'] ?? '',
                    'icon': b['icon'] ?? 'quiz',
                    'gradient': b['gradient'] ?? 'primary',
                  })
              .toList();
        }

        // Previous test records
        if (data['previous_test_records'] != null) {
          previousTestRecords.value = (data['previous_test_records'] as List)
              .map((r) => PreviousTestRecord(
                    name: r['name'] ?? '',
                    date: r['date'] ?? '',
                    totalQuestions: r['total_questions'] ?? 0,
                    score: r['score'] ?? 0,
                  ))
              .toList();
        }
      }
    } catch (e) {
      log("Dashboard fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
