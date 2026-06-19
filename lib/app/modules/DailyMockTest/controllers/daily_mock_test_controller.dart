import 'package:get/get.dart';

import '../../../data/models/mock_data.dart';

class DailyMockTestController extends GetxController {
  final availableClasses = <String>['Class 9', 'Class 10', 'Class 11', 'Class 12'];

  var selectedClass = ''.obs;
  final selectedSubject = Rxn<AppSubject>();
  final selectedTest = Rxn<MockTestInfo>();

  // Filtered subjects based on selected class
  var subjects = <AppSubject>[].obs;

  // Test list for selected subject
  var testList = <MockTestInfo>[].obs;

  // Current step: 0 = class, 1 = subject, 2 = test list
  var currentStep = 0.obs;

  void selectClass(String className) {
    selectedClass.value = className;
    selectedSubject.value = null;
    selectedTest.value = null;
    // Filter subjects (all subjects for now, in production would filter by class)
    subjects.value = MockData.subjects;
    currentStep.value = 1;
  }

  void selectSubject(AppSubject subject) {
    selectedSubject.value = subject;
    selectedTest.value = null;
    // Load mock tests for this subject
    testList.value = MockData.dailyMockTests;
    currentStep.value = 2;
  }

  void selectTest(MockTestInfo test) {
    selectedTest.value = test;
    // Navigate to test screen
    Get.toNamed('/test-screen', arguments: {
      'test': test,
      'subject': selectedSubject.value,
      'className': selectedClass.value,
    });
  }

  void goBackToClass() {
    currentStep.value = 0;
    selectedClass.value = '';
    selectedSubject.value = null;
    selectedTest.value = null;
  }

  void goBackToSubject() {
    currentStep.value = 1;
    selectedSubject.value = null;
    selectedTest.value = null;
  }
}
