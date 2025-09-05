import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';
import 'package:quiz/app/data/config/app_cons.dart';

class PreviousQuizController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var quizList = [].obs;
  var isLoading = false.obs;

  var selectedQuiz = {}.obs;
  var questionList = [].obs;

  // 🔹 Pick Date
  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      fetchQuizTitles();
    }
  }


  Future<void> fetchQuizTitles() async {
    try {
      isLoading.value = true;
      final userId = getBox.read("user_id");

      final response = await dioPost(
        endUrl: "/get-previous-quiztitle.php",
        data: {
          "user_id": userId,
          "date": DateFormat("yyyy-MM-dd").format(selectedDate.value),
        },
      );

      if (response.data["status"] == "success") {
        quizList.value = response.data["quizzes"];
      } else {
        quizList.clear();
      }
    } catch (e) {
      quizList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Fetch quiz details
  Future<void> fetchQuizDetails(String quizId) async {
    try {
      isLoading.value = true;
      final userId = getBox.read("user_id");

      final response = await dioPost(
        endUrl: "/get-previous-quizdetails.php",
        data: {
          "user_id": userId,
          "quiz_id": quizId,
        },
      );

      if (response.data["status"] == "success") {
        selectedQuiz.value = response.data["quiz"];
        questionList.value = response.data["quiz"]["questions"];
      } else {
        selectedQuiz.clear();
        questionList.clear();
      }
    } catch (e) {
      selectedQuiz.clear();
      questionList.clear();
    } finally {
      isLoading.value = false;
    }
  }
}