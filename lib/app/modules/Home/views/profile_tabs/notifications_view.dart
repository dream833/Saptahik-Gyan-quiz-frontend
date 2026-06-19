import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/config/appcolor.dart';

// ── Controller ──

class _NotifController extends GetxController {
  final pushEnabled = true.obs;
  final emailEnabled = false.obs;
  final smsEnabled = false.obs;
  final testRemindersEnabled = true.obs;
  final studyTipsEnabled = true.obs;
  final resultUpdatesEnabled = true.obs;
}

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<_NotifController>()
        ? Get.find<_NotifController>()
        : Get.put(_NotifController());

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [AppColor.softShadow],
            ),
            child: Icon(Icons.arrow_back_rounded,
                color: AppColor.buttonTwoColor, size: 22.sp),
          ),
        ),
        title: Text('Notifications',
            style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Text('Manage your notification preferences',
                style: GoogleFonts.poppins(
                    fontSize: 12.sp, color: AppColor.textSecondary)),
            SizedBox(height: 20.h),

            // Push Notifications
            _buildToggle(
              icon: Icons.notifications_active_rounded,
              title: 'Push Notifications',
              subtitle: 'Receive alerts on your device',
              rxValue: c.pushEnabled,
            ),
            SizedBox(height: 10.h),

            // Email Notifications
            _buildToggle(
              icon: Icons.email_rounded,
              title: 'Email Notifications',
              subtitle: 'Get updates via email',
              rxValue: c.emailEnabled,
            ),
            SizedBox(height: 10.h),

            // SMS Notifications
            _buildToggle(
              icon: Icons.sms_rounded,
              title: 'SMS Notifications',
              subtitle: 'Receive text message alerts',
              rxValue: c.smsEnabled,
            ),
            SizedBox(height: 10.h),

            // Divider
            Container(
                height: 1,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                color: AppColor.cardBorder),
            SizedBox(height: 4.h),

            Text('Notification Types',
                style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary)),
            SizedBox(height: 10.h),

            // Test Reminders
            _buildToggle(
              icon: Icons.quiz_rounded,
              title: 'Test Reminders',
              subtitle: 'Reminders before scheduled tests',
              rxValue: c.testRemindersEnabled,
            ),
            SizedBox(height: 10.h),

            // Study Tips
            _buildToggle(
              icon: Icons.tips_and_updates_rounded,
              title: 'Study Tips',
              subtitle: 'Daily study tips and suggestions',
              rxValue: c.studyTipsEnabled,
            ),
            SizedBox(height: 10.h),

            // Result Updates
            _buildToggle(
              icon: Icons.assignment_turned_in_rounded,
              title: 'Result Updates',
              subtitle: 'Get notified when results are published',
              rxValue: c.resultUpdatesEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required RxBool rxValue,
  }) {
    return Obx(() => Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [AppColor.softShadow],
            border: Border.all(color: AppColor.cardBorder),
          ),
          child: Row(children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: rxValue.value
                    ? AppColor.buttonTwoColor.withValues(alpha: 0.1)
                    : AppColor.backgroundColorLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon,
                  color: rxValue.value
                      ? AppColor.buttonTwoColor
                      : AppColor.textLight,
                  size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary)),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: GoogleFonts.poppins(
                          fontSize: 10.sp, color: AppColor.textSecondary)),
                ],
              ),
            ),
            Switch.adaptive(
              value: rxValue.value,
              onChanged: (v) => rxValue.value = v,
              activeTrackColor: AppColor.buttonTwoColor,
            ),
          ]),
        ));
  }
}
