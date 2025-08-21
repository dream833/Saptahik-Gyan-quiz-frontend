class CategoryModel {
  String status;
  List<Datum> data;

  CategoryModel({required this.status, required this.data});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      status: json['status'],
      data: List<Datum>.from(json['data'].map((x) => Datum.fromMap(x))),
    );
  }
}

class Datum {
  final int id;
  final String name;
  final String? image;

  Datum({
    required this.id,
    required this.name,
    this.image,
  });

  factory Datum.fromMap(Map<String, dynamic> map) {
    return Datum(
      id: int.tryParse(map['id'].toString()) ?? 0,
      name: map['name'] ?? '',
      image: map['image'],
    );
  }
}