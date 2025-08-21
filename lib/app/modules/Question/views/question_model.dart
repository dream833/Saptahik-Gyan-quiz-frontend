class QuestionModel {
  final int id;
  final String category;
  final String subCategory;
  final String question;
  final String answer;

  QuestionModel({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.question,
    required this.answer,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: int.parse(json['id'].toString()),
      category: json['category'],
      subCategory: json['sub_category'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}