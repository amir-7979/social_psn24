import 'dart:ui';

TextDirection detectDirection(String? text) {
  if (text == null) {
    return TextDirection.rtl;
  }
  final rtlRegex = RegExp(r'(?<![@#.\s])[\u0591-\u07FF\uFB1D-\uFDFD\uFE70-\uFEFC]');
  // Regex to match numbers
  final numberRegex = RegExp(r'^\d+$');

  if (rtlRegex.hasMatch(text)) {
    return TextDirection.rtl;
  } else if (numberRegex.hasMatch(text)) {
    return TextDirection.rtl; // Treat pure numbers as RTL
  } else {
    return TextDirection.ltr;
  }

}