import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/appcolor.dart';

/// A decorative background with subtle shapes and gradients
class DecorativeBackground extends StatelessWidget {
  final Widget child;
  final bool showTopDecoration;
  final bool showBottomDecoration;

  const DecorativeBackground({
    super.key,
    required this.child,
    this.showTopDecoration = true,
    this.showBottomDecoration = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColor.backgroundGradient,
      ),
      child: Stack(
        children: [
          // Top right decorative circle
          if (showTopDecoration)
            Positioned(
              top: -60.h,
              right: -60.w,
              child: Container(
                width: 200.r,
                height: 200.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.buttonOneColor.withValues(alpha: 0.06),
                ),
              ),
            ),
          // Top left small circle
          if (showTopDecoration)
            Positioned(
              top: 80.h,
              left: -30.w,
              child: Container(
                width: 100.r,
                height: 100.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.buttonTwoColor.withValues(alpha: 0.05),
                ),
              ),
            ),
          // Bottom left large circle
          if (showBottomDecoration)
            Positioned(
              bottom: -80.h,
              left: -80.w,
              child: Container(
                width: 250.r,
                height: 250.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.buttonOneColor.withValues(alpha: 0.04),
                ),
              ),
            ),
          // Bottom right small circle
          if (showBottomDecoration)
            Positioned(
              bottom: 120.h,
              right: -40.w,
              child: Container(
                width: 120.r,
                height: 120.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.accent.withValues(alpha: 0.05),
                ),
              ),
            ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

/// App logo widget that uses the app_logos.png asset
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.buttonOneColor.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Image.asset(
          'assets/images/app_logos.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: size.r * 0.5,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Section header with decorative line
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 4.h),
          Text(
            subtitle!,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColor.textSecondary,
            ),
          ),
        ],
        SizedBox(height: 16.h),
        Container(
          width: 40.w,
          height: 3.h,
          decoration: BoxDecoration(
            gradient: AppColor.primaryGradient,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }
}
