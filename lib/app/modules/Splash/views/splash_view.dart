import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/appcolor.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColor.backgroundGradient,
        ),
        child: Stack(
          children: [
            // ── Decorative circles ──
            Positioned(
              top: -80.h,
              right: -80.w,
              child: Container(
                width: 260.r,
                height: 260.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.buttonOneColor.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(
              top: 140.h,
              left: -60.w,
              child: Container(
                width: 160.r,
                height: 160.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.buttonTwoColor.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -100.h,
              left: -100.w,
              child: Container(
                width: 320.r,
                height: 320.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.buttonOneColor.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: 140.h,
              right: -60.w,
              child: Container(
                width: 180.r,
                height: 180.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.accent.withValues(alpha: 0.06),
                ),
              ),
            ),

            // ── Center content ──
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Splash logo image
                      _SplashFadeIn(
                        delay: 200,
                        child: Container(
                          width: 200.r,
                          height: 200.r,
                          decoration: BoxDecoration(
                            color: AppColor.cardColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.buttonOneColor.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white,
                              width: 6,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/splashs.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    gradient: AppColor.primaryGradient,
                                  ),
                                  child: Icon(
                                    Icons.auto_stories_rounded,
                                    color: Colors.white,
                                    size: 80.r,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // App name
                      _SplashFadeIn(
                        delay: 500,
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColor.primaryGradient.createShader(bounds),
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            'WB PATHSHALA',
                            style: GoogleFonts.poppins(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Tagline
                      _SplashFadeIn(
                        delay: 700,
                        child: Text(
                          'Learn & Grow',
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom progress indicator ──
            Positioned(
              bottom: 60.h,
              left: 0,
              right: 0,
              child: _SplashFadeIn(
                delay: 900,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColor.buttonOneColor,
                        backgroundColor:
                            AppColor.buttonOneColor.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple fade + slide-in animation used for splash elements.
class _SplashFadeIn extends StatefulWidget {
  final Widget child;
  final int delay; // milliseconds

  const _SplashFadeIn({required this.child, this.delay = 0});

  @override
  State<_SplashFadeIn> createState() => _SplashFadeInState();
}

class _SplashFadeInState extends State<_SplashFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
