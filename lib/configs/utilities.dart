import 'dart:ui';

import 'package:flutter/material.dart';

TextDirection detectDirection(String? text) {
  if (text == null || text.isEmpty) {
    return TextDirection.rtl; // Default to RTL if the input is null or empty
  }

  final rtlCharactersRegex = RegExp(r'[\u0600-\u06FF\u0621-\u064A\u0660-\u0669]');
  final latinCharactersRegex = RegExp(r'[a-zA-Z]');
  final specialCharactersRegex = RegExp(r'[$@!%*?&#^-_.+]');

  for (int i = 0; i < text.length; i++) {
    final char = text[i];

    // Skip special characters
    if (specialCharactersRegex.hasMatch(char)) {
      continue;
    }

    // Check for RTL characters
    if (rtlCharactersRegex.hasMatch(char)) {
      return TextDirection.rtl;
    }

    // Check for Latin characters
    if (latinCharactersRegex.hasMatch(char)) {
      return TextDirection.ltr;
    }
  }

  return TextDirection.rtl; // Default to RTL if no Latin characters are found
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();