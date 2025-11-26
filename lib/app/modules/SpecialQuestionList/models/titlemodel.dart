class TitleModel {
  final String id;
  final String title;

  TitleModel({required this.id, required this.title});

  factory TitleModel.fromJson(Map<String, dynamic> json) {
    return TitleModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
    );
  }
}