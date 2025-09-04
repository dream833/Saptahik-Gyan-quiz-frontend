class SpecialQuestionDetail {
  final int id;
  final String title;
  final List<QuestionItem> questions;

  SpecialQuestionDetail({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory SpecialQuestionDetail.fromJson(Map<String, dynamic> json) {
    final titleJson = json["title"] as Map<String, dynamic>? ?? {};
    final questionsJson = json["questions"] as List? ?? [];

    return SpecialQuestionDetail(
      id: titleJson["id"] != null
          ? int.tryParse(titleJson["id"].toString()) ?? 0
          : 0,
      title: titleJson["title"]?.toString() ?? "No Title",
      questions: questionsJson
          .map((e) => QuestionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuestionItem {
  final int id;
  final String question;
  final String answer;

  QuestionItem({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory QuestionItem.fromJson(Map<String, dynamic> json) {
    return QuestionItem(
      id: json["id"] != null ? int.tryParse(json["id"].toString()) ?? 0 : 0,
      question: json["question"]?.toString() ?? "No Question",
      answer: json["answer"]?.toString() ?? "No Answer",
    );
  }
}