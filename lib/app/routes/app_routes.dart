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
}

abstract class _Paths {
  _Paths._();
  static const SIGN_IN = '/sign-in';
  static const HOME = '/home';
  static const DAILY_MOCK_TEST = '/daily-mock-test';
  static const TEST_SCREEN = '/test-screen';
  static const NO_INTERNET = '/no-internet';
  static const SIGN_UP = '/sign-up';
}
