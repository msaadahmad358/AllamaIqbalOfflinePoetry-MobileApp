class BookModel {
  final String id;
  final String nameUr;
  final String nameEn;

  BookModel({
    required this.id,
    required this.nameUr,
    required this.nameEn,
  });

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] ?? '',
      nameUr: map['nameUr'] ?? '',
      nameEn: map['nameEn'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameUr': nameUr,
      'nameEn': nameEn,
    };
  }
}
