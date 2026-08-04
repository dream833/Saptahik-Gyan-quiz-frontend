import 'package:get/get.dart';

import '../modules/DailyMockTest/bindings/daily_mock_test_binding.dart';
import '../modules/DailyMockTest/views/daily_mock_test_view.dart';
import '../modules/ForgotPassword/bindings/forgot_password_binding.dart';
import '../modules/ForgotPassword/views/forgot_password_view.dart';
import '../modules/Home/bindings/home_binding.dart';
import '../modules/Home/views/home_view.dart';
import '../modules/Home/views/solution_tabs/question_answer_view.dart';
import '../modules/Home/views/solution_tabs/suggestion_view.dart';
import '../modules/Home/views/solution_tabs/previous_year_question_view.dart';
import '../modules/AllMockTest/bindings/all_mock_test_binding.dart';
import '../modules/AllMockTest/views/all_mock_test_view.dart';
import '../modules/Home/views/profile_tabs/about_view.dart';
import '../modules/Home/views/profile_tabs/edit_profile_view.dart';
import '../modules/Home/views/profile_tabs/notifications_view.dart';
import '../modules/Home/views/profile_tabs/terms_view.dart';
import '../modules/NoInternet/bindings/no_internet_binding.dart';
import '../modules/NoInternet/views/no_internet_view.dart';
import '../modules/SignIn/bindings/sign_in_binding.dart';
import '../modules/SignIn/views/sign_in_view.dart';
import '../modules/SignUp/bindings/sign_up_binding.dart';
import '../modules/SignUp/views/sign_up_view.dart';
import '../modules/Splash/bindings/splash_binding.dart';
import '../modules/Splash/views/splash_view.dart';
import '../modules/TestScreen/bindings/test_screen_binding.dart';
import '../modules/TestScreen/views/test_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DAILY_MOCK_TEST,
      page: () => const DailyMockTestView(),
      binding: DailyMockTestBinding(),
    ),
    GetPage(
      name: _Paths.TEST_SCREEN,
      page: () => const TestScreenView(),
      binding: TestScreenBinding(),
    ),
    GetPage(
      name: _Paths.NO_INTERNET,
      page: () => NoInternetView(),
      binding: NointernetBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.QUESTION_ANSWER,
      page: () => const QuestionAnswerView(),
    ),
    GetPage(
      name: _Paths.SUGGESTION,
      page: () => const SuggestionView(),
    ),
    GetPage(
      name: _Paths.PREVIOUS_YEAR_QUESTION,
      page: () => const PreviousYearQuestionView(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
    ),
    GetPage(
      name: _Paths.ABOUT,
      page: () => const AboutView(),
    ),
    GetPage(
      name: _Paths.TERMS,
      page: () => const TermsView(),
    ),
    GetPage(
      name: _Paths.ALL_MOCK_TESTS,
      page: () => const AllMockTestView(),
      binding: AllMockTestBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
  ];
}
