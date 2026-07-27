/// 📦 Mock Data & Models for the entire app
/// All data structures used across screens
library;

// ───────────────────────────────────────────
//  ENUMS
// ───────────────────────────────────────────

enum QuestionType { veryShort, explanatory, essay }

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
  final int? classId;
  final int? subjectId;
  final int? chapterId;

  MockTestSet({
    required this.id,
    required this.name,
    required this.questions,
    this.classId,
    this.subjectId,
    this.chapterId,
  });

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
  final int? subjectId;
  final int? classId;

  SuggestionItem({
    required this.id,
    required this.name,
    required this.content,
    this.subjectId,
    this.classId,
  });
}

class QAItem {
  final int id;
  final String question;
  final String answer;
  final QuestionType type;
  final int? subjectId;
  final int? chapterId;
  final int? classId;

  QAItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.type,
    this.subjectId,
    this.chapterId,
    this.classId,
  });
}

class AppClass {
  final int id;
  final String name;
  final String grade;
  const AppClass({required this.id, required this.name, required this.grade});
}

class PreviousYearCategory {
  final String name;
  final String subtitle;
  final List<int> years;
  final Map<int, List<AppSubject>> subjectsByYear;
  final Map<String, List<QAItem>> questionsBySubject;

  PreviousYearCategory({
    required this.name,
    required this.subtitle,
    required this.years,
    required this.subjectsByYear,
    required this.questionsBySubject,
  });

  List<AppSubject> subjectsForYear(int year) => subjectsByYear[year] ?? [];

  List<QAItem> questionsForSubject(int year, int subjectId) {
    final key = '$year-$subjectId';
    return questionsBySubject[key] ?? [];
  }
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
  // 🔹 Subjects (used by PYQ helpers)
  static final subjects = [
    AppSubject(id: 1, name: "Bangla", icon: '📖'),
    AppSubject(id: 2, name: "English", icon: '📘'),
    AppSubject(id: 3, name: "Mathematics", icon: '🔢'),
    AppSubject(id: 4, name: "Science", icon: '🔬'),
    AppSubject(id: 5, name: "History", icon: '🏛️'),
    AppSubject(id: 6, name: "Geography", icon: '🌍'),
  ];

  // 🔹 Suggestion items (organized by class & subject)
  static final suggestions = <SuggestionItem>[
    // ── Class 9 Suggestions ──
    // Bangla (subjectId: 1)
    SuggestionItem(
      id: 1,
      name: "Bangla Grammar Tips",
      content:
          "Focus on Sandhi, Samas, and Karaka for Class 9. Practice identifying these in prose passages. For creative writing, use simple sentence structures first, then gradually incorporate complex forms.",
      subjectId: 1,
      classId: 9,
    ),
    SuggestionItem(
      id: 2,
      name: "Bangla Prose Analysis",
      content:
          "When analyzing Bangla prose for Class 9: 1) Identify the main theme 2) Note the author's style 3) Look for symbolism 4) Understand the historical context 5) Practice writing summaries in your own words.",
      subjectId: 1,
      classId: 9,
    ),
    // English (subjectId: 2)
    SuggestionItem(
      id: 3,
      name: "English Grammar Guide",
      content:
          "Key Class 9 English grammar topics: Tenses (all 12 forms), Active/Passive voice, Direct/Indirect speech, Prepositions, and Subject-Verb agreement. Practice daily with 5 sentences each.",
      subjectId: 2,
      classId: 9,
    ),
    SuggestionItem(
      id: 4,
      name: "Reading Comprehension Strategy",
      content:
          "For Class 9 reading comprehension: 1) Skim the passage first 2) Read questions carefully 3) Scan for keywords 4) Use context clues for vocabulary 5) Eliminate wrong answers in multiple choice.",
      subjectId: 2,
      classId: 9,
    ),
    // Mathematics (subjectId: 3)
    SuggestionItem(
      id: 5,
      name: "Math Problem Solving",
      content:
          "Class 9 Mathematics: Master Algebra, Geometry, and Trigonometry basics. Practice 10 problems daily. Focus on understanding concepts rather than memorizing formulas. Draw diagrams for geometry.",
      subjectId: 3,
      classId: 9,
    ),
    SuggestionItem(
      id: 6,
      name: "Important Math Formulas",
      content:
          "Key Class 9 formulas: (a+b)² = a²+2ab+b², (a-b)² = a²-2ab+b², a²-b² = (a+b)(a-b). Pythagoras theorem, area of circles, volume of cylinders. Create a formula sheet for quick revision.",
      subjectId: 3,
      classId: 9,
    ),
    // Science (subjectId: 4)
    SuggestionItem(
      id: 7,
      name: "Science Practical Tips",
      content:
          "For Class 9 Science practicals: 1) Understand the experiment objective 2) Note apparatus correctly 3) Record observations accurately 4) Draw labeled diagrams 5) Write conclusions based on data. Safety first!",
      subjectId: 4,
      classId: 9,
    ),
    SuggestionItem(
      id: 8,
      name: "Physics Numericals",
      content:
          "Class 9 Physics: Focus on Motion, Force, and Gravitation chapters. Write given data first, identify formula, substitute values carefully, and check units. Practice 3-5 numericals daily.",
      subjectId: 4,
      classId: 9,
    ),

    // ── Class 10 Suggestions ──
    // Bangla (subjectId: 1)
    SuggestionItem(
      id: 9,
      name: "Bangla Board Exam Prep",
      content:
          "For Class 10 Bangla board exam: 1) Focus on prescribed poems and stories 2) Practice paragraph writing on current topics 3) Master grammar rules 4) Solve previous years' question papers 5) Time management is crucial.",
      subjectId: 1,
      classId: 10,
    ),
    SuggestionItem(
      id: 10,
      name: "Creative Writing for Bangla",
      content:
          "Class 10 Bangla creative writing: Start with an outline, use vivid descriptions, include dialogues where appropriate, maintain paragraph unity, and end with a strong conclusion. Practice 1 essay weekly.",
      subjectId: 1,
      classId: 10,
    ),
    // English (subjectId: 2)
    SuggestionItem(
      id: 11,
      name: "English Board Exam Strategy",
      content:
          "Class 10 English board exam: 1) Read unseen passages first 2) Answer writing skills questions 3) Practice letter/email formats 4) Learn diary entry and article writing 5) Review grammar rules regularly.",
      subjectId: 2,
      classId: 10,
    ),
    SuggestionItem(
      id: 12,
      name: "English Literature Guide",
      content:
          "For Class 10 English literature: Understand the central theme of each poem/story. Note key characters and their roles. Practice quoting relevant lines to support your answers. Connect texts to real life.",
      subjectId: 2,
      classId: 10,
    ),
    // Mathematics (subjectId: 3)
    SuggestionItem(
      id: 13,
      name: "Math Board Exam Tips",
      content:
          "Class 10 Math board exam: 1) Solve NCERT examples thoroughly 2) Practice 10-15 problems daily 3) Focus on high-weightage chapters 4) Write all steps clearly 5) Manage time - attempt easy questions first.",
      subjectId: 3,
      classId: 10,
    ),
    SuggestionItem(
      id: 14,
      name: "Advanced Math Concepts",
      content:
          "Class 10 Math: Focus on Quadratic Equations, Arithmetic Progressions, Coordinate Geometry, Trigonometry, and Statistics. Understand derivations, not just formulas. Group study helps solve tricky problems.",
      subjectId: 3,
      classId: 10,
    ),
    // Science (subjectId: 4)
    SuggestionItem(
      id: 15,
      name: "Science Board Exam Prep",
      content:
          "Class 10 Science: 1) Chemical reactions and equations 2) Life processes in biology 3) Light and electricity in physics 4) Practice diagrams and labeling 5) Write balanced chemical equations correctly.",
      subjectId: 4,
      classId: 10,
    ),
    SuggestionItem(
      id: 16,
      name: "Biology Diagrams Guide",
      content:
          "For Class 10 Biology: Practice drawing and labeling these diagrams - Human digestive system, Respiratory system, Heart, Neuron, Nephron, Plant cell, Animal cell. Use pencil and keep diagrams clean.",
      subjectId: 4,
      classId: 10,
    ),
    // History (subjectId: 5)
    SuggestionItem(
      id: 17,
      name: "History Study Technique",
      content:
          "Class 10 History: Create timeline charts for each chapter. Connect events with causes and effects. Remember dates using mnemonics. Focus on Nationalism, World Wars, and Indian independence movement.",
      subjectId: 5,
      classId: 10,
    ),
    SuggestionItem(
      id: 18,
      name: "History Answer Writing",
      content:
          "For Class 10 History exams: 1) Start with context 2) Mention key dates and events 3) Explain causes and consequences 4) Include relevant names 5) End with significance. Use point format for clarity.",
      subjectId: 5,
      classId: 10,
    ),
    // Geography (subjectId: 6)
    SuggestionItem(
      id: 19,
      name: "Geography Map Practice",
      content:
          "Class 10 Geography: Practice locating on map - Rivers, Mountains, Dams, Cities, Ports, and Minerals. Draw and label diagrams of Landforms, Water cycle, and Climate zones. Use different colors for clarity.",
      subjectId: 6,
      classId: 10,
    ),
    SuggestionItem(
      id: 20,
      name: "Geography Concepts Guide",
      content:
          "Class 10 Geography: Focus on Resources and Development, Agriculture, Manufacturing Industries, and Lifelines of Economy. Understand case studies and practice flowchart-based revision.",
      subjectId: 6,
      classId: 10,
    ),
  ];

  // ── Helpers for PYQ questions ──

  static QAItem _pyqQA(
    int id,
    String q,
    String a,
    QuestionType t,
    int subId,
    int yr,
  ) {
    return QAItem(
      id: id,
      question: q,
      answer: a,
      type: t,
      subjectId: subId,
      chapterId: yr,
      classId: yr,
    );
  }

  static List<QAItem> _madhyamikQuestions(int year, int subId) {
    final all = <QAItem>[
      // Bangla (subId: 1)
      _pyqQA(
        1001,
        "Write a paragraph on 'Importance of Education' in Bangla.",
        "শিক্ষার গুরুত্ব অপরিসীম। শিক্ষা মানুষকে আলোকিত করে, অন্ধকার দূর করে। শিক্ষার মাধ্যমে মানুষ সঠিক-ভুলের পার্থক্য বুঝতে পারে এবং সমাজে ইতিবাচক ভূমিকা রাখতে পারে। শিক্ষাই জাতির মেরুদণ্ড।",
        QuestionType.veryShort,
        1,
        year,
      ),
      _pyqQA(
        1002,
        "Explain the main theme of the poem 'Kandari Hushiar'.",
        "The poem 'Kandari Hushiar' by Kazi Nazrul Islam calls for awakening and alertness. It uses the metaphor of a boat journey to represent the nation's struggle, urging everyone to stay vigilant against oppression and work together for a better future.",
        QuestionType.explanatory,
        1,
        year,
      ),
      _pyqQA(
        1003,
        "Write a critical analysis of the short story 'Television' by Annada Shankar Ray.",
        "'Television' satirizes the invasion of modern technology into traditional Bengali households. Through the grandmother's perspective, the story explores how television replaces human interaction and storytelling. Ray uses irony and humor to critique blind adoption of technology while highlighting the value of oral traditions and family bonds.",
        QuestionType.essay,
        1,
        year,
      ),
      // English (subId: 2)
      _pyqQA(
        1004,
        "What is a clause? Give examples.",
        "A clause is a group of words containing a subject and a predicate. Examples: 'She runs' (independent clause), 'because he was tired' (dependent clause).",
        QuestionType.veryShort,
        2,
        year,
      ),
      _pyqQA(
        1005,
        "Explain the central idea of the poem 'The Ball Poem'.",
        "'The Ball Poem' by John Berryman explores the theme of loss and growing up. The boy loses his ball and realizes that loss is an inevitable part of life. The poem teaches that we must accept losses and move forward with maturity.",
        QuestionType.explanatory,
        2,
        year,
      ),
      _pyqQA(
        1006,
        "Discuss the character of the grandmother in Khushwant Singh's 'The Portrait of a Lady'.",
        "The grandmother in 'The Portrait of a Lady' is portrayed as a deeply spiritual and selfless woman. She is described as old, wrinkled, and always busy with her beads and prayers. Despite the generation gap and modernization, she maintains her traditional values and unconditional love for her grandson. Her silent departure symbolizes the passing of an era.",
        QuestionType.essay,
        2,
        year,
      ),
      // Math (subId: 3)
      _pyqQA(
        1007,
        "Find the value of x: 2x + 5 = 15",
        "2x + 5 = 15\n2x = 15 - 5\n2x = 10\nx = 5",
        QuestionType.veryShort,
        3,
        year,
      ),
      _pyqQA(
        1008,
        "Explain the concept of quadratic equations with an example.",
        "A quadratic equation is of the form ax² + bx + c = 0. Example: x² - 5x + 6 = 0. Solving: (x-2)(x-3) = 0, so x = 2 or x = 3.",
        QuestionType.explanatory,
        3,
        year,
      ),
      _pyqQA(
        1009,
        "A train travels 360 km at a uniform speed. If the speed had been 5 km/h more, it would have taken 1 hour less. Find the speed of the train.",
        "Let speed = x km/h. Time = 360/x. With x+5 speed: 360/(x+5). Difference = 1 hour.\n360/x - 360/(x+5) = 1\n360(x+5) - 360x = x(x+5)\n1800 = x² + 5x\nx² + 5x - 1800 = 0\n(x - 40)(x + 45) = 0\nx = 40 km/h (positive value)",
        QuestionType.essay,
        3,
        year,
      ),
      // Science (subId: 4)
      _pyqQA(
        1010,
        "What is the chemical formula of common salt?",
        "The chemical formula of common salt (sodium chloride) is NaCl.",
        QuestionType.veryShort,
        4,
        year,
      ),
      _pyqQA(
        1011,
        "Explain the process of photosynthesis.",
        "Photosynthesis is the process by which green plants convert light energy into chemical energy. 6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂. It occurs in chloroplasts using chlorophyll and requires sunlight, water, and carbon dioxide.",
        QuestionType.explanatory,
        4,
        year,
      ),
      _pyqQA(
        1012,
        "Describe the structure and function of the human heart.",
        "The human heart is a four-chambered muscular organ (two atria, two ventricles). It pumps blood throughout the body. The right side pumps deoxygenated blood to the lungs, while the left side pumps oxygenated blood to the body. It has valves to prevent backflow and is protected by the pericardium.",
        QuestionType.essay,
        4,
        year,
      ),
      // History (subId: 5)
      _pyqQA(
        1013,
        "When did the French Revolution start?",
        "The French Revolution started in 1789 with the storming of the Bastille on July 14.",
        QuestionType.veryShort,
        5,
        year,
      ),
      _pyqQA(
        1014,
        "Explain the causes of World War II.",
        "Causes of WWII: 1) Treaty of Versailles' harsh terms on Germany 2) Rise of Fascism and Nazism 3) Economic depression 4) Failure of the League of Nations 5) Policy of appeasement 6) Japanese expansionism.",
        QuestionType.explanatory,
        5,
        year,
      ),
      // Geography (subId: 6)
      _pyqQA(
        1015,
        "What is the Richter scale?",
        "The Richter scale measures earthquake magnitude logarithmically. Each whole number increase represents a tenfold increase in amplitude.",
        QuestionType.veryShort,
        6,
        year,
      ),
      _pyqQA(
        1016,
        "Explain the water cycle and its importance.",
        "The water cycle: evaporation → condensation → precipitation → collection. It distributes water globally, regulates climate, and supports all life forms.",
        QuestionType.explanatory,
        6,
        year,
      ),
    ];
    // Filter by year to vary questions
    final seed = year * subId;
    return all.where((q) => (q.id + seed) % 3 == 0).take(3).toList();
  }

  static List<QAItem> _class11Questions(int year, int subId) {
    final all = <QAItem>[
      _pyqQA(
        2001,
        "Define sets and give an example of a universal set.",
        "A set is a well-defined collection of objects. Example of universal set: U = {1, 2, 3, 4, 5} for sets A = {1, 2} and B = {3, 4}.",
        QuestionType.veryShort,
        1,
        year,
      ),
      _pyqQA(
        2002,
        "Explain the fundamental theorem of arithmetic.",
        "The fundamental theorem of arithmetic states that every integer greater than 1 can be uniquely expressed as a product of prime numbers, order notwithstanding.",
        QuestionType.explanatory,
        1,
        year,
      ),
      _pyqQA(
        2003,
        "Derive the formula for the sum of n terms of an arithmetic progression.",
        "Let AP be a, a+d, a+2d,... a+(n-1)d. Sum S = n/2[2a + (n-1)d]. Proof: Write terms forward and backward, add them to get 2S = n[2a + (n-1)d], hence S = n/2[2a + (n-1)d].",
        QuestionType.essay,
        1,
        year,
      ),
      _pyqQA(
        2004,
        "What is a redox reaction?",
        "A redox reaction involves simultaneous oxidation and reduction. Example: Zn + CuSO₄ → ZnSO₄ + Cu (Zn oxidizes, Cu²⁺ reduces).",
        QuestionType.veryShort,
        2,
        year,
      ),
      _pyqQA(
        2005,
        "Explain Newton's laws of motion.",
        "First law: Objects maintain state unless acted upon. Second law: F=ma. Third law: Every action has equal and opposite reaction.",
        QuestionType.explanatory,
        2,
        year,
      ),
    ];
    final seed = year * subId;
    return all.where((q) => (q.id + seed) % 2 == 0).take(2).toList();
  }

  static List<QAItem> _class12Questions(int year, int subId) {
    final all = <QAItem>[
      _pyqQA(
        3001,
        "What is an electrochemistry cell?",
        "An electrochemical cell converts chemical energy into electrical energy. Example: Daniell cell consists of Zn and Cu electrodes with their respective sulfate solutions.",
        QuestionType.veryShort,
        1,
        year,
      ),
      _pyqQA(
        3002,
        "Explain the concept of electromagnetic induction.",
        "Electromagnetic induction is the production of EMF in a conductor when the magnetic flux through it changes. Faraday's laws describe this phenomenon. Used in generators and transformers.",
        QuestionType.explanatory,
        1,
        year,
      ),
      _pyqQA(
        3003,
        "Discuss the structure and function of DNA.",
        "DNA has a double helix structure with complementary base pairing (A-T, G-C). It stores genetic information, replicates during cell division, and directs protein synthesis through transcription and translation.",
        QuestionType.essay,
        1,
        year,
      ),
      _pyqQA(
        3004,
        "What is the derivative of x²?",
        "The derivative of x² is 2x (using the power rule: d/dx(xⁿ) = nxⁿ⁻¹).",
        QuestionType.veryShort,
        2,
        year,
      ),
      _pyqQA(
        3005,
        "Explain the concept of resonance in chemistry.",
        "Resonance describes the delocalization of electrons in molecules where multiple Lewis structures can be drawn. The actual structure is a hybrid of all resonance forms. Example: Benzene has two resonance structures.",
        QuestionType.explanatory,
        2,
        year,
      ),
    ];
    final seed = year * subId;
    return all.where((q) => (q.id + seed) % 2 == 0).take(3).toList();
  }

  static Map<int, List<AppSubject>> _pyqSubjectsByYear(
    List<int> years,
    List<int> subIds,
  ) {
    final out = <int, List<AppSubject>>{};
    for (final y in years) {
      out[y] = subjects.where((s) => subIds.contains(s.id)).toList();
    }
    return out;
  }

  static Map<String, List<QAItem>> _pyqQuestionsByYear(
    List<int> years,
    List<int> subIds,
    List<QAItem> Function(int year, int subId) questionsFn,
  ) {
    final out = <String, List<QAItem>>{};
    for (final y in years) {
      for (final s in subIds) {
        out['$y-$s'] = questionsFn(y, s);
      }
    }
    return out;
  }

  // 🔹 Previous Year Categories
  static final previousYearCategories = [
    // Madhyamik - Class 10 board, subjects 1-6
    PreviousYearCategory(
      name: "Madhyamik",
      subtitle: "Class 10 board exam",
      years: [2020, 2021, 2022, 2023, 2024],
      subjectsByYear: _pyqSubjectsByYear(
        [2020, 2021, 2022, 2023, 2024],
        [1, 2, 3, 4, 5, 6],
      ),
      questionsBySubject: _pyqQuestionsByYear(
        [2020, 2021, 2022, 2023, 2024],
        [1, 2, 3, 4, 5, 6],
        _madhyamikQuestions,
      ),
    ),
    // Class XI - subjects 1, 2 (Math/Science focus)
    PreviousYearCategory(
      name: "Class XI",
      subtitle: "Higher secondary 1st year",
      years: [2021, 2022, 2023, 2024],
      subjectsByYear: _pyqSubjectsByYear([2021, 2022, 2023, 2024], [1, 2]),
      questionsBySubject: _pyqQuestionsByYear(
        [2021, 2022, 2023, 2024],
        [1, 2],
        _class11Questions,
      ),
    ),
    // Higher Secondary - Class 12, subjects 1, 2
    PreviousYearCategory(
      name: "Higher Secondary",
      subtitle: "Class 12 board exam",
      years: [2019, 2020, 2021, 2022, 2023, 2024],
      subjectsByYear: _pyqSubjectsByYear(
        [2019, 2020, 2021, 2022, 2023, 2024],
        [1, 2],
      ),
      questionsBySubject: _pyqQuestionsByYear(
        [2019, 2020, 2021, 2022, 2023, 2024],
        [1, 2],
        _class12Questions,
      ),
    ),
  ];

  // 🔹 QA Items (organized by subject & chapter)
  // Subject 1 = Bangla, Subject 2 = English, Subject 3 = Mathematics
  // Subject 4 = Science, Subject 5 = History, Subject 6 = Geography
  // Chapters 1-6 per subject
  static final qaItems = <QAItem>[
    // ── Bangla (subjectId: 1) ──
    // ── Bangla (subjectId: 1) - Class 9 & 10 ──
    QAItem(
      id: 1,
      question: "What is the main theme of 'Pother Pachali'?",
      answer:
          "The main theme of 'Pother Pachali' revolves around rural Bengali life, focusing on the childhood experiences and the socio-cultural landscape of early 20th century Bengal.",
      type: QuestionType.veryShort,
      subjectId: 1,
      chapterId: 1,
      classId: 9,
    ),
    QAItem(
      id: 2,
      question:
          "Explain the significance of 'Bangla Noboborsho' (Bengali New Year).",
      answer:
          "Bangla Noboborsho, celebrated on 14-15 April, marks the first day of the Bengali calendar. It symbolizes new beginnings, cultural unity, and is celebrated with traditional fairs, music, and the iconic 'Haal Khata' ritual.",
      type: QuestionType.explanatory,
      subjectId: 1,
      chapterId: 2,
      classId: 9,
    ),
    QAItem(
      id: 3,
      question: "Write a critical analysis of Kazi Nazrul Islam's 'Bidrohi'.",
      answer:
          "'Bidrohi' (The Rebel) is Nazrul's most famous poem, expressing fierce rebellion against oppression. It draws on diverse imagery from Hindu and Muslim traditions, calling for equality and justice. The poem's rhythmic intensity and revolutionary spirit made Nazrul the 'Rebel Poet' of Bengal.",
      type: QuestionType.essay,
      subjectId: 1,
      chapterId: 3,
      classId: 10,
    ),
    QAItem(
      id: 4,
      question: "What is 'Sandhi' in Bengali grammar?",
      answer:
          "Sandhi refers to the phonetic combination of two sounds or letters where the ending sound of one word merges with the beginning sound of the next, causing a change in pronunciation or spelling.",
      type: QuestionType.veryShort,
      subjectId: 1,
      chapterId: 4,
      classId: 10,
    ),

    // ── English (subjectId: 2) - Class 9 & 10 ──
    QAItem(
      id: 5,
      question: "What is a metaphor? Give an example.",
      answer:
          "A metaphor is a figure of speech that directly compares two unlike things without using 'like' or 'as'. Example: 'Time is a thief.'",
      type: QuestionType.veryShort,
      subjectId: 2,
      chapterId: 1,
      classId: 9,
    ),
    QAItem(
      id: 6,
      question: "Explain the theme of Shakespeare's 'Sonnet 18'.",
      answer:
          "Shakespeare's Sonnet 18 ('Shall I compare thee to a summer's day?') explores the theme of immortalizing beauty through poetry. The speaker argues that while summer fades, the beloved's beauty will live forever in the lines of the poem.",
      type: QuestionType.explanatory,
      subjectId: 2,
      chapterId: 2,
      classId: 9,
    ),
    QAItem(
      id: 7,
      question: "Discuss the role of the ghost in 'Hamlet'.",
      answer:
          "The ghost in 'Hamlet' serves as the catalyst for the entire plot. It reveals the truth about King Hamlet's murder, demands revenge, and represents the unresolved past. The ghost's ambiguous nature also raises questions about reality vs. appearance, a central theme in the play.",
      type: QuestionType.essay,
      subjectId: 2,
      chapterId: 3,
      classId: 10,
    ),

    // ── Mathematics (subjectId: 3) - Class 9 & 10 ──
    QAItem(
      id: 8,
      question: "What is Pythagoras theorem?",
      answer:
          "Pythagoras theorem states that in a right-angled triangle, the square of the hypotenuse is equal to the sum of squares of the other two sides: a² + b² = c².",
      type: QuestionType.veryShort,
      subjectId: 3,
      chapterId: 1,
      classId: 9,
    ),
    QAItem(
      id: 9,
      question: "Explain the concept of quadratic equations with an example.",
      answer:
          "A quadratic equation is a second-degree polynomial equation of the form ax² + bx + c = 0. For example, x² - 5x + 6 = 0 has solutions x = 2 and x = 3. It can be solved by factorization, completing the square, or using the quadratic formula.",
      type: QuestionType.explanatory,
      subjectId: 3,
      chapterId: 2,
      classId: 9,
    ),
    QAItem(
      id: 10,
      question: "Explain the application of integration in real life.",
      answer:
          "Integration has numerous real-life applications including: calculating areas and volumes, determining center of mass, analyzing electrical circuits, computing work done by variable forces, population growth modeling, and finding the distance traveled from velocity functions. It is fundamental in physics, engineering, and economics.",
      type: QuestionType.essay,
      subjectId: 3,
      chapterId: 4,
      classId: 10,
    ),
    QAItem(
      id: 11,
      question: "What is the value of π (pi)?",
      answer:
          "π (pi) is a mathematical constant approximately equal to 3.14159. It represents the ratio of a circle's circumference to its diameter.",
      type: QuestionType.veryShort,
      subjectId: 3,
      chapterId: 1,
      classId: 9,
    ),

    // ── Science (subjectId: 4) - Class 9 & 10 ──
    QAItem(
      id: 12,
      question: "What is photosynthesis?",
      answer:
          "Photosynthesis is the process by which green plants convert sunlight, carbon dioxide, and water into glucose and oxygen, using chlorophyll in their leaves.",
      type: QuestionType.veryShort,
      subjectId: 4,
      chapterId: 1,
      classId: 9,
    ),
    QAItem(
      id: 13,
      question: "Explain Newton's three laws of motion.",
      answer:
          "First Law: An object remains at rest or in uniform motion unless acted upon by an external force. Second Law: Force equals mass times acceleration (F=ma). Third Law: For every action, there is an equal and opposite reaction.",
      type: QuestionType.explanatory,
      subjectId: 4,
      chapterId: 2,
      classId: 9,
    ),
    QAItem(
      id: 14,
      question: "Write a comprehensive essay on climate change and its impact.",
      answer:
          "Climate change is a pressing global issue caused primarily by greenhouse gas emissions from human activities. Key impacts include: rising global temperatures, melting polar ice caps, sea level rise, extreme weather events, biodiversity loss, and threats to food security. Solutions involve transitioning to renewable energy, reducing deforestation, adopting sustainable agriculture, and international cooperation through agreements like the Paris Accord. Individual actions like reducing waste and conserving energy also play a crucial role.",
      type: QuestionType.essay,
      subjectId: 4,
      chapterId: 5,
      classId: 10,
    ),
    QAItem(
      id: 15,
      question: "What is the chemical symbol for water?",
      answer:
          "The chemical symbol for water is H₂O, meaning each molecule contains two hydrogen atoms and one oxygen atom.",
      type: QuestionType.veryShort,
      subjectId: 4,
      chapterId: 1,
      classId: 9,
    ),

    // ── History (subjectId: 5) - Class 10 ──
    QAItem(
      id: 16,
      question: "When did the French Revolution begin?",
      answer:
          "The French Revolution began in 1789 with the storming of the Bastille on July 14.",
      type: QuestionType.veryShort,
      subjectId: 5,
      chapterId: 1,
      classId: 10,
    ),
    QAItem(
      id: 17,
      question: "Explain the causes and effects of World War II.",
      answer:
          "Causes of WWII included the Treaty of Versailles' harsh terms on Germany, rise of fascism and Nazism, economic depression, and failure of appeasement. Effects included massive loss of life, the Holocaust, division of Europe, creation of the UN, beginning of the Cold War, and decolonization of Asia and Africa.",
      type: QuestionType.explanatory,
      subjectId: 5,
      chapterId: 3,
      classId: 10,
    ),
    QAItem(
      id: 18,
      question: "Describe the impact of British colonial rule on India.",
      answer:
          "British colonial rule (1757-1947) had profound impacts on India. Economically, it led to deindustrialization, drain of wealth, and transformation into a raw material supplier. Socially, it introduced Western education, railways, and legal systems, but also caused famines and cultural disruption. Politically, it unified India under one administration and sparked the independence movement led by figures like Gandhi, Nehru, and Bose.",
      type: QuestionType.essay,
      subjectId: 5,
      chapterId: 4,
      classId: 10,
    ),

    // ── Geography (subjectId: 6) - Class 10 ──
    QAItem(
      id: 19,
      question: "What is the largest ocean in the world?",
      answer:
          "The Pacific Ocean is the largest and deepest ocean in the world, covering approximately 63 million square miles.",
      type: QuestionType.veryShort,
      subjectId: 6,
      chapterId: 1,
      classId: 10,
    ),
    QAItem(
      id: 20,
      question: "Explain the water cycle and its importance.",
      answer:
          "The water cycle involves evaporation (water turning into vapor), condensation (vapor forming clouds), precipitation (rain/snow), and collection (water gathering in oceans, rivers, and lakes). It is essential for distributing water across the planet, regulating climate, and supporting all forms of life.",
      type: QuestionType.explanatory,
      subjectId: 6,
      chapterId: 2,
      classId: 10,
    ),
    QAItem(
      id: 21,
      question:
          "Explain the causes and effects of global warming on Earth's geography.",
      answer:
          "Global warming, driven by greenhouse gas emissions, is reshaping Earth's geography. Causes include fossil fuel burning, deforestation, and industrial agriculture. Effects include: melting glaciers and ice sheets causing sea level rise, changing coastlines, desertification of fertile lands, altered precipitation patterns leading to floods and droughts, shifting climate zones affecting agriculture, and loss of biodiversity as species struggle to adapt. Coastal cities face particular risk from rising sea levels.",
      type: QuestionType.essay,
      subjectId: 6,
      chapterId: 5,
      classId: 10,
    ),
    QAItem(
      id: 22,
      question: "What is the Richter scale?",
      answer:
          "The Richter scale is a logarithmic scale used to measure the magnitude of earthquakes. Each whole number increase represents a tenfold increase in amplitude.",
      type: QuestionType.veryShort,
      subjectId: 6,
      chapterId: 3,
      classId: 10,
    ),
  ];

}
