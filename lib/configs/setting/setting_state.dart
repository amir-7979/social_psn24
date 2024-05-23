part of 'setting_bloc.dart';

enum AppTheme { light, dark }
enum AppLanguage { english, persian }

class SettingState {
  final AppTheme theme;
  final AppLanguage language;
  final UserPermissions? permissions;
  final bool? isExpert;
  final String? token; // New property for authentication token

  SettingState({
    required this.theme,
    required this.language,
    this.permissions,
    this.isExpert,
    this.token, // Initialize the new property
  });

  get isUserExpert => isExpert ?? false;
  get isUserLoggedIn => token != null;

  SettingState copyWith({
    AppTheme? theme,
    AppLanguage? language,
    UserPermissions? permissions,
    bool? isExpert,
    bool? isLoggedIn, // Add the new property to the copyWith method
    String? token, // Add the new property to the copyWith method
  }) {
    return SettingState(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      permissions: permissions ?? this.permissions,
      isExpert: isExpert == '' ? null : this.isExpert,
      token: token ?? this.token,
    );
  }
}