import 'dart:developer';

import 'package:get/get.dart';

import '../../../data/function/dio_post.dart';
import '../../../data/models/mock_data.dart';
import '../../TestScreen/bindings/test_screen_binding.dart';
import '../../TestScreen/views/test_screen_view.dart';

class AllMockTestController extends GetxController {
  var isLoading = false.obs;

  // Available data from API
  var availableClasses = <AppClass>[].obs;

  final selectedClassId = Rx<int?>(null);
  final selectedSubjectId = Rx<int?>(null);
  final selectedChapterId = Rx<int?>(null);

  var subjects = <AppSubject>[].obs;
  var chapters = <AppChapter>[].obs;
  var testSets = <MockTestSet>[].obs;

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
        endUrl: "/all-tests/classes.php",
        data: {},
      );

      log("All Test Classes: ${response.data}");

      if (response.data['data'] != null) {
        availableClasses.value = (response.data['data'] as List).map((c) {
          return AppClass(
            id: c['id'] ?? 0,
            name: 'Class ${c['name'] ?? c['id']}',
            grade: (c['name'] ?? c['id']).toString(),
          );
        }).toList();
      }
    } catch (e) {
      log("Fetch all test classes error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubjects(int classId) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/all-tests/subjects.php",
        data: {"class_id": classId},
      );

      log("All Test Subjects: ${response.data}");

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
      log("Fetch all test subjects error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChapters(int classId, int subjectId) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/all-tests/chapters.php",
        data: {
          "class_id": classId,
          "subject_id": subjectId,
        },
      );

      log("All Test Chapters: ${response.data}");

      if (response.data['data'] != null) {
        chapters.value = (response.data['data'] as List).map((ch) {
          return AppChapter(
            id: ch['id'] ?? 0,
            name: ch['name'] ?? '',
          );
        }).toList();
      }
    } catch (e) {
      log("Fetch chapters error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSets(int classId, int subjectId, int chapterId) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/all-tests/sets.php",
        data: {
          "class_id": classId,
          "subject_id": subjectId,
          "chapter_id": chapterId,
        },
      );

      log("Test Sets: ${response.data}");

      if (response.data['data'] != null) {
        // Store sets metadata
        testSets.value = (response.data['data'] as List).map((s) {
          return MockTestSet(
            id: s['id'] ?? 0,
            name: s['name'] ?? '',
            questions: [], // Questions fetched when starting
          );
        }).toList();
      }
    } catch (e) {
      log("Fetch sets error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startSet(MockTestSet set) async {
    try {
      isLoading.value = true;

      final classId = selectedClassId.value;
      final subId = selectedSubjectId.value;
      final chId = selectedChapterId.value;

      if (classId == null || subId == null || chId == null) return;

      final response = await dioPost(
        endUrl: "/all-tests/start-set.php",
        data: {
          "set_id": set.id,
          "class_id": classId,
          "subject_id": subId,
          "chapter_id": chId,
        },
      );

      log("Start Set Response: ${response.data}");

      if (response.data['data'] != null) {
        final data = response.data['data'];

        // Parse questions
        final List<Question> questions = [];
        if (data['questions'] != null) {
          for (final q in data['questions']) {
            questions.add(Question(
              id: q['id'] ?? 0,
              text: q['text'] ?? '',
              options: List<String>.from(q['options'] ?? []),
              correctIndex: q['correct_index'] ?? 0,
            ));
          }
        }

        final cls = availableClasses.firstWhere(
          (c) => c.id == classId,
          orElse: () => AppClass(id: classId, name: 'Class $classId', grade: '$classId'),
        );
        final sub = subjects.firstWhere(
          (s) => s.id == subId,
          orElse: () => AppSubject(id: subId, name: 'Subject'),
        );
        final ch = chapters.firstWhere(
          (c) => c.id == chId,
          orElse: () => AppChapter(id: chId, name: 'Chapter'),
        );

        final mockTestInfo = MockTestInfo(
          id: set.id,
          name: '${set.name} - ${ch.name}',
          description: '${sub.name} · ${cls.name}',
          totalQuestions: questions.length,
          timeSeconds: data['time_seconds'] ?? (questions.length * 120),
        );

        Get.to(
          () => const TestScreenView(),
          binding: TestScreenBinding(),
          arguments: {
            'test': mockTestInfo,
            'className': cls.name,
            'subject': sub,
            'questions': questions,
          },
        );
      }
    } catch (e) {
      log("Start set error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ── Selection Methods ──

  void resetTo(int step) {
    if (step <= 0) {
      selectedClassId.value = null;
      selectedSubjectId.value = null;
      selectedChapterId.value = null;
      subjects.clear();
      chapters.clear();
      testSets.clear();
    } else if (step <= 1) {
      selectedSubjectId.value = null;
      selectedChapterId.value = null;
      chapters.clear();
      testSets.clear();
    } else if (step <= 2) {
      selectedChapterId.value = null;
      testSets.clear();
    }
  }

  void selectClass(int classId) {
    selectedClassId.value = classId;
    selectedSubjectId.value = null;
    selectedChapterId.value = null;
    subjects.clear();
    chapters.clear();
    testSets.clear();
    fetchSubjects(classId);
  }

  void selectSubject(int subjectId) {
    selectedSubjectId.value = subjectId;
    selectedChapterId.value = null;
    chapters.clear();
    testSets.clear();
    final classId = selectedClassId.value;
    if (classId != null) {
      fetchChapters(classId, subjectId);
    }
  }

  void selectChapter(int chapterId) {
    selectedChapterId.value = chapterId;
    testSets.clear();
    final classId = selectedClassId.value;
    final subId = selectedSubjectId.value;
    if (classId != null && subId != null) {
      fetchSets(classId, subId, chapterId);
    }
  }
}
