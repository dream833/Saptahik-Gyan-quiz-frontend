import 'dart:async';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/function/dio_get.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';
import 'package:quiz/app/data/config/app_cons.dart';

class LivequizController extends GetxController {
  // 🔹 State variables
  var quizList = [].obs;
  var isLoading = false.obs;
  var showQuestions = false.obs;

  var selectedQuiz = {}.obs;
  var questionList = [].obs;

  var currentIndex = 0.obs;
  var selectedAnswers = <int, String>{}.obs; // {questionId: option}
  var timer = 0.obs;
  Timer? quizTimer;

  // 🔹 Check if user already attempted
  var isAttempted = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  // 🔹 Fetch quiz list (POST)
Future<void> fetchQuizzes() async {
  try {
    isLoading.value = true;
    final userId = getBox.read("user_id");
    if (userId == null) return;

    final response = await dioPost(endUrl: "/getapp-quiz.php", data: {
      "user_id": userId,
    });

    final data = response.data;
    if (data["status"] == "success") {
      // 🔹 Map each quiz and set attempted flag
      quizList.value = (data["quizzes"] as List).map((q) {
        return {
          ...q,
          "isAttempted": (q["attempted"] ?? 0) == 1,
        };
      }).toList();
    } else {
      quizList.clear();
    }
  } catch (e) {
    quizList.clear();
  } finally {
    isLoading.value = false;
  }
}
  // 🔹 Fetch questions for a quiz (POST)
  Future<void> fetchQuestions(int quizId) async {
    try {
      isLoading.value = true;
      final userId = getBox.read("user_id");
      if (userId == null) return;

      final response = await dioPost(
        endUrl: "/get-live-quiz-questions.php",
        data: {"quizid": quizId, "user_id": userId},
      );

      final data = response.data;

      if (data["status"] == "success") {
        selectedQuiz.value = data["quiz"] ?? {};
        final questions = data["quiz"]?["questions"];
        questionList.value = questions is List ? questions : [questions];
        currentIndex.value = 0;
        selectedAnswers.clear();
        startTimer(int.tryParse("${selectedQuiz["timer"] ?? 30}") ?? 30);
        showQuestions.value = true;
        isAttempted.value = false;
      } else if (data["status"] == "error" &&
          data["message"]?.contains("already attempted") == true) {
        // 🔹 User already attempted
        isAttempted.value = true;
        showQuestions.value = true;
        selectedQuiz.value = data["quiz"] ?? {};
        final questions = data["quiz"]?["questions"];
        questionList.value = questions is List ? questions : [questions];
      } else {
        selectedQuiz.clear();
        questionList.clear();
        showQuestions.value = false;
      }
    } catch (e) {
      selectedQuiz.clear();
      questionList.clear();
      showQuestions.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Current question getter
  Map<String, dynamic>? get currentQuestion {
    if (questionList.isNotEmpty && currentIndex.value < questionList.length) {
      return questionList[currentIndex.value] as Map<String, dynamic>;
    }
    return null;
  }

  // 🔹 Timer logic
  void startTimer(int seconds) {
    timer.value = seconds;
    quizTimer?.cancel();

    quizTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timer.value > 0) {
        timer.value--;
      } else {
        t.cancel();
        submitQuiz();
      }
    });
  }

  // 🔹 Select answer
  void selectAnswer(int questionId, String option) {
    if (isAttempted.value) return; // prevent selection if already attempted
    selectedAnswers[questionId] = option;
    questionList.refresh();
  }

  // 🔹 Navigation
  void nextQuestion() {
    if (currentIndex.value < questionList.length - 1) currentIndex.value++;
  }

  void previousQuestion() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  // 🔹 Submit quiz to API
  Future<void> submitQuiz() async {
    if (isAttempted.value) return;
    try {
      quizTimer?.cancel();

      final quizId = selectedQuiz["quiz_id"];
      final userId = getBox.read("user_id");

      final answersPayload = selectedAnswers.entries
          .map((e) => {"question_id": e.key, "user_answer": e.value})
          .toList();

      final response = await dioPost(
        endUrl: "/submit-quiz.php",
        data: {
          "quizid": quizId,
          "userid": userId,
          "time_taken": timer.value,
          "answers": answersPayload,
        },
      );

      final data = response.data;

      if (data["status"] == "success") {
        isAttempted.value = true;
        Get.defaultDialog(
          title: "✅ Quiz Submitted",
          middleText:
              "Score: ${data['result']['score']}\nTotal Questions: ${data['result']['total_questions']}\nCorrect: ${data['result']['correct_answers']}\nWrong: ${data['result']['wrong_answers']}\nTime: ${data['result']['time_taken']} sec",
          onConfirm: () {
            Get.back();
            backToQuizList();
          },
        );
      } else {
        Get.snackbar("Error", data["message"] ?? "Failed to submit quiz");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong while submitting quiz");
    }
  }

  // 🔹 Back to quiz list
  void backToQuizList() {
    quizTimer?.cancel();
    showQuestions.value = false;
    selectedQuiz.clear();
    questionList.clear();
    currentIndex.value = 0;
    selectedAnswers.clear();
    isAttempted.value = false;
  }

  @override
  void onClose() {
    quizTimer?.cancel();
    super.onClose();
  }
}