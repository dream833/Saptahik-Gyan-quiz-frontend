import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/appcolor.dart';
import '../../../data/models/mock_data.dart';
import '../../../data/widgets/decorative_background.dart';
import '../../../data/widgets/shimmer_widget.dart';
import '../controllers/daily_mock_test_controller.dart';

class DailyMockTestView extends StatelessWidget {
  const DailyMockTestView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DailyMockTestController>();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: DecorativeBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context, controller),
              Expanded(
                child: Obx(() {
                  // Show shimmer when loading data
                  if (controller.isLoading.value &&
                      (controller.availableClasses.isEmpty ||
                          (controller.currentStep.value == 1 &&
                              controller.subjects.isEmpty) ||
                          (controller.currentStep.value == 2 &&
                              controller.testList.isEmpty))) {
                    if (controller.currentStep.value == 0) {
                      return _buildClassShimmer(controller);
                    } else if (controller.currentStep.value == 1) {
                      return _buildSubjectShimmer();
                    } else {
                      return _buildTestShimmer();
                    }
                  }
                  switch (controller.currentStep.value) {
                    case 0:
                      return _buildClassSelection(controller);
                    case 1:
                      return _buildSubjectSelection(controller);
                    case 2:
                      return _buildTestList(controller);
                    default:
                      return _buildClassSelection(controller);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  //  APP BAR
  // ───────────────────────────────────────────

  Widget _buildAppBar(
    BuildContext context,
    DailyMockTestController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (controller.currentStep.value == 0) {
                Get.back();
              } else if (controller.currentStep.value == 1) {
                controller.goBackToClass();
              } else {
                controller.goBackToSubject();
              }
            },
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [AppColor.softShadow],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColor.buttonTwoColor,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Obx(() {
            final titles = ['Choose Class', 'Choose Subject', 'Select Test'];
            return Text(
              titles[controller.currentStep.value],
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            );
          }),
          const Spacer(),
          // Step indicator
          Obx(() => _stepIndicator(controller.currentStep.value)),
        ],
      ),
    );
  }

  Widget _stepIndicator(int step) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColor.buttonOneColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return Container(
            width: 8.r,
            height: 8.r,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i <= step ? AppColor.buttonOneColor : AppColor.textLight,
            ),
          );
        }),
      ),
    );
  }

  // ───────────────────────────────────────────
  //  STEP 1: CLASS SELECTION
  // ───────────────────────────────────────────

  Widget _buildClassShimmer(DailyMockTestController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          ShimmerWidget.textLine(width: 200, height: 28),
          SizedBox(height: 6.h),
          ShimmerWidget.textLine(width: 250, height: 16),
          SizedBox(height: 24.h),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
                childAspectRatio: 1.1,
              ),
              itemCount: 4,
              itemBuilder: (context, index) =>
                  ShimmerWidget.rect(height: 180, borderRadius: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          ShimmerWidget.textLine(width: 200, height: 28),
          SizedBox(height: 6.h),
          ShimmerWidget.textLine(width: 220, height: 16),
          SizedBox(height: 20.h),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.h,
                childAspectRatio: 1.0,
              ),
              itemCount: 4,
              itemBuilder: (context, index) =>
                  ShimmerWidget.rect(height: 160, borderRadius: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          ShimmerWidget.textLine(width: 200, height: 28),
          SizedBox(height: 6.h),
          ShimmerWidget.textLine(width: 250, height: 16),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: ShimmerWidget.rect(height: 100, borderRadius: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassSelection(DailyMockTestController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Text(
            'Select Your Class',
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Choose your class to start the daily mock test',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColor.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          Expanded(
            child: controller.availableClasses.isEmpty
                ? _emptyState(
                    Icons.school_outlined,
                    'No classes available',
                    'Check back later for new classes',
                  )
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: controller.availableClasses.length,
                    itemBuilder: (context, index) {
                      final appClass = controller.availableClasses[index];
                      return _classCard(controller, appClass, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _classCard(
    DailyMockTestController controller,
    AppClass appClass,
    int index,
  ) {
    final gradients = [
      AppColor.primaryGradient,
      AppColor.navyGradient,
      LinearGradient(
        colors: [const Color(0xFF2E7D32), const Color(0xFF66BB6A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    final safeIndex = index % gradients.length;
    return GestureDetector(
      onTap: () => controller.selectClass(appClass),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradients[safeIndex],
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: gradients[safeIndex].colors[0].withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  appClass.grade,
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              appClass.name,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  //  STEP 2: SUBJECT SELECTION
  // ───────────────────────────────────────────

  Widget _buildSubjectSelection(DailyMockTestController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          // Selected class chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColor.buttonOneColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_rounded,
                  size: 14.sp,
                  color: AppColor.buttonOneColor,
                ),
                SizedBox(width: 6.w),
                Text(
                  controller.selectedClass.value?.name ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.buttonOneColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Choose a Subject',
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Select subject for ${controller.selectedClass.value?.name ?? ''}',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColor.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: controller.subjects.isEmpty
                ? _emptyState(
                    Icons.book_outlined,
                    'No subjects available',
                    'No subjects found for this class',
                  )
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: controller.subjects.length,
                    itemBuilder: (context, index) {
                      final subject = controller.subjects[index];
                      return _subjectCard(controller, subject, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _subjectCard(
    DailyMockTestController controller,
    AppSubject subject,
    int index,
  ) {
    final subjectIcons = <String, IconData>{
      'Bangla': Icons.menu_book_rounded,
      'English': Icons.book_rounded,
      'Mathematics': Icons.calculate_rounded,
      'Science': Icons.science_rounded,
      'History': Icons.history_edu_rounded,
      'Geography': Icons.public_rounded,
    };

    final subjectColors = <Color>[
      const Color(0xFFB96237),
      const Color(0xFF113650),
      const Color(0xFF2E7D32),
      const Color(0xFF6A1B9A),
      const Color(0xFF1565C0),
      const Color(0xFFE65100),
    ];

    final color = subjectColors[index % subjectColors.length];

    return GestureDetector(
      onTap: () => controller.selectSubject(subject),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [AppColor.cardShadow],
          border: Border.all(color: AppColor.cardBorder),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                subjectIcons[subject.name] ?? Icons.book_rounded,
                color: color,
                size: 30.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              subject.name,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(subject.icon, style: TextStyle(fontSize: 18.sp)),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────
  //  STEP 3: TEST LIST
  // ───────────────────────────────────────────

  Widget _buildTestList(DailyMockTestController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          // Breadcrumb
          Row(
            children: [
              _breadcrumbChip(
                controller.selectedClass.value?.name ?? '',
                AppColor.buttonOneColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Icon(
                  Icons.chevron_right,
                  size: 16.sp,
                  color: AppColor.textLight,
                ),
              ),
              if (controller.selectedSubject.value != null)
                _breadcrumbChip(
                  controller.selectedSubject.value!.name,
                  AppColor.buttonTwoColor,
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Available Tests',
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '${controller.selectedSubject.value?.name ?? ''} mock tests for ${controller.selectedClass.value?.name ?? ''}',
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColor.textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: controller.testList.isEmpty
                ? _emptyState(
                    Icons.quiz_outlined,
                    'No tests available',
                    'No tests found for this subject',
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.testList.length,
                    itemBuilder: (context, index) {
                      final test = controller.testList[index];
                      return _testCard(controller, test, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _breadcrumbChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _testCard(
    DailyMockTestController controller,
    MockTestInfo test,
    int index,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: GestureDetector(
        onTap: () => controller.selectTest(test),
        child: Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [AppColor.cardShadow],
            border: Border.all(color: AppColor.cardBorder),
          ),
          child: Row(
            children: [
              // Number circle
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  gradient: AppColor.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.name,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      test.description,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: AppColor.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        _testMeta(
                          Icons.quiz_rounded,
                          '${test.totalQuestions} Qs',
                          AppColor.buttonOneColor,
                        ),
                        SizedBox(width: 12.w),
                        _testMeta(
                          Icons.timer_outlined,
                          '${test.totalTime} min',
                          AppColor.buttonTwoColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColor.textLight,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: AppColor.backgroundColorLight,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(icon, size: 48.sp, color: AppColor.textLight),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: AppColor.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _testMeta(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.sp, color: color),
        SizedBox(width: 4.w),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
