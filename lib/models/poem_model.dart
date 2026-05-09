class PoemModel {
  final String id;
  final String nameUr;
  final String nameEn;

  PoemModel({
    required this.id,
    required this.nameUr,
    required this.nameEn,
  });

  factory PoemModel.fromMap(Map<String, dynamic> map) {
    return PoemModel(
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

class SherModel {
  final String id;
  final String urText;
  final String enText;
  bool isFavorite;

  SherModel({
    required this.id,
    required this.urText,
    required this.enText,
    this.isFavorite = false,
  });

  factory SherModel.fromMap(Map<String, dynamic> map) {
    return SherModel(
      id: map['id'] ?? '',
      urText: map['ur'] ?? '',
      enText: map['en'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ur': urText,
      'en': enText,
      'isFavorite': isFavorite,
    };
  }
}
