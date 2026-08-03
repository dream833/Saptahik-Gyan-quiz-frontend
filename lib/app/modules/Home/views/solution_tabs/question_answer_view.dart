import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:developer';

import '../../../../data/config/appcolor.dart';
import '../../../../data/function/dio_post.dart';
import '../../../../data/widgets/shimmer_widget.dart';
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
  final selectedType = Rx<String?>(null);

  var isLoading = false.obs;

  // API data
  var classes = <AppClass>[].obs;
  var subjects = <AppSubject>[].obs;
  var chapters = <AppChapter>[].obs;
  var qaItemList = <QAItem>[].obs;

  // Question types from API
  var questionTypes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  // ── API Calls ──

  Future<void> fetchClasses() async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/qa/classes.php",
        data: {},
      );

      if (response.data['data'] != null) {
        classes.value = (response.data['data'] as List).map((c) {
          return AppClass(
            id: c['id'] ?? 0,
            name: 'Class ${c['name'] ?? c['id']}',
            grade: (c['name'] ?? c['id']).toString(),
          );
        }).toList();
      }
    } catch (e) {
      log("QA fetch classes error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubjects(int classId) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/qa/subjects.php",
        data: {"class_id": classId},
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
      log("QA fetch subjects error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChapters(int classId, int subjectId) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/qa/chapters.php",
        data: {
          "class_id": classId,
          "subject_id": subjectId,
        },
      );

      if (response.data['data'] != null) {
        chapters.value = (response.data['data'] as List).map((ch) {
          return AppChapter(
            id: ch['id'] ?? 0,
            name: ch['name'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      log("QA fetch chapters error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTypes() async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/qa/types.php",
        data: {},
      );

      if (response.data['data'] != null) {
        questionTypes.value = (response.data['data'] as List).map((t) {
          return <String, dynamic>{
            'type': t['type'] ?? '',
            'label': t['label'] ?? '',
            'description': t['description'] ?? '',
          };
        }).toList();
      }
    } catch (e) {
      log("QA fetch types error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchItems(int classId, int subjectId, int chapterId, String type) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/qa/items.php",
        data: {
          "class_id": classId,
          "subject_id": subjectId,
          "chapter_id": chapterId,
          "type": type,
        },
      );

      if (response.data['data'] != null) {
        qaItemList.value = (response.data['data'] as List).map((item) {
          return QAItem(
            id: item['id'] ?? 0,
            question: item['question'] ?? '',
            answer: item['answer'] ?? '',
            type: QuestionType.values.firstWhere(
              (t) => t.name == item['type'],
              orElse: () => QuestionType.veryShort,
            ),
            subjectId: item['subject_id'],
            chapterId: item['chapter_id'],
            classId: item['class_id'],
          );
        }).toList();
      }
    } catch (e) {
      log("QA fetch items error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Selection methods with API fetch
  void selectClass(int classId) {
    selectedClassId.value = classId;
    selectedSubjectId.value = null;
    selectedChapterId.value = null;
    selectedType.value = null;
    subjects.clear();
    chapters.clear();
    qaItemList.clear();
    fetchSubjects(classId);
  }

  void selectSubject(int subjectId) {
    selectedSubjectId.value = subjectId;
    selectedChapterId.value = null;
    selectedType.value = null;
    chapters.clear();
    qaItemList.clear();
    final classId = selectedClassId.value;
    if (classId != null) {
      fetchChapters(classId, subjectId);
    }
  }

  void selectChapter(int chapterId) {
    selectedChapterId.value = chapterId;
    selectedType.value = null;
    qaItemList.clear();
    fetchTypes();
  }

  void selectType(String type) {
    selectedType.value = type;
    qaItemList.clear();
    final classId = selectedClassId.value;
    final subId = selectedSubjectId.value;
    final chId = selectedChapterId.value;
    if (classId != null && subId != null && chId != null) {
      fetchItems(classId, subId, chId, type);
    }
  }

  void resetTo(int step) {
    if (step <= 0) {
      selectedClassId.value = null;
      selectedSubjectId.value = null;
      selectedChapterId.value = null;
      selectedType.value = null;
      subjects.clear();
      chapters.clear();
      qaItemList.clear();
      questionTypes.clear();
    } else if (step <= 1) {
      selectedSubjectId.value = null;
      selectedChapterId.value = null;
      selectedType.value = null;
      chapters.clear();
      qaItemList.clear();
      questionTypes.clear();
    } else if (step <= 2) {
      selectedChapterId.value = null;
      selectedType.value = null;
      qaItemList.clear();
      questionTypes.clear();
    } else if (step <= 3) {
      selectedType.value = null;
      qaItemList.clear();
    }
  }


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
            if (c.isLoading.value)
              _loadingIndicator()
            else if (c.selectedClassId.value == null)
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
            c.classes.firstWhere((c2) => c2.id == c.selectedClassId.value, orElse: () => AppClass(id: c.selectedClassId.value!, name: 'Class ${c.selectedClassId.value}', grade: '${c.selectedClassId.value}')).name,
            c.selectedSubjectId.value == null, () => c.resetTo(1), AppColor.buttonOneColor),
        ],
        if (c.selectedSubjectId.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(
            c.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value, orElse: () => AppSubject(id: c.selectedSubjectId.value!, name: 'Subject')).name,
            c.selectedChapterId.value == null, () => c.resetTo(2), AppColor.buttonOneColor),
        ],
        if (c.selectedChapterId.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(
            c.chapters.firstWhere((ch) => ch.id == c.selectedChapterId.value, orElse: () => AppChapter(id: c.selectedChapterId.value!, name: 'Chapter ${c.selectedChapterId.value}')).name,
            c.selectedType.value == null, () => c.resetTo(3), AppColor.buttonOneColor),
        ],
        if (c.selectedType.value != null) ...[
          Icon(Icons.chevron_right_rounded, color: AppColor.textLight, size: 16.sp),
          _chip(c.selectedType.value!, true, null, AppColor.buttonOneColor),
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
    final classes = c.classes;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Choose your class', style: GoogleFonts.poppins(
        fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
      SizedBox(height: 10.h),
      if (classes.isEmpty)
        _emptyState(Icons.school_outlined, 'No classes available', 'Check back later for new classes')
      else
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
    return GestureDetector(
      onTap: () => c.selectClass(cl.id),
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
          Text('Subjects', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
        ]),
      ),
    );
  }

  // ── Step 1 ──

  Widget _subjectsGrid(_QAController c) {
    final subjects = c.subjects;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(0), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Text('Choose a subject', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
      ]),
      SizedBox(height: 10.h),
      if (subjects.isEmpty)
        _emptyState(Icons.book_outlined, 'No subjects available', 'No subjects found for this class')
      else
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
    return GestureDetector(
      onTap: () => c.selectSubject(s.id),
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
          Text(' ', style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
        ]),
      ),
    );
  }

  // ── Step 2 ──

  Widget _chaptersList(_QAController c) {
    final chapters = c.chapters;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(1), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Text('Choose a chapter', style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColor.textSecondary)),
      ]),
      SizedBox(height: 12.h),
      if (chapters.isEmpty)
        _emptyState(Icons.menu_book_outlined, 'No chapters available', 'No chapters found for this subject')
      else
        ...chapters.map((ch) {
          return GestureDetector(
            onTap: () => c.selectChapter(ch.id),
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [AppColor.softShadow],
                border: Border.all(color: AppColor.cardBorder),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Centered chapter name
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 44.w),
                      child: Text(
                        ch.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  // Left book icon
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColor.buttonOneColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.book_rounded,
                        color: AppColor.buttonOneColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  // Right chevron
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: AppColor.textLight,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
    ]);
  }

  // ── Step 3 ──

  Widget _typeSelector(_QAController c) {
    final sub = c.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value, orElse: () => AppSubject(id: c.selectedSubjectId.value ?? 0, name: 'Subject'));
    final ch = c.chapters.firstWhere((ch) => ch.id == c.selectedChapterId.value, orElse: () => AppChapter(id: c.selectedChapterId.value ?? 0, name: 'Chapter'));
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
      ...c.questionTypes.map((t) {
        final typeVal = t['type'] ?? '';
        final label = t['label'] ?? typeVal;
        final desc = t['description'] ?? '';
        return GestureDetector(
          onTap: () => c.selectType(typeVal),
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColor.buttonOneColor.withValues(alpha: 0.05), Colors.white], begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColor.buttonOneColor.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              Container(padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(color: AppColor.buttonOneColor, borderRadius: BorderRadius.circular(12.r)),
                child: Icon(Icons.short_text_rounded, color: Colors.white, size: 22.sp)),
              SizedBox(width: 14.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.buttonOneColor)),
                SizedBox(height: 2.h),
                Text(desc, style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColor.textSecondary)),
              ])),
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
    final sub = c.subjects.firstWhere((s) => s.id == c.selectedSubjectId.value, orElse: () => AppSubject(id: c.selectedSubjectId.value ?? 0, name: 'Subject'));
    final ch = c.chapters.firstWhere((ch) => ch.id == c.selectedChapterId.value, orElse: () => AppChapter(id: c.selectedChapterId.value ?? 0, name: 'Chapter'));
    final items = c.qaItemList;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backBtn(() => c.resetTo(3), AppColor.buttonOneColor),
        SizedBox(width: 10.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(c.selectedType.value!, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColor.buttonOneColor)),
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
          decoration: BoxDecoration(color: AppColor.buttonOneColor.withValues(alpha: 0.04), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: EdgeInsets.only(top: 2.h, right: 10.w),
              child: Icon(Icons.help_rounded, color: AppColor.buttonOneColor, size: 18.sp)),
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
