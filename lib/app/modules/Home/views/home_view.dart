import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../data/config/appcolor.dart';
import '../../../data/models/mock_data.dart';
import '../../../data/widgets/decorative_background.dart';
import '../../../data/widgets/shimmer_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final controller = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      drawer: _buildDrawer(context, controller),
      body: _buildBody(context, controller),
      bottomNavigationBar: _buildBottomNav(controller),
    );
  }

  // ───────────────────────────────────────────
  //  BODY (TAB SWITCHER)
  // ───────────────────────────────────────────

  Widget _buildBody(BuildContext context, HomeController controller) {
    return Obx(
      () => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          _buildHomeTab(context),
          _buildSolutionTab(context),
          _buildLiveTestTab(context),
          _buildProfileTab(context),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  //  BOTTOM NAVIGATION
  // ───────────────────────────────────────────

  Widget _buildBottomNav(HomeController controller) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) {
            if (index == 2) {
              Get.toNamed('/daily-mock-test');
            } else {
              controller.changeTab(index);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.cardColor,
          selectedItemColor: AppColor.buttonOneColor,
          unselectedItemColor: AppColor.textLight,
          selectedFontSize: 11.sp,
          unselectedFontSize: 11.sp,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_rounded),
              label: 'Solution',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.live_tv_rounded),
              label: 'Live Test',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  //  TAB 0: HOME
  // ───────────────────────────────────────────

  Widget _buildHomeTab(BuildContext context) {
    final c = Get.find<HomeController>();
    return DecorativeBackground(
      showBottomDecoration: true,
      child: SafeArea(
        child: Builder(
          builder: (scaffoldContext) => Column(
            children: [
              _buildAppBar(scaffoldContext),
              Expanded(
                child: Obx(() {
                  if (c.isLoading.value) {
                    return ShimmerWidget.pageLoader(itemCount: 5, itemHeight: 160);
                  }
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        SizedBox(height: 8.h),
                        _buildGreeting(),
                        SizedBox(height: 16.h),
                        _buildCarouselBanner(),
                        SizedBox(height: 20.h),
                        _buildAnimationsRow(),
                        SizedBox(height: 28.h),
                        _buildActionButtons(scaffoldContext),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  //  TAB 1: SOLUTION
  // ───────────────────────────────────────────

  Widget _buildSolutionTab(BuildContext context) {
    return SafeArea(
      child: DecorativeBackground(
        showBottomDecoration: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [AppColor.buttonShadow],
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Solution Hub',
                        style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Questions, suggestions & previous papers',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // ── Navigation Cards ──
              _navCard(
                icon: Icons.quiz_rounded,
                title: 'Question & Answers',
                subtitle: '${MockData.qaItems.length} questions with answers',
                gradientColors: const [Color(0xFFB96237), Color(0xFFD4845A)],
                onTap: () => Get.toNamed('/question-answer'),
              ),
              SizedBox(height: 14.h),

              _navCard(
                icon: Icons.tips_and_updates_rounded,
                title: 'Suggestions',
                subtitle: '${MockData.suggestions.length} study tips & guides',
                gradientColors: const [Color(0xFF113650), Color(0xFF1A4F72)],
                onTap: () => Get.toNamed('/suggestion'),
              ),
              SizedBox(height: 14.h),

              _navCard(
                icon: Icons.history_edu_rounded,
                title: 'Previous Year Questions',
                subtitle:
                    '${MockData.previousYearCategories.fold(0, (sum, cat) => sum + cat.years.length)} exam years available',
                gradientColors: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                onTap: () => Get.toNamed('/previous-year-question'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [AppColor.cardShadow],
          border: Border.all(color: AppColor.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 26.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColor.backgroundColorLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: AppColor.textLight,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  //  TAB 2: LIVE MOCK TEST
  // ───────────────────────────────────────────

  Widget _buildLiveTestTab(BuildContext context) {
    return SafeArea(
      child: DecorativeBackground(
        showBottomDecoration: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              // Header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [AppColor.buttonShadow],
                    ),
                    child: Icon(
                      Icons.live_tv_rounded,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Mock Test',
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Attempt today\'s live quiz challenge',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              // Start test card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [AppColor.buttonShadow],
                ),
                child: Column(
                  children: [
                    // Timer icon
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.timer_rounded,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Daily Quiz Challenge',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '10 questions • 3 minutes 20 seconds\nTest your knowledge with today\'s quiz',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Start button
                    GestureDetector(
                      onTap: () => Get.toNamed('/daily-mock-test'),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Start Now',
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColor.buttonOneColor,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColor.buttonOneColor,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Info cards
              Row(
                children: [
                  _infoCard(
                    icon: Icons.quiz_rounded,
                    title: '10 Questions',
                    subtitle: 'Multiple choice',
                    color: AppColor.buttonTwoColor,
                  ),
                  SizedBox(width: 14.w),
                  _infoCard(
                    icon: Icons.timer_rounded,
                    title: '3 min 20 sec',
                    subtitle: 'Time limit',
                    color: AppColor.buttonOneColor,
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              _infoCard(
                icon: Icons.emoji_events_rounded,
                title: '2 marks per question',
                subtitle: 'Total 20 marks possible',
                color: const Color(0xFF2E7D32),
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    bool fullWidth = false,
  }) {
    final widget = Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [AppColor.cardShadow],
        border: Border.all(color: AppColor.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: AppColor.textSecondary,
                ),
              ),
            ],
          ),
          if (fullWidth) const Spacer(),
        ],
      ),
    );

    if (fullWidth) return widget;
    return Expanded(child: widget);
  }

  // ───────────────────────────────────────────
  //  TAB 3: PROFILE
  // ───────────────────────────────────────────

  Widget _buildProfileTab(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 20.h),

            // Avatar & Name
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [AppColor.buttonShadow],
              ),
              child: Obx(() {
                final c = Get.find<HomeController>();
                final initial = c.userName.value.isNotEmpty
                    ? c.userName.value[0].toUpperCase()
                    : 'L';
                return Text(
                  initial,
                  style: GoogleFonts.poppins(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                );
              }),
            ),
            SizedBox(height: 12.h),
            Obx(() {
              final c = Get.find<HomeController>();
              return Text(
                c.userName.value.isNotEmpty ? c.userName.value : 'Learner',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
              );
            }),
            SizedBox(height: 4.h),
            Obx(() {
              final c = Get.find<HomeController>();
              return Text(
                c.userEmail.value.isNotEmpty ? c.userEmail.value : 'learner@example.com',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColor.textSecondary,
                ),
              );
            }),

            SizedBox(height: 24.h),

            // Settings list
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  _profileMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    onTap: () => Get.toNamed('/edit-profile'),
                  ),
                  _profileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () => Get.toNamed('/notifications'),
                  ),
                  _profileMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    onTap: () => Get.toNamed('/about'),
                  ),
                  _profileMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () => Get.toNamed('/terms'),
                  ),
                  _profileMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    iconColor: AppColor.error,
                    textColor: AppColor.error,
                    onTap: () {
                      Get.defaultDialog(
                        title: 'Logout',
                        middleText: 'Are you sure you want to logout?',
                        confirmTextColor: Colors.white,
                        buttonColor: AppColor.buttonOneColor,
                        onConfirm: () => Get.offAllNamed('/sign-in'),
                        onCancel: () {},
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _profileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [AppColor.softShadow],
        border: Border.all(color: AppColor.cardBorder),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColor.buttonTwoColor).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColor.buttonTwoColor,
            size: 20.sp,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: textColor ?? AppColor.textPrimary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColor.textLight,
          size: 20.sp,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  //  DRAWER
  // ───────────────────────────────────────────

  Widget _buildDrawer(BuildContext context, HomeController controller) {
    return Drawer(
      backgroundColor: AppColor.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 20.h),
              decoration: BoxDecoration(
                gradient: AppColor.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28.r),
                  bottomRight: Radius.circular(28.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLogo(size: 64),
                  SizedBox(height: 12.h),
                  Text(
                    "WB PATHSHALA",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Learn & Grow",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Drawer Items
            _drawerItem(
              icon: Icons.dashboard_rounded,
              title: "Dashboard",
              onTap: () {
                Navigator.pop(context);
                controller.changeTab(0);
              },
            ),
            _drawerItem(
              icon: Icons.quiz_rounded,
              title: "Daily Mock Test",
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/daily-mock-test');
              },
            ),
            _drawerItem(
              icon: Icons.list_alt_rounded,
              title: "All Mock Tests",
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/all-mock-tests');
              },
            ),
            const Spacer(),
            // Logout
            _drawerItem(
              icon: Icons.logout_rounded,
              title: "Logout",
              textColor: AppColor.error,
              onTap: () {
                Navigator.pop(context);
                Get.defaultDialog(
                  title: "Logout",
                  middleText: "Are you sure you want to logout?",
                  confirmTextColor: Colors.white,
                  buttonColor: AppColor.buttonOneColor,
                  onConfirm: () => Get.offAllNamed('/sign-in'),
                  onCancel: () {},
                );
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppColor.buttonTwoColor,
        size: 22.sp,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColor.textPrimary,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 8.w,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      hoverColor: AppColor.buttonOneColor.withValues(alpha: 0.05),
    );
  }

  // ───────────────────────────────────────────
  //  APP BAR
  // ───────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          // Menu button (drawer)
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [AppColor.softShadow],
              ),
              child: Icon(
                Icons.menu_rounded,
                color: AppColor.buttonTwoColor,
                size: 22.sp,
              ),
            ),
          ),
          const Spacer(),
          // Logo / Title
          Text(
            "WB PATHSHALA",
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          // Notification button
          GestureDetector(
            onTap: () => _showComingSoon(context, "Notifications"),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [AppColor.softShadow],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_rounded,
                    color: AppColor.buttonOneColor,
                    size: 22.sp,
                  ),
                  // Badge dot
                  Positioned(
                    top: -2.r,
                    right: -2.r,
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: AppColor.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  //  GREETING
  // ───────────────────────────────────────────

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;

    if (hour < 12) {
      greeting = "Good Morning! ☀️";
      greetingIcon = Icons.wb_sunny_rounded;
    } else if (hour < 17) {
      greeting = "Good Afternoon! 🌤️";
      greetingIcon = Icons.wb_cloudy_rounded;
    } else {
      greeting = "Good Evening! 🌙";
      greetingIcon = Icons.nightlight_round;
    }

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            gradient: AppColor.navyGradient,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(greetingIcon, color: Colors.white, size: 18.sp),
        ),
        SizedBox(width: 10.w),
        Text(
          greeting,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textPrimary,
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────
  //  CAROUSEL BANNER
  // ───────────────────────────────────────────

  Widget _buildCarouselBanner() {
    return SizedBox(height: 160.h, child: _CarouselBanner());
  }

  // ───────────────────────────────────────────
  //  ANIMATIONS ROW
  // ───────────────────────────────────────────

  Widget _buildAnimationsRow() {
    return Row(
      children: [
        Expanded(
          child: _animationCard(
            lottieAsset: 'assets/lottie/earning.json',
            title: "Earn & Learn",
            subtitle: "Practice daily to earn rewards",
            gradient: AppColor.primaryGradient,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: _animationCard(
            lottieAsset: 'assets/lottie/learning.json',
            title: "Smart Learning",
            subtitle: "Interactive study sessions",
            gradient: AppColor.navyGradient,
          ),
        ),
      ],
    );
  }

  Widget _animationCard({
    required String lottieAsset,
    required String title,
    required String subtitle,
    required Gradient gradient,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [AppColor.cardShadow],
      ),
      child: Column(
        children: [
          // Lottie Animation
          Container(
            height: 110.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: AppColor.backgroundColorLight,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Lottie.asset(
                lottieAsset,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Title
          ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              color: AppColor.textSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────
  //  ACTION BUTTONS
  // ───────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Daily Mock Test
        GestureDetector(
          onTap: () => Get.toNamed('/daily-mock-test'),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [AppColor.buttonShadow],
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.today_rounded,
                    color: Colors.white,
                    size: 26.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Mock Test",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Attempt today's quiz challenge",
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 14.h),

        // All Mock Tests
        GestureDetector(
          onTap: () => Get.toNamed('/all-mock-tests'),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              gradient: AppColor.navyGradient,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [AppColor.buttonShadowNavy],
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.list_alt_rounded,
                    color: Colors.white,
                    size: 26.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All Mock Tests",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Browse all available test series",
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 6.h),
                    ],
                  ),
                ),
                // Arrow
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────
  //  HELPERS
  // ───────────────────────────────────────────

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$feature - Coming Soon!",
          style: GoogleFonts.poppins(fontSize: 13.sp),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        backgroundColor: AppColor.buttonTwoColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ───────────────────────────────────────────────
//  CAROUSEL BANNER WIDGET
// ───────────────────────────────────────────────

class _CarouselBanner extends StatefulWidget {
  @override
  State<_CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<_CarouselBanner> {
  final _pageController = PageController(viewportFraction: 0.92);
  final _currentPage = 0.obs;
  Timer? _autoScrollTimer;

  final _banners = [
    _BannerData(
      title: 'Daily Quiz Challenge',
      subtitle: 'Test your knowledge with\ntoday\'s 10-question quiz',
      icon: Icons.quiz_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFFB96237), Color(0xFFD4845A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    _BannerData(
      title: 'New Mock Tests',
      subtitle: 'Fresh test series added\nfor all classes',
      icon: Icons.assignment_turned_in_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF113650), Color(0xFF1A4F72)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    _BannerData(
      title: 'Track Progress',
      subtitle: 'Review your results and\nimprove every day',
      icon: Icons.trending_up_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    _BannerData(
      title: 'Stay Ahead',
      subtitle: 'Practice daily to ace\nyour exams with confidence',
      icon: Icons.emoji_events_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage.value + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              _currentPage.value = index;
              _autoScrollTimer?.cancel();
              _startAutoScroll();
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return _buildBannerSlide(banner);
            },
          ),
        ),
        SizedBox(height: 8.h),
        // Dot indicators
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (i) {
              final isActive = _currentPage.value == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: isActive ? 20.w : 8.r,
                height: 6.h,
                decoration: BoxDecoration(
                  gradient: isActive ? AppColor.primaryGradient : null,
                  color: isActive ? null : AppColor.shimmerBase,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerSlide(_BannerData banner) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        gradient: banner.gradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: banner.gradient.colors[0].withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20.h,
            right: -20.w,
            child: Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -30.h,
            left: -10.w,
            child: Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        banner.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        banner.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Icon
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(banner.icon, color: Colors.white, size: 26.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;

  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}
