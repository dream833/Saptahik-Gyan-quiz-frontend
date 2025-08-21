

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as DIO;
import 'package:quiz/app/data/config/app_cons.dart';

Future<DIO.Response<dynamic>> dioPost(
    {bool? isPost, dynamic data, String? endUrl, bool? sendFile}) async {
  var dio = DIO.Dio();
  if (getBox.read(USER_LOGIN) ?? false) {
    dio.options.headers['Authorization'] =
        "Bearer ${getBox.read(USER_TOKEN) ?? ''}";
  }

  sendFile ?? false
      ? dio.options.headers["Content-Type"] = "multipart/form-data"
      : null;

  if (isPost ?? true) {
    var response = await dio.post(
      "$BASE_URL$endUrl",
      data: data,
      options: DIO.Options(
        validateStatus: (status) => true,
        sendTimeout: const Duration(milliseconds: 300000),
        receiveTimeout: const Duration(milliseconds: 300000),
      ),
    );
    isDebugMode.value
        ? log(
            "\n\n${isPost ?? true ? 'POST:' : 'PUT'} $BASE_URL$endUrl\nSTATUS CODE: ${response.statusCode}\n${jsonEncode(response.data)}\n\n")
        : null;

    return response;
  } else {
    var response = await dio.put(
      "$endUrl",
      data: data,
      options: DIO.Options(
        validateStatus: (status) => true,
        sendTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 10000),
      ),
    );
    isDebugMode.value
        ? log(
            "\n\n${isPost ?? true ? 'POST:' : 'PUT'} $BASE_URL$endUrl\nSTATUS CODE: ${response.statusCode}\n${jsonEncode(response.data)}\n\n")
        : null;
    return response;
  }
}