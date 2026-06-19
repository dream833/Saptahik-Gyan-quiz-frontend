import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/config/appcolor.dart';
import '../../../../data/models/mock_data.dart';
import '../../../../data/widgets/decorative_background.dart';

class SuggestionView extends StatelessWidget {
  const SuggestionView({super.key});

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
                gradient: AppColor.navyGradient,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.tips_and_updates_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Suggestions',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: const _SuggestionBody(),
    );
  }
}

// ── Controller ──

class _SuggestionController extends GetxController {
  final selectedClassId = Rx<int?>(null);
  final selectedSubjectId = Rx<int?>(null);
  final selectedSuggestion = Rx<SuggestionItem?>(null);

  List<AppClass> get availableClasses {
    final ids =
        MockData.suggestions.map((e) => e.classId).toSet().whereType<int>();
    return MockData.allClasses.where((c) => ids.contains(c.id)).toList();
  }

  List<AppSubject> get availableSubjects {
    final classId = selectedClassId.value;
    if (classId == null) return [];
    final ids = MockData.suggestions
        .where((e) => e.classId == classId)
        .map((e) => e.subjectId)
        .toSet()
        .whereType<int>();
    return MockData.subjects.where((s) => ids.contains(s.id)).toList();
  }

  List<SuggestionItem> get suggestionsForSubject {
    final classId = selectedClassId.value;
    final subId = selectedSubjectId.value;
    if (classId == null || subId == null) return [];
    return MockData.suggestions
        .where((s) => s.classId == classId && s.subjectId == subId)
        .toList();
  }

  void resetTo(int step) {
    if (step <= 0) {
      selectedClassId.value = null;
      selectedSubjectId.value = null;
      selectedSuggestion.value = null;
    } else if (step <= 1) {
      selectedSubjectId.value = null;
      selectedSuggestion.value = null;
    } else if (step <= 2) {
      selectedSuggestion.value = null;
    }
  }
}

// ── Body ──

class _SuggestionBody extends StatelessWidget {
  const _SuggestionBody();

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<_SuggestionController>()
        ? Get.find<_SuggestionController>()
        : Get.put(_SuggestionController());
    return Obx(() => DecorativeBackground(
      showBottomDecoration: true,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _breadcrumb(c),
            SizedBox(height: 16.h),
            if (c.selectedClassId.value == null)
              _classesGrid(c)
            else if (c.selectedSubjectId.value == null)
              _subjectsList(c)
            else if (c.selectedSuggestion.value == null)
              _suggestionsList(c)
            else
              _suggestionDetail(c),
          ],
        ),
      ),
    ));
  }

  // ── Breadcrumb ──

  Widget _breadcrumb(_SuggestionController c) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        _chip('Class', c.selectedClassId.value == null, () => c.resetTo(0)),
        if (c.selectedClassId.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(MockData.allClasses.firstWhere((cl) => cl.id == c.selectedClassId.value).name,
              c.selectedSubjectId.value == null, () => c.resetTo(1)),
        ],
        if (c.selectedSubjectId.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(MockData.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value).name,
              c.selectedSuggestion.value == null, () => c.resetTo(2)),
        ],
        if (c.selectedSuggestion.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(c.selectedSuggestion.value!.name, true, null),
        ],
      ]),
    );
  }

  Widget _chip(String label, bool active, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: active ? AppColor.buttonTwoColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(label, style: GoogleFonts.poppins(
          fontSize: 11.sp,
          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          color: active ? AppColor.buttonTwoColor : AppColor.textSecondary,
        )),
      ),
    );
  }

  // ── Step 0 ──

  Widget _classesGrid(_SuggestionController c) {
    final classes = c.availableClasses;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Choose your class', style: GoogleFonts.poppins(
          fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
      SizedBox(height: 10.h),
      ...List.generate((classes.length + 1) ~/ 2, (ri) {
        final start = ri * 2;
        final end = (start + 2).clamp(0, classes.length);
        final row = classes.sublist(start, end);
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(children: row.map((cl) => Expanded(child: _classCard(cl, c))).toList()),
        );
      }),
    ]);
  }

  Widget _classCard(AppClass cl, _SuggestionController c) {
    final subCount = MockData.suggestions.where((e) => e.classId == cl.id).map((e) => e.subjectId).toSet().length;
    final sugCount = MockData.suggestions.where((e) => e.classId == cl.id).length;
    return GestureDetector(
      onTap: () => c.selectedClassId.value = cl.id,
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColor.buttonTwoColor.withValues(alpha: 0.08), AppColor.cardColor],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [AppColor.softShadow],
          border: Border.all(color: AppColor.cardBorder),
        ),
        child: Column(children: [
          Container(width: 44.r, height: 44.r,
            decoration: BoxDecoration(gradient: AppColor.navyGradient, borderRadius: BorderRadius.circular(12.r)),
            child: Center(child: Text(cl.grade, style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white)))),
          SizedBox(height: 8.h),
          Text(cl.name, textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
          SizedBox(height: 2.h),
          Text('$subCount subjects · $sugCount suggestions',
              style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
        ]),
      ),
    );
  }

  // ── Step 1 ──

  Widget _subjectsList(_SuggestionController c) {
    final classObj = MockData.allClasses.firstWhere((cl) => cl.id == c.selectedClassId.value);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(0)),
        SizedBox(width: 10.w),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Choose a subject', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
          Text(classObj.name, style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textLight)),
        ]),
      ]),
      SizedBox(height: 14.h),
      ...c.availableSubjects.map((s) {
        final sugCount = MockData.suggestions.where((e) => e.classId == c.selectedClassId.value && e.subjectId == s.id).length;
        return GestureDetector(
          onTap: () => c.selectedSubjectId.value = s.id,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(color: AppColor.cardColor, borderRadius: BorderRadius.circular(16.r),
                boxShadow: [AppColor.softShadow], border: Border.all(color: AppColor.cardBorder)),
            child: Row(children: [
              Container(width: 48.r, height: 48.r,
                decoration: BoxDecoration(color: AppColor.buttonTwoColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14.r)),
                child: Center(child: Text(s.icon, style: TextStyle(fontSize: 22.sp)))),
              SizedBox(width: 14.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
                SizedBox(height: 2.h),
                Text('$sugCount suggestions available', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
              ])),
              Container(padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(color: AppColor.buttonTwoColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
                child: Icon(Icons.arrow_forward_rounded, color: AppColor.buttonTwoColor, size: 18.sp)),
            ]),
          ),
        );
      }),
    ]);
  }

  // ── Step 2 ──

  Widget _suggestionsList(_SuggestionController c) {
    final sub = MockData.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value);
    final items = c.suggestionsForSubject;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(1)),
        SizedBox(width: 10.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Suggestions', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
          Text(sub.name, style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textLight)),
        ])),
        Container(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(color: AppColor.buttonTwoColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
          child: Text('${items.length} items', style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w500, color: AppColor.buttonTwoColor))),
      ]),
      SizedBox(height: 14.h),
      ...items.map((item) {
        return GestureDetector(
          onTap: () => c.selectedSuggestion.value = item,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(color: AppColor.cardColor, borderRadius: BorderRadius.circular(16.r),
                boxShadow: [AppColor.softShadow], border: Border.all(color: AppColor.cardBorder)),
            child: Row(children: [
              Container(padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(color: AppColor.buttonTwoColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)),
                child: Icon(Icons.lightbulb_outline_rounded, color: AppColor.buttonTwoColor, size: 22.sp)),
              SizedBox(width: 14.w),
              Expanded(child: Text(item.name, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary))),
              Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 20.sp),
            ]),
          ),
        );
      }),
      if (items.isEmpty)
        Padding(padding: EdgeInsets.only(top: 20.h),
          child: Center(child: Column(children: [
            Icon(Icons.tips_and_updates_outlined, color: AppColor.textLight, size: 40.sp),
            SizedBox(height: 8.h),
            Text('No suggestions available for this subject.', style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColor.textSecondary)),
          ]))),
    ]);
  }

  // ── Step 3 ──

  Widget _suggestionDetail(_SuggestionController c) {
    final sub = MockData.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value);
    final item = c.selectedSuggestion.value!;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(2)),
        SizedBox(width: 10.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.name, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
          Text(sub.name, style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textLight)),
        ])),
      ]),
      SizedBox(height: 20.h),
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(color: AppColor.cardColor, borderRadius: BorderRadius.circular(20.r),
            boxShadow: [AppColor.cardShadow], border: Border.all(color: AppColor.cardBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(gradient: AppColor.navyGradient, borderRadius: BorderRadius.circular(18.r), boxShadow: [AppColor.buttonShadowNavy]),
            child: Icon(Icons.tips_and_updates_rounded, color: Colors.white, size: 32.sp))),
          SizedBox(height: 16.h),
          Center(child: Text(item.name, textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColor.textPrimary))),
          SizedBox(height: 6.h),
          Center(child: Container(padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(color: AppColor.buttonTwoColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
            child: Text(sub.name, style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w500, color: AppColor.buttonTwoColor)))),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(color: AppColor.backgroundColorLight, borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColor.cardBorder)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Text(item.content, style: GoogleFonts.poppins(fontSize: 13.sp, color: AppColor.textSecondary, height: 1.8))),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => _copyText(item.content, 'Suggestion'),
                child: Container(padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(color: AppColor.buttonTwoColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
                  child: Icon(Icons.copy_rounded, color: AppColor.buttonTwoColor, size: 18.sp)),
              ),
            ]),
          ),
        ]),
      ),
    ]);
  }

  void _copyText(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(Icons.check_rounded, color: Colors.white, size: 18.sp),
          SizedBox(width: 8.w),
          Text('$label copied!', style: GoogleFonts.poppins(fontSize: 12.sp)),
        ]),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
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
        decoration: BoxDecoration(color: AppColor.buttonTwoColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
        child: Icon(Icons.arrow_back_rounded, color: AppColor.buttonTwoColor, size: 16.sp),
      ),
    );
  }
}
