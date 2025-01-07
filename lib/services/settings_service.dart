import '../configs/setting/user_settings.dart';
import '../configs/setting/setting_bloc.dart';
import 'storage_service.dart';
import 'dart:convert'; // For JSON serialization and deserialization

class SettingsService {
  final StorageService _storageService;

  SettingsService(this._storageService);

  Future<UserSettings> loadSettings() async {
    final jsonString = await _storageService.readData('userSettings');
    if (jsonString == null) {
      return UserSettings(theme: AppTheme.light, language: AppLanguage.english);
    }
    final jsonMap = jsonDecode(jsonString);
    return UserSettings.fromJson(jsonMap);
  }

  Future<void> saveSettings(UserSettings settings) async {
    final jsonString = jsonEncode(settings.toJson());
    await _storageService.saveData('userSettings', jsonString);
  }

  Future<void> updateSetting(String key, dynamic value) async {
    final currentSettings = await loadSettings();
    final updatedSettings = currentSettings.toJson();
    updatedSettings[key] = value;
    final jsonString = jsonEncode(updatedSettings);
    await _storageService.saveData('userSettings', jsonString);
  }

  Future<void> saveToken(String token) async => await _storageService.saveData('token', token);

  Future<String?> loadToken() async => await _storageService.readData('token');
}
