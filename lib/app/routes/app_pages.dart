import 'package:get/get.dart';

import '../modules/ForgetPassword/bindings/forget_password_binding.dart';
import '../modules/ForgetPassword/views/forget_password_view.dart';
import '../modules/Leaderboard/bindings/leaderboard_binding.dart';
import '../modules/Leaderboard/views/leaderboard_view.dart';
import '../modules/PreviousQuiz/bindings/previous_quiz_binding.dart';
import '../modules/PreviousQuiz/views/previous_quiz_view.dart';
import '../modules/Question/bindings/question_binding.dart';
import '../modules/Question/views/question_view.dart';
import '../modules/SignUp/bindings/sign_up_binding.dart';
import '../modules/SignUp/views/sign_up_view.dart';
import '../modules/SpecialQuestionDetail/bindings/special_question_detail_binding.dart';
import '../modules/SpecialQuestionDetail/views/special_question_detail_view.dart';
import '../modules/SpecialQuestionList/bindings/special_question_list_binding.dart';
import '../modules/SpecialQuestionList/views/special_question_list_view.dart';
import '../modules/earning/bindings/earning_binding.dart';
import '../modules/earning/views/earning_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/learning/bindings/learning_binding.dart';
import '../modules/learning/views/learning_view.dart';
import '../modules/livequiz/bindings/livequiz_binding.dart';
import '../modules/livequiz/views/livequiz_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/subcategory/bindings/subcategory_binding.dart';
import '../modules/subcategory/controllers/subcategory_controller.dart';
import '../modules/subcategory/views/subcategory_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGN_UP;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.LEARNING,
      page: () => LearningView(),
      binding: LearningBinding(),
    ),
    GetPage(
      name: _Paths.SUBCATEGORY,
      page: () {
        final args = Get.arguments;
        return SubCategoryPage(
          categoryId: args['categoryId'],
          categoryName: args['categoryName'],
        );
      },
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SubcategoryController());
      }),
    ),
    GetPage(
      name: _Paths.QUESTION,
      page: () => QuestionView(
          categoryId: Get.arguments['categoryId'],
          subCategoryId: Get.arguments['subCategoryId']),
      binding: QuestionBinding(),
    ),
    GetPage(
      name: _Paths.EARNING,
      page: () => const EarningView(),
      binding: EarningBinding(),
    ),
    GetPage(
      name: _Paths.LIVEQUIZ,
      page: () => LivequizView(),
      binding: LivequizBinding(),
    ),
    GetPage(
      name: _Paths.LEADERBOARD,
      page: () => LeaderboardView(
        selectedDate: '',
      ),
      binding: LeaderboardBinding(),
    ),
    GetPage(
      name: _Paths.SPECIAL_QUESTION_LIST,
      page: () => const SpecialQuestionListView(),
      binding: SpecialQuestionListBinding(),
    ),
    GetPage(
      name: _Paths.SPECIAL_QUESTION_DETAIL,
      page: () => SpecialQuestionDetailView(),
      binding: SpecialQuestionDetailBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PREVIOUS_QUIZ,
      page: () => PreviousQuizView(),
      binding: PreviousQuizBinding(),
    ),
  ];
}
