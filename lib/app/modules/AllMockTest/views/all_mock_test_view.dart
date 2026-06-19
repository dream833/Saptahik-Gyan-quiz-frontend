import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/appcolor.dart';
import '../../../data/models/mock_data.dart';
import '../../../data/widgets/decorative_background.dart';
import '../controllers/all_mock_test_controller.dart';

class AllMockTestView extends StatelessWidget {
  const AllMockTestView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AllMockTestController>();

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
              child: Icon(Icons.list_alt_rounded, color: Colors.white, size: 20.sp),
            ),
            SizedBox(width: 10.w),
            Text(
              'All Mock Tests',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: _AllMockTestBody(controller: controller),
    );
  }
}

// ── Body ──

class _AllMockTestBody extends StatelessWidget {
  final AllMockTestController controller;
  const _AllMockTestBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
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
            else
              _setsList(c),
          ],
        ),
      ),
    ));
  }

  // ── Breadcrumb ──

  Widget _breadcrumb(AllMockTestController c) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        _chip('Class', c.selectedClassId.value == null, () => c.resetTo(0), AppColor.buttonOneColor),
        if (c.selectedClassId.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(
            MockData.classList.firstWhere((c2) => c2.id == c.selectedClassId.value).name,
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
            false, null, AppColor.buttonOneColor),
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

  // ── Step 0: Class Selection ──

  Widget _classesGrid(AllMockTestController c) {
    final classes = c.availableClasses;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Choose your class', style: GoogleFonts.poppins(
        fontSize: 22.sp, fontWeight: FontWeight.w700, color: AppColor.textPrimary)),
      SizedBox(height: 6.h),
      Text('Select a class to view mock test sets', style: GoogleFonts.poppins(
        fontSize: 13.sp, color: AppColor.textSecondary)),
      SizedBox(height: 20.h),
      ...List.generate((classes.length + 1) ~/ 2, (ri) {
        final start = ri * 2;
        final end = (start + 2).clamp(0, classes.length);
        final row = classes.sublist(start, end);
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(children: row.map((cl) => Expanded(child: _classCard(cl, c))).toList()),
        );
      }),
    ]);
  }

  Widget _classCard(AppClass cl, AllMockTestController c) {
    final subCount = MockData.subjectIdsForClass(cl.id).length;
    final setCount = MockData.allMockTestSets.where((s) => s.classId == cl.id).length;
    final gradients = [
      const [Color(0xFFB96237), Color(0xFFD4845A)],
      const [Color(0xFF113650), Color(0xFF1A4F72)],
      const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
      const [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
    ];
    final gi = c.availableClasses.indexOf(cl) % gradients.length;
    final gradientColors = gradients[gi];

    return GestureDetector(
      onTap: () => c.selectClass(cl.id),
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(children: [
          Container(
            width: 48.r, height: 48.r,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: Center(
              child: Text(cl.grade, style: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
          SizedBox(height: 10.h),
          Text(cl.name, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white)),
          SizedBox(height: 2.h),
          Text('$subCount subjects · $setCount tests', style: GoogleFonts.poppins(fontSize: 10.sp, color: Colors.white70)),
        ]),
      ),
    );
  }

  // ── Step 1: Subject Selection ──

  Widget _subjectsGrid(AllMockTestController c) {
    final subjects = c.availableSubjects;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(0), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Text('Choose a subject', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
      ]),
      SizedBox(height: 12.h),
      ...List.generate((subjects.length + 1) ~/ 2, (ri) {
        final start = ri * 2;
        final end = (start + 2).clamp(0, subjects.length);
        final row = subjects.sublist(start, end);
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(children: row.map((s) => Expanded(child: _subjectCard(s, c))).toList()),
        );
      }),
    ]);
  }

  Widget _subjectCard(AppSubject s, AllMockTestController c) {
    final chCount = MockData.chapterIdsForClassSubject(c.selectedClassId.value!, s.id).length;
    final setCount = MockData.allMockTestSets.where((st) =>
        st.classId == c.selectedClassId.value && st.subjectId == s.id).length;
    final subjectColors = <Color>[
      const Color(0xFFB96237), const Color(0xFF113650), const Color(0xFF2E7D32),
      const Color(0xFF6A1B9A), const Color(0xFF1565C0), const Color(0xFFE65100),
    ];
    final color = subjectColors[s.id % subjectColors.length];
    final subjectIcons = <String, IconData>{
      'Bangla': Icons.menu_book_rounded, 'English': Icons.book_rounded,
      'Mathematics': Icons.calculate_rounded, 'Science': Icons.science_rounded,
      'History': Icons.history_edu_rounded, 'Geography': Icons.public_rounded,
    };

    return GestureDetector(
      onTap: () => c.selectSubject(s.id),
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [AppColor.cardShadow],
          border: Border.all(color: AppColor.cardBorder),
        ),
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14.r)),
            child: Icon(subjectIcons[s.name] ?? Icons.book_rounded, color: color, size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(s.name, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
          SizedBox(height: 2.h),
          Text('$chCount chapters · $setCount sets', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
        ]),
      ),
    );
  }

  // ── Step 2: Chapter Selection ──

  Widget _chaptersList(AllMockTestController c) {
    final chapters = c.availableChapters;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(1), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Text('Choose a chapter', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
      ]),
      SizedBox(height: 12.h),
      ...chapters.map((ch) {
        final setCount = MockData.setsFor(c.selectedClassId.value!, c.selectedSubjectId.value!, ch.id).length;
        return GestureDetector(
          onTap: () => c.selectChapter(ch.id),
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [AppColor.softShadow],
              border: Border.all(color: AppColor.cardBorder),
            ),
            child: Row(children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColor.buttonOneColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.book_rounded, color: AppColor.buttonOneColor, size: 22.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ch.name, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
                SizedBox(height: 2.h),
                Text('$setCount test sets available', style: GoogleFonts.poppins(fontSize: 11.sp, color: AppColor.textSecondary)),
              ])),
              Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 20.sp),
            ]),
          ),
        );
      }),
    ]);
  }

  // ── Step 3: Set Selection ──

  Widget _setsList(AllMockTestController c) {
    final sets = c.sets;
    final sub = MockData.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value);
    final ch = MockData.chapters.firstWhere((ch) => ch.id == c.selectedChapterId.value);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(2), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Choose a set', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
          Text('${sub.name} › ${ch.name}', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textLight)),
        ])),
      ]),
      SizedBox(height: 14.h),
      ...sets.map((set) {
        return GestureDetector(
          onTap: () => c.startSet(set),
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [AppColor.cardShadow],
              border: Border.all(color: AppColor.cardBorder),
            ),
            child: Row(children: [
              Container(
                width: 48.r, height: 48.r,
                decoration: BoxDecoration(gradient: AppColor.primaryGradient, shape: BoxShape.circle),
                child: Center(child: Text(
                  '${sets.indexOf(set) + 1}',
                  style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.white),
                )),
              ),
              SizedBox(width: 14.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(set.name, style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
                SizedBox(height: 4.h),
                Row(children: [
                  _setMeta(Icons.quiz_rounded, '${set.totalQuestions} Qs', AppColor.buttonOneColor),
                  SizedBox(width: 14.w),
                  _setMeta(Icons.timer_outlined, '${set.totalTime} min', AppColor.buttonTwoColor),
                ]),
              ])),
              Icon(Icons.play_circle_filled_rounded, color: AppColor.buttonOneColor, size: 32.sp),
            ]),
          ),
        );
      }),
      if (sets.isEmpty)
        Padding(padding: EdgeInsets.only(top: 20.h),
          child: Center(child: Column(children: [
            Icon(Icons.search_off_rounded, color: AppColor.textLight, size: 40.sp),
            SizedBox(height: 8.h),
            Text('No test sets available.', style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColor.textSecondary)),
          ]))),
    ]);
  }

  Widget _setMeta(IconData icon, String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13.sp, color: color),
      SizedBox(width: 4.w),
      Text(label, style: GoogleFonts.poppins(fontSize: 11.sp, fontWeight: FontWeight.w500, color: color)),
    ]);
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
