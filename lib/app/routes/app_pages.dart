import 'package:get/get.dart';

import '../modules/Question/bindings/question_binding.dart';
import '../modules/Question/views/question_view.dart';
import '../modules/SignUp/bindings/sign_up_binding.dart';
import '../modules/SignUp/views/sign_up_view.dart';
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

  static const INITIAL = Routes.SIGN_IN;

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
      page: () =>  LivequizView(),
      binding: LivequizBinding(),
    ),
  ];
}
