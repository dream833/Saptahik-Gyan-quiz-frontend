import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:wbpathshala/app/data/config/appcolor.dart';

class ShimmerWidget {
  /// Shimmer for text lines
  static Widget textLine({
    double width = double.infinity,
    double height = 14,
    double borderRadius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: width == double.infinity ? width : width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }

  /// Shimmer circular image
  static Widget circle({double radius = 30}) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: radius.r,
        height: radius.r,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Shimmer rounded rectangle
  static Widget rect({
    double width = double.infinity,
    double height = 100,
    double borderRadius = 16,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: width == double.infinity ? width : width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }

  /// Shimmer card (full card with image + text lines)
  static Widget card({
    double height = 160,
    double borderRadius = 20,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: 200.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            const Spacer(),
            Container(
              width: 80.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shimmer for button
  static Widget button({
    double height = 50,
    double borderRadius = 30,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }

  /// Shimmer for form field
  static Widget formField({double height = 54}) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: double.infinity,
        height: height.h,
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  /// Full page shimmer loader
  static Widget pageLoader({
    int itemCount = 3,
    double itemHeight = 140,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: List.generate(itemCount, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Container(
                width: double.infinity,
                height: itemHeight.h,
                decoration: BoxDecoration(
                  color: AppColor.shimmerBase,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            );
            }),
          ),
        ),
      ),
    );
  }

  /// Card shimmer for loading state (e.g., for home screen buttons)
  static Widget homeButtonShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBase,
      highlightColor: AppColor.shimmerHighlight,
      child: Container(
        width: double.infinity,
        height: 180.h,
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColor.shimmerBase,
          borderRadius: BorderRadius.circular(28.r),
        ),
      ),
    );
  }
}
