/// 📦 Mock Data & Models for the entire app
/// All data structures used across screens
library;

// ───────────────────────────────────────────
//  ENUMS
// ───────────────────────────────────────────

enum QuestionType { veryShort, explanatory, essay }

enum SelectionCategory { madhyamik, classXI, higherSecondary }

// ───────────────────────────────────────────
//  MODELS
// ───────────────────────────────────────────

class AppSubject {
  final int id;
  final String name;
  final String icon;

  AppSubject({required this.id, required this.name, this.icon = '📚'});
}

class AppChapter {
  final int id;
  final String name;
  final List<String> subtopics;

  AppChapter({required this.id, required this.name, this.subtopics = const []});
}

class MockTestSet {
  final int id;
  final String name;
  final List<Question> questions;

  MockTestSet({required this.id, required this.name, required this.questions});

  int get totalQuestions => questions.length;
  int get totalTime => questions.length * 2;
}

class Question {
  final int id;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String type;
  String? selectedIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    this.type = 'MCQ',
    this.selectedIndex,
  });

  bool get isCorrect => selectedIndex == correctIndex.toString();

  static List<Question> generateSample() {
    return [
      Question(
        id: 1,
        text: "What is the capital of Bangladesh?",
        options: ["Dhaka", "Chittagong", "Khulna", "Rajshahi"],
        correctIndex: 0,
      ),
      Question(
        id: 2,
        text: "Which planet is known as the Red Planet?",
        options: ["Venus", "Mars", "Jupiter", "Saturn"],
        correctIndex: 1,
      ),
      Question(
        id: 3,
        text: "Who wrote 'The Iliad'?",
        options: ["Plato", "Aristotle", "Homer", "Socrates"],
        correctIndex: 2,
      ),
      Question(
        id: 4,
        text: "What is the chemical symbol for water?",
        options: ["H2O", "CO2", "NaCl", "O2"],
        correctIndex: 0,
      ),
      Question(
        id: 5,
        text: "Which is the largest ocean?",
        options: ["Atlantic", "Indian", "Arctic", "Pacific"],
        correctIndex: 3,
      ),
    ];
  }
}

class MockTestInfo {
  final int id;
  final String name;
  final String description;
  final int totalQuestions;
  final int timeSeconds;

  MockTestInfo({
    required this.id,
    required this.name,
    required this.description,
    this.totalQuestions = 10,
    this.timeSeconds = 200,
  });

  int get totalTime => timeSeconds ~/ 60;
  int get markPerQuestion => 2;
}

class SuggestionItem {
  final int id;
  final String name;
  final String content;

  SuggestionItem({required this.id, required this.name, required this.content});
}

class PreviousYearPaper {
  final int id;
  final int year;
  final List<AppSubject> subjects;
  final Map<int, List<Question>> questionsBySubject;

  PreviousYearPaper({
    required this.id,
    required this.year,
    required this.subjects,
    required this.questionsBySubject,
  });
}

class QAItem {
  final int id;
  final String question;
  final String answer;
  final QuestionType type;

  QAItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.type,
  });
}

class _ClassItem {
  final String name;
  final String grade;
  _ClassItem({required this.name, required this.grade});
}

class _CategoryItem {
  final String name;
  final String subtitle;
  final List<int> years;
  _CategoryItem({
    required this.name,
    required this.subtitle,
    required this.years,
  });
}

class PreviousTestRecord {
  final String name;
  final String date;
  final int totalQuestions;
  final int score;

  PreviousTestRecord({
    required this.name,
    required this.date,
    this.totalQuestions = 10,
    this.score = 0,
  });

  int get id => name.hashCode;
  String get description => name;
  int get timeSeconds => totalQuestions * 20;
  int get totalTime => totalQuestions * 2;
  int get markPerQuestion => 2;
}

// ───────────────────────────────────────────
//  MOCK DATA
// ───────────────────────────────────────────

class MockData {
  // 🔹 Classes
  static final classList = [
    _ClassItem(name: "Class 9", grade: "9"),
    _ClassItem(name: "Class 10", grade: "10"),
    _ClassItem(name: "Class 11", grade: "11"),
    _ClassItem(name: "Class 12", grade: "12"),
  ];
  static final allClasses = [
    _ClassItem(name: "Class 5", grade: "5"),
    _ClassItem(name: "Class 6", grade: "6"),
    _ClassItem(name: "Class 7", grade: "7"),
    _ClassItem(name: "Class 8", grade: "8"),
    _ClassItem(name: "Class 9", grade: "9"),
    _ClassItem(name: "Class 10", grade: "10"),
    _ClassItem(name: "Class 11", grade: "11"),
    _ClassItem(name: "Class 12", grade: "12"),
  ];

  // 🔹 Subjects
  static final subjects = [
    AppSubject(id: 1, name: "Bangla", icon: '📖'),
    AppSubject(id: 2, name: "English", icon: '📘'),
    AppSubject(id: 3, name: "Mathematics", icon: '🔢'),
    AppSubject(id: 4, name: "Science", icon: '🔬'),
    AppSubject(id: 5, name: "History", icon: '🏛️'),
    AppSubject(id: 6, name: "Geography", icon: '🌍'),
  ];

  // 🔹 Chapters
  static final chapters = List.generate(
    6,
    (i) => AppChapter(id: i + 1, name: "Chapter ${i + 1}"),
  );

  // 🔹 Mock Test Sets for All Mock Tests
  static final mockTestSets = List.generate(
    5,
    (i) => MockTestSet(
      id: i + 1,
      name: "Set-${i + 1}",
      questions: generateQuestions(),
    ),
  );

  // 🔹 Mock Test Info list for Daily Mock Test
  static final dailyMockTests = [
    MockTestInfo(
      id: 1,
      name: "Daily Quiz 1",
      description: "Basic concepts from today's lessons",
    ),
    MockTestInfo(
      id: 2,
      name: "Daily Quiz 2",
      description: "Mixed questions from weekly syllabus",
    ),
    MockTestInfo(
      id: 3,
      name: "Daily Quiz 3",
      description: "Advanced problem solving",
    ),
  ];

  // 🔹 Suggestion items
  static final suggestions = [
    SuggestionItem(
      id: 1,
      name: "Board Question Pattern",
      content:
          "Focus on creative questions. For Bangla, practice paragraph writing and grammar. For English, reading comprehension is key.",
    ),
    SuggestionItem(
      id: 2,
      name: "Chapter-wise Important Topics",
      content:
          "Chapter 1: Focus on definitions and basic concepts.\nChapter 2: Practice numerical problems.\nChapter 3: Diagrams and explanations are important.",
    ),
    SuggestionItem(
      id: 3,
      name: "Exam Preparation Tips",
      content:
          "1. Revise daily\n2. Practice previous year questions\n3. Focus on weak areas\n4. Take mock tests regularly\n5. Get enough sleep before exam",
    ),
    SuggestionItem(
      id: 4,
      name: "Common Mistakes to Avoid",
      content:
          "• Not reading questions carefully\n• Poor time management\n• Ignoring diagrams\n• Not revising answers",
    ),
  ];

  // 🔹 Previous Year Categories
  static final previousYearCategories = [
    _CategoryItem(
      name: "Madhyamik",
      subtitle: "Class 10 board exam",
      years: [2020, 2021, 2022, 2023, 2024],
    ),
    _CategoryItem(
      name: "Class XI",
      subtitle: "Higher secondary 1st year",
      years: [2021, 2022, 2023, 2024],
    ),
    _CategoryItem(
      name: "Higher Secondary",
      subtitle: "Class 12 board exam",
      years: [2019, 2020, 2021, 2022, 2023, 2024],
    ),
  ];

  // 🔹 QA Items
  static final qaItems = [
    QAItem(
      id: 1,
      question: "What is photosynthesis?",
      answer:
          "Photosynthesis is the process by which green plants convert sunlight into chemical energy.",
      type: QuestionType.veryShort,
    ),
    QAItem(
      id: 2,
      question: "Explain the water cycle.",
      answer:
          "The water cycle involves evaporation, condensation, precipitation, and collection of water in nature.",
      type: QuestionType.explanatory,
    ),
    QAItem(
      id: 3,
      question: "Describe the causes and effects of World War II.",
      answer:
          "World War II was caused by multiple factors including the Treaty of Versailles, rise of fascism, and economic depression. It led to massive global changes.",
      type: QuestionType.essay,
    ),
    QAItem(
      id: 4,
      question: "What is Newton's First Law of Motion?",
      answer:
          "An object at rest stays at rest unless acted upon by an external force.",
      type: QuestionType.veryShort,
    ),
    QAItem(
      id: 5,
      question: "Explain biodiversity and its importance.",
      answer:
          "Biodiversity refers to the variety of life on Earth. It is crucial for ecosystem stability and human survival.",
      type: QuestionType.explanatory,
    ),
    QAItem(
      id: 6,
      question: "Write an essay on climate change.",
      answer:
          "Climate change is a pressing global issue caused by greenhouse gas emissions. It affects weather patterns, sea levels, and biodiversity. Solutions include renewable energy and conservation.",
      type: QuestionType.essay,
    ),
  ];

  // 🔹 Previous test records with date & score
  static final previousTestRecords = [
    PreviousTestRecord(
      name: "Daily Quiz 1",
      date: "12 Jun 2026",
      totalQuestions: 10,
      score: 80,
    ),
    PreviousTestRecord(
      name: "Daily Quiz 2",
      date: "11 Jun 2026",
      totalQuestions: 10,
      score: 70,
    ),
    PreviousTestRecord(
      name: "Set-1 Test",
      date: "10 Jun 2026",
      totalQuestions: 10,
      score: 90,
    ),
  ];

  // 🔹 Generate sample questions for a mock test
  static List<Question> generateQuestions() {
    return [
      Question(
        id: 1,
        text: "What is the capital of Bangladesh?",
        options: ["Dhaka", "Chittagong", "Khulna", "Rajshahi"],
        correctIndex: 0,
      ),
      Question(
        id: 2,
        text: "Which planet is known as the Red Planet?",
        options: ["Venus", "Mars", "Jupiter", "Saturn"],
        correctIndex: 1,
      ),
      Question(
        id: 3,
        text: "Who wrote 'The Iliad'?",
        options: ["Plato", "Aristotle", "Homer", "Socrates"],
        correctIndex: 2,
      ),
      Question(
        id: 4,
        text: "What is the chemical symbol for water?",
        options: ["H2O", "CO2", "NaCl", "O2"],
        correctIndex: 0,
      ),
      Question(
        id: 5,
        text: "Which is the largest ocean?",
        options: ["Atlantic", "Indian", "Arctic", "Pacific"],
        correctIndex: 3,
      ),
      Question(
        id: 6,
        text: "What is the square root of 144?",
        options: ["10", "11", "12", "13"],
        correctIndex: 2,
      ),
      Question(
        id: 7,
        text: "Which gas do plants absorb during photosynthesis?",
        options: ["Oxygen", "Nitrogen", "Carbon Dioxide", "Hydrogen"],
        correctIndex: 2,
      ),
      Question(
        id: 8,
        text: "Who painted the Mona Lisa?",
        options: ["Michelangelo", "Leonardo da Vinci", "Raphael", "Donatello"],
        correctIndex: 1,
      ),
      Question(
        id: 9,
        text: "What is the speed of light?",
        options: ["3 × 10⁶ m/s", "3 × 10⁸ m/s", "3 × 10¹⁰ m/s", "3 × 10¹² m/s"],
        correctIndex: 1,
      ),
      Question(
        id: 10,
        text: "Which country has the largest population?",
        options: ["USA", "India", "China", "Indonesia"],
        correctIndex: 1,
      ),
    ];
  }
}
