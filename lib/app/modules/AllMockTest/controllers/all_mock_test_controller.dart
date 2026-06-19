import 'package:get/get.dart';

import '../../../data/models/mock_data.dart';
import '../../TestScreen/bindings/test_screen_binding.dart';
import '../../TestScreen/views/test_screen_view.dart';

class AllMockTestController extends GetxController {
  final selectedClassId = Rx<int?>(null);
  final selectedSubjectId = Rx<int?>(null);
  final selectedChapterId = Rx<int?>(null);

  List<AppClass> get availableClasses {
    final ids = MockData.mockTestClassIds;
    return MockData.classList.where((c) => ids.contains(c.id)).toList();
  }

  List<AppSubject> get availableSubjects {
    final classId = selectedClassId.value;
    if (classId == null) return [];
    return MockData.subjectIdsForClass(classId)
        .map((id) => MockData.subjects.firstWhere((s) => s.id == id))
        .toList();
  }

  List<AppChapter> get availableChapters {
    final classId = selectedClassId.value;
    final subId = selectedSubjectId.value;
    if (classId == null || subId == null) return [];
    return MockData.chapterIdsForClassSubject(classId, subId)
        .map((id) => MockData.chapters.firstWhere((c) => c.id == id))
        .toList();
  }

  List<MockTestSet> get sets {
    final classId = selectedClassId.value;
    final subId = selectedSubjectId.value;
    final chId = selectedChapterId.value;
    if (classId == null || subId == null || chId == null) return [];
    return MockData.setsFor(classId, subId, chId);
  }

  void resetTo(int step) {
    if (step <= 0) {
      selectedClassId.value = null;
      selectedSubjectId.value = null;
      selectedChapterId.value = null;
    } else if (step <= 1) {
      selectedSubjectId.value = null;
      selectedChapterId.value = null;
    } else if (step <= 2) {
      selectedChapterId.value = null;
    }
  }

  void selectClass(int classId) => selectedClassId.value = classId;
  void selectSubject(int subjectId) => selectedSubjectId.value = subjectId;
  void selectChapter(int chapterId) => selectedChapterId.value = chapterId;

  void startSet(MockTestSet set) {
    final classId = selectedClassId.value!;
    final subId = selectedSubjectId.value!;
    final cls = MockData.classList.firstWhere((c) => c.id == classId);
    final sub = MockData.subjects.firstWhere((s) => s.id == subId);
    final ch = availableChapters.firstWhere((c) => c.id == selectedChapterId.value!);
    final mockTestInfo = MockTestInfo(
      id: set.id,
      name: '${set.name} - ${ch.name}',
      description: '${sub.name} · ${cls.name}',
      totalQuestions: set.totalQuestions,
      timeSeconds: set.totalTime * 60,
    );

    Get.to(
      () => const TestScreenView(),
      binding: TestScreenBinding(),
      arguments: {
        'test': mockTestInfo,
        'className': cls.name,
        'subject': sub,
        'questions': set.questions,
      },
    );
  }
}
