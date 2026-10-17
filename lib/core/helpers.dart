import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class TextHelpers {
  static String getText(dynamic list, String lang) {
    if (list == null) return '';
    try {
      final names = list as YamlList;
      final result =
          names.firstWhere((n) => n['lang'] == lang, orElse: () => null);
      return result?['text']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

  static String getSherText(dynamic list, String lang) => getText(list, lang);

  static String cleanText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool isUrdu(String s) => RegExp(r'[\u0600-\u06FF]').hasMatch(s);
}

final ValueNotifier<Map<String, String>?> lastReadNotifier =
    ValueNotifier<Map<String, String>?>(null);

Route<T> fadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (_, animation, __, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.03, 0), end: Offset.zero)
                  .animate(curved),
          child: child,
        ),
      );
    },
  );
}
