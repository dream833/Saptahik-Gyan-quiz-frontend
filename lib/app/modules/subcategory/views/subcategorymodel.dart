class Subcategory {
  final int id;
  final String name;

  Subcategory({
    required this.id,
    required this.name,
  });

  factory Subcategory.fromMap(Map<String, dynamic> map) {
    return Subcategory(
      id: int.parse(map['id'].toString()),
      name: map['name'] ?? '',
    );
  }
}