import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import 'package:quiz/app/modules/Leaderboard/views/leaderboard_view.dart';
import 'package:quiz/app/modules/aboutus/views/aboutus_view.dart';
import 'package:quiz/app/modules/contactus/views/contactus_view.dart';
import 'package:quiz/app/modules/privacypolicy/views/privacypolicy_view.dart';

import 'package:quiz/app/modules/sign_in/views/sign_in_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.buttonOneColor,
        toolbarHeight: 18.h,
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFFCF6E7),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColor.buttonOneColor),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 90.w, color: Colors.brown),
              ),
              accountName: Obx(() {
                final name = controller.userName.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : "Welcome...",
                      style: TextStyle(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (name.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 30.w,
                        ),
                      ),
                  ],
                );
              }),
              accountEmail: null,
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text("Leaderboard"),
              onTap: () {
                // String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

                String fixedDate = "2025-08-22";
                String yesterday = DateFormat(
                  "yyyy-MM-dd",
                ).format(DateTime.now().subtract(const Duration(days: 1)));

                Get.to(() => LeaderboardView(selectedDate: yesterday));
              },
            ),

            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Invite"),
              onTap: () async {
                const url = "";
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  Get.snackbar(
                    "Error",
                    "Could not launch Play Store",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About US"),
              onTap: () {
                Get.to((AboutusView()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy policy"),
              onTap: () {
                Get.to((PrivacypolicyView()));
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.list_alt),
            //   title: const Text("Special Questions"),
            //   onTap: () {
            //     Get.toNamed('/special-question-list');
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Contact-Us"),
              onTap: () {
                Get.to((ContactusView()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded),
              title: Text("Logout"),
              onTap: () {
                final box = GetStorage();

                box.erase();

                Get.offAll(() => SignInView());

                Get.snackbar(
                  "Logged Out",
                  "You have been logged out successfully.",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Lottie.asset(
                    'assets/images/lottie/earning.json',
                    height: 100.h,
                    fit: BoxFit.contain,
                  ),
                  ElevatedButton(
                    onPressed: controller.playForEarning,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonOneColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      minimumSize: Size(Get.width / .4, 40.h),
                    ),
                    child: Text(
                      'Daily Quiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 47.sp,
                      ),
                    ),
                  ),
                  Lottie.asset(
                    'assets/images/lottie/learning.json',
                    height: 120.h,
                    fit: BoxFit.contain,
                  ),
                  ElevatedButton(
                    onPressed: controller.playForLearning,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonTwoColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      minimumSize: Size(Get.width / .4, 40.h),
                    ),
                    child: Text(
                      'Current Affairs & G.K',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 45.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
