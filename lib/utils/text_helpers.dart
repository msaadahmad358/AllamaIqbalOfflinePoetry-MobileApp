import 'package:yaml/yaml.dart';

class TextHelpers {
  static String getText(dynamic list, String lang) {
    if (list == null) return '';
    try {
      final names = list as YamlList;
      final result =
          names.firstWhere((n) => n['lang'] == lang, orElse: () => null);
      return result?['text']?.toString() ?? '';
    } catch (e) {
      return '';
    }
  }

  static String getSherText(dynamic list, String lang) {
    if (list == null) return '';
    try {
      final texts = list as YamlList;
      final result =
          texts.firstWhere((n) => n['lang'] == lang, orElse: () => null);
      return result?['text']?.toString() ?? '';
    } catch (e) {
      return '';
    }
  }

  static String cleanText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
