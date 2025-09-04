import 'package:get/get.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';

class LeaderboardController extends GetxController {
  var isLoading = false.obs;
  var quizzes = [].obs;
  var leaderboard = [].obs;

  /// Step 1 - fetch quizzes by date
  Future<void> fetchQuizzes(String date) async {
    try {
      isLoading.value = true;
      final res = await dioPost(
       
        data: {"date": date},
        endUrl: "/get-leader-quizbydate.php",
      );

      final data = res.data;
      if (data["status"] == "success") {
        quizzes.value = data["quizzes"];
      } else {
        quizzes.value = [];
      }
    } catch (e) {
      quizzes.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 2 - fetch leaderboard by quizid + date
  Future<void> fetchLeaderboard(String date, int quizId) async {
    try {
      isLoading.value = true;
      final res = await dioPost(
    
        data: {"quizid": quizId, "date": date},
        endUrl: "/get-leaderboard.php",
      );

      final data = res.data;
      if (data["status"] == "success") {
        leaderboard.value = data["leaderboard"];
      } else {
        leaderboard.value = [];
      }
    } catch (e) {
      leaderboard.value = [];
    } finally {
      isLoading.value = false;
    }
  }
}