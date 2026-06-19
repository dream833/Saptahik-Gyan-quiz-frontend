import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/config/appcolor.dart';
import '../../../../data/models/mock_data.dart';
import '../../../../data/widgets/decorative_background.dart';

class PreviousYearQuestionView extends StatelessWidget {
  const PreviousYearQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Icon(
              Icons.arrow_back_rounded,
              color: AppColor.buttonTwoColor,
              size: 22.sp,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.history_edu_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Previous Year Questions',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: const _PyqBody(),
    );
  }
}

// ── Controller ──

class _PyqController extends GetxController {
  final selectedCategory = Rx<PreviousYearCategory?>(null);
  final selectedYear = Rx<int?>(null);
  final selectedSubjectId = Rx<int?>(null);

  List<AppSubject> get subjectsForYear {
    final cat = selectedCategory.value;
    final yr = selectedYear.value;
    if (cat == null || yr == null) return [];
    return cat.subjectsForYear(yr);
  }

  List<QAItem> get qaItems {
    final cat = selectedCategory.value;
    final yr = selectedYear.value;
    final subId = selectedSubjectId.value;
    if (cat == null || yr == null || subId == null) return [];
    return cat.questionsForSubject(yr, subId);
  }

  int countForSubject(int subjectId) {
    final cat = selectedCategory.value;
    final yr = selectedYear.value;
    if (cat == null || yr == null) return 0;
    return cat.questionsForSubject(yr, subjectId).length;
  }

  void resetTo(int step) {
    if (step <= 0) {
      selectedCategory.value = null;
      selectedYear.value = null;
      selectedSubjectId.value = null;
    } else if (step <= 1) {
      selectedYear.value = null;
      selectedSubjectId.value = null;
    } else if (step <= 2) {
      selectedSubjectId.value = null;
    }
  }
}

// ── Body ──

class _PyqBody extends StatelessWidget {
  const _PyqBody();

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<_PyqController>()
        ? Get.find<_PyqController>()
        : Get.put(_PyqController());
    return Obx(
      () => DecorativeBackground(
        showBottomDecoration: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _breadcrumb(c),
              SizedBox(height: 16.h),
              if (c.selectedCategory.value == null)
                _categoriesList(c)
              else if (c.selectedYear.value == null)
                _yearsList(c)
              else if (c.selectedSubjectId.value == null)
                _subjectsList(c)
              else
                _qaList(c),
            ],
          ),
        ),
      ),
    );
  }

  // ── Breadcrumb ──

  Widget _breadcrumb(_PyqController c) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(
            'Category',
            c.selectedCategory.value == null,
            () => c.resetTo(0),
          ),
          if (c.selectedCategory.value != null) ...[
            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.textLight,
              size: 16.sp,
            ),
            _chip(
              c.selectedCategory.value!.name,
              c.selectedYear.value == null,
              () => c.resetTo(1),
            ),
          ],
          if (c.selectedYear.value != null) ...[
            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.textLight,
              size: 16.sp,
            ),
            _chip(
              '${c.selectedYear.value}',
              c.selectedSubjectId.value == null,
              () => c.resetTo(2),
            ),
          ],
          if (c.selectedSubjectId.value != null) ...[
            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.textLight,
              size: 16.sp,
            ),
            _chip(
              MockData.subjects
                  .firstWhere((s) => s.id == c.selectedSubjectId.value)
                  .name,
              true,
              null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: active
              ? AppColor.success.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? AppColor.success : AppColor.textSecondary,
          ),
        ),
      ),
    );
  }

  // ── Step 0 ──

  Widget _categoriesList(_PyqController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Center(
          child: Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.history_edu_rounded,
              color: Colors.white,
              size: 40.sp,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Text(
            'Previous Year Papers',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Center(
          child: Text(
            'Select an exam category',
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              color: AppColor.textSecondary,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        ...MockData.previousYearCategories.map((cat) {
          return GestureDetector(
            onTap: () => c.selectedCategory.value = cat,
            child: Container(
              margin: EdgeInsets.only(bottom: 14.h),
              padding: EdgeInsets.all(18.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [AppColor.cardShadow],
                border: Border.all(color: AppColor.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52.r,
                    height: 52.r,
                    decoration: BoxDecoration(
                      color: AppColor.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.school_rounded,
                        color: AppColor.success,
                        size: 26.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.name,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          cat.subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: AppColor.textSecondary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${cat.years.length} years available',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColor.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColor.success,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Step 1 ──

  Widget _yearsList(_PyqController c) {
    final cat = c.selectedCategory.value!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _backBtn(() => c.resetTo(0)),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select year',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textSecondary,
                  ),
                ),
                Text(
                  cat.name,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: AppColor.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: cat.years.map((y) {
            final subCount = cat.subjectsForYear(y).length;
            return GestureDetector(
              onTap: () => c.selectedYear.value = y,
              child: Container(
                width: (1.sw - 64.w) / 3,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColor.cardColor,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [AppColor.softShadow],
                  border: Border.all(color: AppColor.cardBorder),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '$y',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '$subCount subjects',
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Step 2 ──

  Widget _subjectsList(_PyqController c) {
    final cat = c.selectedCategory.value!;
    final yr = c.selectedYear.value!;
    final subjects = c.subjectsForYear;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _backBtn(() => c.resetTo(1)),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose a subject',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textSecondary,
                    ),
                  ),
                  Text(
                    '${cat.name} $yr',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: AppColor.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        ...subjects.map((s) {
          final qCount = c.countForSubject(s.id);
          return GestureDetector(
            onTap: () => c.selectedSubjectId.value = s.id,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [AppColor.softShadow],
                border: Border.all(color: AppColor.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: AppColor.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: Text(s.icon, style: TextStyle(fontSize: 22.sp)),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '$qCount questions available',
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
                      color: AppColor.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColor.success,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        if (subjects.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    color: AppColor.textLight,
                    size: 40.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'No subjects available for this year.',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ── Step 3 ──

  Widget _qaList(_PyqController c) {
    final sub = MockData.subjects.firstWhere(
      (s) => s.id == c.selectedSubjectId.value,
    );
    final cat = c.selectedCategory.value!;
    final yr = c.selectedYear.value!;
    final items = c.qaItems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _backBtn(() => c.resetTo(2)),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.name,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  Text(
                    '${cat.name} $yr',
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: AppColor.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColor.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '${items.length} Qs',
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.success,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...items.map((item) => _qaCard(item)),
        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    color: AppColor.textLight,
                    size: 40.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'No questions available for this selection.',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _qaCard(QAItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [AppColor.softShadow],
        border: Border.all(color: AppColor.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColor.success.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2.h, right: 10.w),
                  child: Icon(
                    Icons.help_rounded,
                    color: AppColor.success,
                    size: 18.sp,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.question,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _copyText(item.question, 'Question'),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: AppColor.success.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.copy_rounded,
                      color: AppColor.success,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppColor.cardBorder),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2.h, right: 10.w),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColor.buttonOneColor,
                    size: 18.sp,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.answer,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _copyText(item.answer, 'Answer'),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: AppColor.buttonOneColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.copy_rounded,
                      color: AppColor.buttonOneColor,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyText(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_rounded, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Text('$label copied!', style: GoogleFonts.poppins(fontSize: 12.sp)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        backgroundColor: AppColor.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _backBtn(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: AppColor.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: AppColor.success,
          size: 16.sp,
        ),
      ),
    );
  }
}
