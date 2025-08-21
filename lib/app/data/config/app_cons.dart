

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get_storage/get_storage.dart';

final getBox = GetStorage();
var BASE_URL = "https://saptahikgyan.in/admin/api";
const String USER_ID = "user_id";
const String IS_USER_LOGGED_IN = "IS_USER_LOGGED_IN";
const String USER_TOKEN = "TOKEN";
const String USER_EMAIL = "user_email";
const String USER_PASSWORD = "password";
const String USER_LOGIN = "login_true";
const String HIDEBUYNOW = "buy_now";
const String USER_OTP = "MY OTP";
const String FORGOTFIELD = "forgot-feild-data";
var isDebugMode = true.obs;

void SHOW_SNACKBAR({int? duration, String? message, bool? isSuccess}) {
  final snackbar = GetSnackBar(
      icon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Image(
          height: 50.h,
          width: 100.w,
          fit: BoxFit.contain,
          image: AssetImage("AppImage.logo"),
        ),
      ),
      backgroundColor: (isSuccess ?? true) ? Colors.green : Colors.red,
      duration: Duration(milliseconds: duration ?? 2500),
      message: message ?? "No Message");
  Get.showSnackbar(snackbar);
}
