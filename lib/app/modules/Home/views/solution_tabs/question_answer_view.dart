import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/config/appcolor.dart';
import '../../../../data/models/mock_data.dart';
import '../../../../data/widgets/decorative_background.dart';

class QuestionAnswerView extends StatelessWidget {
  const QuestionAnswerView({super.key});

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
                gradient: AppColor.primaryGradient,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.quiz_rounded, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 10.w),
            Text(
              'Question & Answers',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: const _QuestionAnswerBody(),
    );
  }
}

// ── Controller ──

class _QAController extends GetxController {
  final selectedClassId = Rx<int?>(null);
  final selectedSubjectId = Rx<int?>(null);
  final selectedChapterId = Rx<int?>(null);
  final selectedType = Rx<QuestionType?>(null);

  List<AppClass> get availableClasses {
    final ids =
        MockData.qaItems.map((e) => e.classId).toSet().whereType<int>();
    return MockData.allClasses.where((c) => ids.contains(c.id)).toList();
  }

  List<AppSubject> get availableSubjects {
    final classId = selectedClassId.value;
    if (classId == null) return [];
    final ids = MockData.qaItems
        .where((e) => e.classId == classId)
        .map((e) => e.subjectId)
        .toSet()
        .whereType<int>();
    return MockData.subjects.where((s) => ids.contains(s.id)).toList();
  }

  List<AppChapter> get availableChapters {
    final classId = selectedClassId.value;
    final subId = selectedSubjectId.value;
    if (classId == null || subId == null) return [];
    return MockData.chapters.where((c) {
      return MockData.qaItems.any(
        (q) => q.classId == classId && q.subjectId == subId && q.chapterId == c.id,
      );
    }).toList();
  }

  List<QuestionType> get availableTypes => QuestionType.values.toList();

  List<QAItem> get filteredQAItems {
    final classId = selectedClassId.value;
    final subId = selectedSubjectId.value;
    final chId = selectedChapterId.value;
    final type = selectedType.value;
    if (classId == null || subId == null || chId == null || type == null) return [];
    return MockData.qaItems.where((q) {
      return q.classId == classId && q.subjectId == subId && q.chapterId == chId && q.type == type;
    }).toList();
  }

  void resetTo(int step) {
    if (step <= 0) {
      selectedClassId.value = null;
      selectedSubjectId.value = null;
      selectedChapterId.value = null;
      selectedType.value = null;
    } else if (step <= 1) {
      selectedSubjectId.value = null;
      selectedChapterId.value = null;
      selectedType.value = null;
    } else if (step <= 2) {
      selectedChapterId.value = null;
      selectedType.value = null;
    } else if (step <= 3) {
      selectedType.value = null;
    }
  }

  static String typeLabel(QuestionType t) => switch (t) {
    QuestionType.veryShort => 'Very Short',
    QuestionType.explanatory => 'Explanatory',
    QuestionType.essay => 'Essay-Type',
  };

  static IconData typeIcon(QuestionType t) => switch (t) {
    QuestionType.veryShort => Icons.short_text_rounded,
    QuestionType.explanatory => Icons.description_rounded,
    QuestionType.essay => Icons.article_rounded,
  };

  static Color typeColor(QuestionType t) => switch (t) {
    QuestionType.veryShort => AppColor.buttonOneColor,
    QuestionType.explanatory => AppColor.buttonTwoColor,
    QuestionType.essay => AppColor.success,
  };

  static String typeDesc(QuestionType t) => switch (t) {
    QuestionType.veryShort => 'Brief one-line answers',
    QuestionType.explanatory => 'Detailed explanations',
    QuestionType.essay => 'Long-form descriptive answers',
  };
}

// ── Body ──

class _QuestionAnswerBody extends StatelessWidget {
  const _QuestionAnswerBody();

  @override
  Widget build(BuildContext context) {
    final c = Get.isRegistered<_QAController>()
        ? Get.find<_QAController>()
        : Get.put(_QAController());
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
              _subjectsGrid(c)
            else if (c.selectedChapterId.value == null)
              _chaptersList(c)
            else if (c.selectedType.value == null)
              _typeSelector(c)
            else
              _qaList(c),
          ],
        ),
      ),
    ));
  }

  // ── Breadcrumb ──

  Widget _breadcrumb(_QAController c) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        _chip('Class', c.selectedClassId.value == null, () => c.resetTo(0), AppColor.buttonOneColor),
        if (c.selectedClassId.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(
            MockData.allClasses.firstWhere((c2) => c2.id == c.selectedClassId.value).name,
            c.selectedSubjectId.value == null, () => c.resetTo(1), AppColor.buttonOneColor),
        ],
        if (c.selectedSubjectId.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(
            MockData.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value).name,
            c.selectedChapterId.value == null, () => c.resetTo(2), AppColor.buttonOneColor),
        ],
        if (c.selectedChapterId.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(
            MockData.chapters.firstWhere((ch) => ch.id == c.selectedChapterId.value).name,
            c.selectedType.value == null, () => c.resetTo(3), AppColor.buttonOneColor),
        ],
        if (c.selectedType.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(_QAController.typeLabel(c.selectedType.value!), true, null, AppColor.buttonOneColor),
        ],
      ]),
    );
  }

  Widget _chip(String label, bool active, VoidCallback? onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(label, style: GoogleFonts.poppins(
          fontSize: 11.sp,
          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          color: active ? color : AppColor.textSecondary,
        )),
      ),
    );
  }

  // ── Step 0 ──

  Widget _classesGrid(_QAController c) {
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

  Widget _classCard(AppClass cl, _QAController c) {
    final qty = MockData.qaItems.where((e) => e.classId == cl.id).length;
    final subCount = MockData.qaItems.where((e) => e.classId == cl.id).map((e) => e.subjectId).toSet().length;
    return GestureDetector(
      onTap: () => c.selectedClassId.value = cl.id,
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColor.buttonOneColor.withValues(alpha: 0.08), AppColor.cardColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [AppColor.softShadow],
          border: Border.all(color: AppColor.cardBorder),
        ),
        child: Column(children: [
          Container(width: 44.r, height: 44.r,
            decoration: BoxDecoration(gradient: AppColor.primaryGradient, borderRadius: BorderRadius.circular(12.r)),
            child: Center(child: Text(cl.grade, style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w700, color: Colors.white)))),
          SizedBox(height: 8.h),
          Text(cl.name, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
          SizedBox(height: 2.h),
          Text('$subCount subjects · $qty Q&A', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
        ]),
      ),
    );
  }

  // ── Step 1 ──

  Widget _subjectsGrid(_QAController c) {
    final subjects = c.availableSubjects;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(0), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Text('Choose a subject', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
      ]),
      SizedBox(height: 10.h),
      ...List.generate((subjects.length + 1) ~/ 2, (ri) {
        final start = ri * 2;
        final end = (start + 2).clamp(0, subjects.length);
        final row = subjects.sublist(start, end);
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(children: row.map((s) => Expanded(child: _subjectCard(s, c))).toList()),
        );
      }),
    ]);
  }

  Widget _subjectCard(AppSubject s, _QAController c) {
    final q = MockData.qaItems.where((e) => e.subjectId == s.id).length;
    return GestureDetector(
      onTap: () => c.selectedSubjectId.value = s.id,
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [AppColor.softShadow],
          border: Border.all(color: AppColor.cardBorder),
        ),
        child: Column(children: [
          Text(s.icon, style: TextStyle(fontSize: 28.sp)),
          SizedBox(height: 6.h),
          Text(s.name, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
          SizedBox(height: 2.h),
          Text('$q Q&A', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
        ]),
      ),
    );
  }

  // ── Step 2 ──

  Widget _chaptersList(_QAController c) {
    final chapters = c.availableChapters;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(1), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Text('Choose a chapter', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
      ]),
      SizedBox(height: 12.h),
      ...chapters.map((ch) {
        final q = MockData.qaItems.where((e) =>
            e.classId == c.selectedClassId.value &&
            e.subjectId == c.selectedSubjectId.value &&
            e.chapterId == ch.id).length;
        return GestureDetector(
          onTap: () => c.selectedChapterId.value = ch.id,
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [AppColor.softShadow],
              border: Border.all(color: AppColor.cardBorder),
            ),
            child: Row(children: [
              Container(padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(color: AppColor.buttonOneColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
                child: Icon(Icons.book_rounded, color: AppColor.buttonOneColor, size: 20.sp)),
              SizedBox(width: 12.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ch.name, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
                SizedBox(height: 2.h),
                Text('$q questions available', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
              ])),
              Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 20.sp),
            ]),
          ),
        );
      }),
    ]);
  }

  // ── Step 3 ──

  Widget _typeSelector(_QAController c) {
    final sub = MockData.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value);
    final ch = MockData.chapters.firstWhere((ch) => ch.id == c.selectedChapterId.value);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(2), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Choose question type', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
          Text('${sub.name} › ${ch.name}', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textLight)),
        ])),
      ]),
      SizedBox(height: 14.h),
      ...c.availableTypes.map((t) {
        final qc = MockData.qaItems.where((q) =>
            q.classId == c.selectedClassId.value &&
            q.subjectId == c.selectedSubjectId.value &&
            q.chapterId == c.selectedChapterId.value &&
            q.type == t).length;
        return GestureDetector(
          onTap: () => c.selectedType.value = t,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_QAController.typeColor(t).withValues(alpha: 0.05), Colors.white], begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: _QAController.typeColor(t).withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              Container(padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(color: _QAController.typeColor(t), borderRadius: BorderRadius.circular(12.r)),
                child: Icon(_QAController.typeIcon(t), color: Colors.white, size: 22.sp)),
              SizedBox(width: 14.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_QAController.typeLabel(t), style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: _QAController.typeColor(t))),
                SizedBox(height: 2.h),
                Text(_QAController.typeDesc(t), style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
              ])),
              Container(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: _QAController.typeColor(t).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
                child: Text('$qc Qs', style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w600, color: _QAController.typeColor(t)))),
              SizedBox(width: 4.w),
              Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 20.sp),
            ]),
          ),
        );
      }),
    ]);
  }

  // ── Step 4 ──

  Widget _qaList(_QAController c) {
    final sub = MockData.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value);
    final ch = MockData.chapters.firstWhere((ch) => ch.id == c.selectedChapterId.value);
    final items = c.filteredQAItems;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(3), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_QAController.typeLabel(c.selectedType.value!), style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: _QAController.typeColor(c.selectedType.value!))),
          Text('${sub.name} › ${ch.name}', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textLight)),
        ])),
        Container(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(color: AppColor.buttonOneColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
          child: Text('${items.length} items', style: GoogleFonts.poppins(fontSize: 10.sp, fontWeight: FontWeight.w500, color: AppColor.buttonOneColor))),
      ]),
      SizedBox(height: 14.h),
      ...items.map((item) => _qaCard(item)),
      if (items.isEmpty)
        Padding(padding: EdgeInsets.only(top: 20.h),
          child: Center(child: Column(children: [
            Icon(Icons.search_off_rounded, color: AppColor.textLight, size: 40.sp),
            SizedBox(height: 8.h),
            Text('No questions found for this selection.', style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColor.textSecondary)),
          ]))),
    ]);
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(color: _QAController.typeColor(item.type).withValues(alpha: 0.04), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: EdgeInsets.only(top: 2.h, right: 10.w),
              child: Icon(Icons.help_rounded, color: _QAController.typeColor(item.type), size: 18.sp)),
            Expanded(child: Text(item.question, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary, height: 1.4))),
            GestureDetector(
              onTap: () => _copyText(item.question, 'Question'),
              child: Container(padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(color: AppColor.buttonOneColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8.r)),
                child: Icon(Icons.copy_rounded, color: AppColor.buttonOneColor, size: 16.sp)),
            ),
          ]),
        ),
        Container(height: 1, color: AppColor.cardBorder),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: EdgeInsets.only(top: 2.h, right: 10.w),
              child: Icon(Icons.check_circle_rounded, color: AppColor.success, size: 18.sp)),
            Expanded(child: Text(item.answer, style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColor.textSecondary, height: 1.6))),
            GestureDetector(
              onTap: () => _copyText(item.answer, 'Answer'),
              child: Container(padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(color: AppColor.success.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8.r)),
                child: Icon(Icons.copy_rounded, color: AppColor.success, size: 16.sp)),
            ),
          ]),
        ),
      ]),
    );
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

  Widget _backBtn(VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8.r)),
        child: Icon(Icons.arrow_back_rounded, color: color, size: 16.sp),
      ),
    );
  }
}
