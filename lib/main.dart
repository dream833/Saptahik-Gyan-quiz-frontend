import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wbpathshala/app/routes/app_pages.dart';

import 'app/data/function/fcm_service.dart';
import 'app/modules/NoInternet/controllers/no_internet_controller.dart';
import 'app/modules/NoInternet/views/no_internet_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Firebase + FCM setup
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await GetStorage.init();
  await FcmService.initialize();

  runApp(const MyApp());

  Get.put(NointernetController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NointernetController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: "Quiz",
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),

          builder: (context, widget) {
            return Obx(() {
              if (!controller.isConnected.value) {
                return NoInternetView();
              }
              return widget!;
            });
          },
        );
      },
    );
  }
}
