import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as DIO;

import 'package:quiz/app/data/config/app_cons.dart';

DIO.Dio dio = DIO.Dio(DIO.BaseOptions(
  baseUrl: BASE_URL,
  connectTimeout: Duration(milliseconds: 65000), // 65 seconds
  receiveTimeout: Duration(milliseconds: 120000), // Increased to 120 seconds
));

Future<DIO.Response<dynamic>> dioGet(String endUrl) async {
  print("$BASE_URL$endUrl");
  try {
    if (getBox.read(USER_LOGIN) ?? false) {
      dio.options.headers['Authorization'] =
          "Bearer ${getBox.read(USER_ID) ?? ''}";
    }

    var response = await dio.get(
      "$BASE_URL$endUrl",
      options: DIO.Options(
        validateStatus: (status) => true,
        sendTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 20000), // Increased receiveTimeout
      ),
    );
    if (isDebugMode.value) {
      log(
        "\n\nGET: $endUrl\nSTATUS CODE: ${response.statusCode}\n${jsonEncode(response.data)}\n\n"
      );
    }
    return response;
  } on DIO.DioException catch (e) {
    print("DioException: $e");
    rethrow;
  } catch (e) {
    print("Unexpected error: $e");
    rethrow;
  }
}

Future<DIO.Response<dynamic>> dioUGet(String endUrl) async {
  try {
    var response = await dio.get(
      endUrl,
      options: DIO.Options(
        validateStatus: (status) => true,
        sendTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 20000), // Increased receiveTimeout
      ),
    );
    if (isDebugMode.value) {
      log(
        "\n\nGET: $endUrl\nSTATUS CODE: ${response.statusCode}\n${jsonEncode(response.data)}\n\n"
      );
    }
    return response;
  } on DIO.DioException catch (e) {
    print("DioException: $e");
    rethrow;
  } catch (e) {
    print("Unexpected error: $e");
    rethrow;
  }
}