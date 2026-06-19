import 'package:get/get.dart';

import '../modules/DailyMockTest/bindings/daily_mock_test_binding.dart';
import '../modules/DailyMockTest/views/daily_mock_test_view.dart';
import '../modules/Home/bindings/home_binding.dart';
import '../modules/Home/views/home_view.dart';
import '../modules/NoInternet/bindings/no_internet_binding.dart';
import '../modules/NoInternet/views/no_internet_view.dart';
import '../modules/SignIn/bindings/sign_in_binding.dart';
import '../modules/SignIn/views/sign_in_view.dart';
import '../modules/SignUp/bindings/sign_up_binding.dart';
import '../modules/SignUp/views/sign_up_view.dart';
import '../modules/TestScreen/bindings/test_screen_binding.dart';
import '../modules/TestScreen/views/test_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SIGN_IN;

  static final routes = [
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
  ];
}
