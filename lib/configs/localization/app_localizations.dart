import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('lib/configs/localization/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value);
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  String translateNested(String key1, String key2) {
    return _localizedStrings[key1][key2] ?? key2;
  }

  String translateNestedWithVariable(String key1, String key2, Map<String, String> variables) {
    String result = _localizedStrings[key1][key2] ?? key2;
    variables.forEach((variableKey, variableValue) {
      result = result.replaceAll('{$variableKey}', variableValue);
    });
    return result;
  }

  String translateWithVariable(String key, Map<String, String> variables) {
    String result = _localizedStrings[key] ?? key;
    variables.forEach((variableKey, variableValue) {
      result = result.replaceAll('{$variableKey}', variableValue);
    });
    return result;
  }
}