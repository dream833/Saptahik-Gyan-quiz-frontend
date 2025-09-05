import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:quiz/app/data/config/appcolor.dart';
import 'package:quiz/app/modules/Leaderboard/views/leaderboard_view.dart';
import 'package:quiz/app/modules/PreviousQuiz/views/previous_quiz_view.dart';
import 'package:quiz/app/modules/livequiz/views/livequiz_view.dart';

import '../controllers/earning_controller.dart';

class EarningView extends GetView<EarningController> {
  const EarningView({super.key});
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.buttonOneColor,
        toolbarHeight: 15.h,
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
             
                  ElevatedButton(
                    onPressed: () {
                      Get.to( () => LivequizView());
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonOneColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      minimumSize: Size(Get.width / .4, 40.h),
                    ),
                    child: Text(
                      'Live Quiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 47.sp,
                      ),
                    ),
                  ),

                 
                  ElevatedButton(
                    onPressed: () {
                      Get.to( () => PreviousQuizView());
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonTwoColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      minimumSize: Size(Get.width / .4, 40.h),
                    ),
                    child: Text(
                      'Previous Quiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 45.sp,
                      ),
                    ),
                  ),
                    ElevatedButton(
                    onPressed: () {
                       String fixedDate = "2025-08-22";
                String yesterday = DateFormat(
                  "yyyy-MM-dd",
                ).format(DateTime.now().subtract(const Duration(days: 1),),);

                  Get.to(() => LeaderboardView(selectedDate: yesterday));
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonOneColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      minimumSize: Size(Get.width / .4, 40.h),
                    ),
                    child: Text(
                      'Leaderboard',
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