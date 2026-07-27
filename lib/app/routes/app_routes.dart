// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SIGN_IN = _Paths.SIGN_IN;
  static const HOME = _Paths.HOME;
  static const DAILY_MOCK_TEST = _Paths.DAILY_MOCK_TEST;
  static const TEST_SCREEN = _Paths.TEST_SCREEN;
  static const NO_INTERNET = _Paths.NO_INTERNET;
  static const SIGN_UP = _Paths.SIGN_UP;
  static const QUESTION_ANSWER = _Paths.QUESTION_ANSWER;
  static const SUGGESTION = _Paths.SUGGESTION;
  static const PREVIOUS_YEAR_QUESTION = _Paths.PREVIOUS_YEAR_QUESTION;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
  static const ABOUT = _Paths.ABOUT;
  static const TERMS = _Paths.TERMS;
  static const ALL_MOCK_TESTS = _Paths.ALL_MOCK_TESTS;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
}

abstract class _Paths {
  _Paths._();
  static const SIGN_IN = '/sign-in';
  static const HOME = '/home';
  static const DAILY_MOCK_TEST = '/daily-mock-test';
  static const TEST_SCREEN = '/test-screen';
  static const NO_INTERNET = '/no-internet';
  static const SIGN_UP = '/sign-up';
  static const QUESTION_ANSWER = '/question-answer';
  static const SUGGESTION = '/suggestion';
  static const PREVIOUS_YEAR_QUESTION = '/previous-year-question';
  static const EDIT_PROFILE = '/edit-profile';
  static const NOTIFICATIONS = '/notifications';
  static const ABOUT = '/about';
  static const TERMS = '/terms';
  static const ALL_MOCK_TESTS = '/all-mock-tests';
  static const FORGOT_PASSWORD = '/forgot-password';
}
