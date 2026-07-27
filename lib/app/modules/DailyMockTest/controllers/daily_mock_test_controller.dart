import 'dart:developer';

import 'package:get/get.dart';

import '../../../data/function/dio_post.dart';
import '../../../data/models/mock_data.dart';

class DailyMockTestController extends GetxController {
  var isLoading = false.obs;

  // Available classes from API
  var availableClasses = <AppClass>[].obs;

  var selectedClass = Rx<AppClass?>(null);
  var selectedSubject = Rx<AppSubject?>(null);
  var selectedTest = Rx<MockTestInfo?>(null);

  // Filtered subjects based on selected class
  var subjects = <AppSubject>[].obs;

  // Test list for selected subject
  var testList = <MockTestInfo>[].obs;

  // Current step: 0 = class, 1 = subject, 2 = test list
  var currentStep = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/daily-test/classes.php",
        data: {},
      );

      log("Daily Test Classes: ${response.data}");

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
      log("Fetch classes error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubjects(int classId) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/daily-test/subjects.php",
        data: {"class_id": classId},
      );

      log("Daily Test Subjects: ${response.data}");

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
      log("Fetch subjects error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTests(int classId, int subjectId) async {
    try {
      isLoading.value = true;

      final response = await dioPost(
        endUrl: "/daily-test/tests.php",
        data: {
          "class_id": classId,
          "subject_id": subjectId,
        },
      );

      log("Daily Tests: ${response.data}");

      if (response.data['data'] != null) {
        testList.value = (response.data['data'] as List).map((t) {
          return MockTestInfo(
            id: t['id'] ?? 0,
            name: t['name'] ?? '',
            description: t['description'] ?? '',
            totalQuestions: t['total_questions'] ?? 10,
            timeSeconds: t['time_seconds'] ?? 200,
          );
        }).toList();
      }
    } catch (e) {
      log("Fetch tests error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startTest(MockTestInfo test) async {
    try {
      isLoading.value = true;

      final classId = selectedClass.value?.id;
      final subjectId = selectedSubject.value?.id;

      if (classId == null || subjectId == null) return;

      final response = await dioPost(
        endUrl: "/daily-test/start.php",
        data: {
          "test_id": test.id,
          "class_id": classId,
          "subject_id": subjectId,
        },
      );

      log("Start Test Response: ${response.data}");

      if (response.data['data'] != null) {
        final data = response.data['data'];

        // Parse questions from API
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

        Get.toNamed('/test-screen', arguments: {
          'test': test,
          'subject': selectedSubject.value,
          'className': selectedClass.value?.name ?? '',
          'questions': questions,
          'testId': data['test_id'] ?? test.id,
          'timeSeconds': data['time_seconds'] ?? test.timeSeconds,
        });
      }
    } catch (e) {
      log("Start test error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectClass(AppClass cls) {
    selectedClass.value = cls;
    selectedSubject.value = null;
    selectedTest.value = null;
    subjects.clear();
    testList.clear();
    fetchSubjects(cls.id);
    currentStep.value = 1;
  }

  void selectSubject(AppSubject subject) {
    selectedSubject.value = subject;
    selectedTest.value = null;
    testList.clear();
    final classId = selectedClass.value?.id;
    if (classId != null) {
      fetchTests(classId, subject.id);
    }
    currentStep.value = 2;
  }

  void selectTest(MockTestInfo test) {
    selectedTest.value = test;
    startTest(test);
  }

  void goBackToClass() {
    currentStep.value = 0;
    selectedClass.value = null;
    selectedSubject.value = null;
    selectedTest.value = null;
    subjects.clear();
    testList.clear();
  }

  void goBackToSubject() {
    currentStep.value = 1;
    selectedSubject.value = null;
    selectedTest.value = null;
    testList.clear();
  }
}
