import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/config/appcolor.dart';
import '../../../../data/function/dio_post.dart';
import '../../../../data/widgets/shimmer_widget.dart';

// ── Notification model ──

class AppNotification {
  final int id;
  final String title;
  final String message;
  final String type; // test | solution | custom
  final String createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? 'custom',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

// ── Controller ──

class NotificationsController extends GetxController {
  var isLoading = true.obs;
  var notifications = <AppNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      // Keep the current list visible during pull-to-refresh;
      // only show the full-screen shimmer on first load / empty state.
      if (notifications.isEmpty) {
        isLoading.value = true;
      }
      final response = await dioPost(
        endUrl: "/get-notifications.php",
        data: {},
      );

      log("Notifications Response: ${response.data}");

      if (response.data['status'] == true && response.data['data'] != null) {
        notifications.value = (response.data['data'] as List)
            .map((n) => AppNotification.fromJson(n as Map<String, dynamic>))
            .toList();
      } else {
        notifications.clear();
      }
    } catch (e) {
      log("Notifications fetch error: $e");
      notifications.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

// ── View ──

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<NotificationsController>()
        ? Get.find<NotificationsController>()
        : Get.put(NotificationsController());

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
      body: Obx(() {
        // Loading shimmer
        if (c.isLoading.value) {
          return ShimmerWidget.pageLoader(itemCount: 5, itemHeight: 120);
        }

        // Empty state
        if (c.notifications.isEmpty) {
          return _buildEmptyState();
        }

        // List
        return RefreshIndicator(
          color: AppColor.buttonOneColor,
          backgroundColor: AppColor.cardColor,
          onRefresh: () => c.fetchNotifications(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
            itemCount: c.notifications.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return _buildNotificationCard(c.notifications[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationCard(AppNotification n) {
    final (icon, color, label) = _typeMeta(n.type);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [AppColor.softShadow],
        border: Border.all(color: AppColor.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type icon
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        n.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Type chip
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                if (n.message.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    n.message,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
                SizedBox(height: 6.h),
                // Timestamp
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 12.sp,
                      color: AppColor.textLight,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _formatDate(n.createdAt),
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: AppColor.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                shape: BoxShape.circle,
                boxShadow: [AppColor.softShadow],
              ),
              child: Icon(
                Icons.notifications_off_rounded,
                color: AppColor.textLight,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No notifications yet',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                'New alerts about tests, solutions and offers will appear here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns (icon, color, label) based on the notification type.
  (IconData, Color, String) _typeMeta(String type) {
    switch (type) {
      case 'test':
        return (Icons.quiz_rounded, AppColor.buttonOneColor, 'Test');
      case 'solution':
        return (Icons.lightbulb_rounded, AppColor.buttonTwoColor, 'Solution');
      default:
        return (Icons.campaign_rounded, const Color(0xFF2E7D32), 'Notice');
    }
  }

  /// Formats "YYYY-MM-DD HH:MM:SS" into "d MMM yyyy, hh:mm a".
  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final parts = raw.split(' ');
      final datePart = parts.isNotEmpty ? parts[0] : '';
      final timePart = parts.length > 1 ? parts[1] : '';
      final date = datePart.isEmpty ? null : DateTime.tryParse(datePart);
      if (date == null) return raw;

      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];

      var formatted = '${date.day} ${months[date.month - 1]} ${date.year}';
      if (timePart.isNotEmpty) {
        final t = DateTime.tryParse('1970-01-01 $timePart');
        if (t != null) {
          var hour = t.hour;
          final minute = t.minute.toString().padLeft(2, '0');
          final period = hour >= 12 ? 'PM' : 'AM';
          hour = hour % 12 == 0 ? 12 : hour % 12;
          formatted += ', $hour:$minute $period';
        }
      }
      return formatted;
    } catch (e) {
      return raw;
    }
  }
}
