import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:developer';

import '../../../../data/config/appcolor.dart';
import '../../../../data/config/app_cons.dart';
import '../../../../data/function/dio_post.dart';
import '../../../../data/models/mock_data.dart';
import '../../../../data/widgets/decorative_background.dart';
import '../../../../data/widgets/shimmer_widget.dart';

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
  var isLoading = false.obs;

  // API data
  var categories = <Map<String, dynamic>>[].obs;
  var subjects = <AppSubject>[].obs;
  var pyqItems = <QAItem>[].obs;
  var pdfUrl = Rx<String?>(null);

  // Selected state
  final selectedCategory = Rx<String?>(null);
  final selectedYear = Rx<int?>(null);
  final selectedSubjectId = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/pyq/categories.php",
        data: {},
      );

      if (response.data['data'] != null) {
        categories.value = (response.data['data'] as List).map((c) {
          return {
            'name': c['name'] ?? '',
            'subtitle': c['subtitle'] ?? '',
            'years': (c['years'] as List?)?.map((y) => y as int).toList() ?? <int>[],
          };
        }).toList();
      }
    } catch (e) {
      log("PYQ fetch categories error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubjects(String category, int year) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/pyq/subjects.php",
        data: {
          "category": category,
          "year": year,
        },
      );

      if (response.data['data'] != null) {
        subjects.value = (response.data['data'] as List).map((s) {
          return AppSubject(
            id: s['id'] ?? 0,
            name: s['name'] ?? '',
            icon: '📚',
          );
        }).toList();
      }
    } catch (e) {
      log("PYQ fetch subjects error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchQuestions(String category, int year, int subjectId) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/pyq/questions.php",
        data: {
          "category": category,
          "year": year,
          "subject_id": subjectId,
        },
      );

      if (response.data['data'] != null) {
        final dataList = response.data['data'] as List;
        if (dataList.isNotEmpty && dataList.first['pdf_file'] != null) {
          pdfUrl.value = '${BASE_URL.replaceAll('/Api/app', '/')}${dataList.first['pdf_file']}';
        }

        // Map to QAItem list for display
        pyqItems.value = dataList.map((item) {
          return QAItem(
            id: item['id'] ?? 0,
            question: '${item['subject_name'] ?? 'Subject'} - ${item['year'] ?? year}',
            answer: 'PDF: ${item['pdf_file'] ?? ''}',
            type: QuestionType.veryShort,
            subjectId: item['subject_id'] ?? subjectId,
          );
        }).toList();
      }
    } catch (e) {
      log("PYQ fetch questions error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String name) {
    selectedCategory.value = name;
    selectedYear.value = null;
    selectedSubjectId.value = null;
    subjects.clear();
    pyqItems.clear();
    pdfUrl.value = null;
  }

  void selectYear(int year) {
    selectedYear.value = year;
    selectedSubjectId.value = null;
    pyqItems.clear();
    pdfUrl.value = null;
    final cat = selectedCategory.value;
    if (cat != null) {
      fetchSubjects(cat, year);
    }
  }

  void selectSubject(int subjectId) {
    selectedSubjectId.value = subjectId;
    pyqItems.clear();
    pdfUrl.value = null;
    final cat = selectedCategory.value;
    final yr = selectedYear.value;
    if (cat != null && yr != null) {
      fetchQuestions(cat, yr, subjectId);
    }
  }

  void resetTo(int step) {
    if (step <= 0) {
      selectedCategory.value = null;
      selectedYear.value = null;
      selectedSubjectId.value = null;
      subjects.clear();
      pyqItems.clear();
      pdfUrl.value = null;
      categories.clear();
      fetchCategories();
    } else if (step <= 1) {
      selectedYear.value = null;
      selectedSubjectId.value = null;
      pyqItems.clear();
      pdfUrl.value = null;
    } else if (step <= 2) {
      selectedSubjectId.value = null;
      pyqItems.clear();
      pdfUrl.value = null;
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
            if (c.isLoading.value && c.categories.isEmpty)
              _loadingIndicator()
            else if (c.selectedCategory.value == null)
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
              c.selectedCategory.value!,
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
              c.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value, orElse: () => AppSubject(id: c.selectedSubjectId.value!, name: 'Subject')).name,
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
        if (c.categories.isEmpty)
          _emptyState(Icons.assignment_outlined, 'No categories available', 'Check back later for new question categories')
        else
        ...c.categories.map((cat) {
          final catName = cat['name'] as String? ?? '';
          final catSubtitle = cat['subtitle'] as String? ?? '';
          final catYears = (cat['years'] as List?)?.cast<int>() ?? <int>[];
          return GestureDetector(
            onTap: () => c.selectCategory(catName),
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
                          catName,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          catSubtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: AppColor.textSecondary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${catYears.length} years available',
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
    final catName = c.selectedCategory.value!;
    final catData = c.categories.firstWhere((c2) => c2['name'] == catName, orElse: () => {'name': catName, 'years': <int>[]});
    final yearsList = (catData['years'] as List?)?.cast<int>() ?? <int>[];
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
                  catName,
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
          children: yearsList.map((y) {
            return GestureDetector(
              onTap: () => c.selectYear(y),
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
                      '${c.subjects.length} subjects',
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
    final catName = c.selectedCategory.value!;
    final yr = c.selectedYear.value!;
    final subjects = c.subjects;
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
                    '$catName $yr',
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
          return GestureDetector(
            onTap: () => c.selectSubject(s.id),
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
                          'Questions available',
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
    final sub = c.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value, orElse: () => AppSubject(id: c.selectedSubjectId.value ?? 0, name: 'Subject'));
    final catName = c.selectedCategory.value!;
    final yr = c.selectedYear.value!;
    final items = c.pyqItems;
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
                    '$catName $yr',
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
        ...items.map((item) => _pyqCard(item)),
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

  Widget _pyqCard(QAItem item) {
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

  Widget _loadingIndicator() {
    return ShimmerWidget.pageLoader(itemCount: 4, itemHeight: 120);
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
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
