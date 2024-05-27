part of 'setting_bloc.dart';

enum AppTheme { light, dark }
enum AppLanguage { english, persian }

class SettingState {
   AppTheme theme;
   AppLanguage language;
   UserPermissions? permissions;
   bool? isExpert;
  String token = '';
  String? phoneNumber;
  String? name;
  String? lastName;

  SettingState({
    required this.theme,
    required this.language,
    this.permissions,
    this.isExpert,
    required this.token,
    this.phoneNumber,
    this.name,
    this.lastName,
  });

  get isUserExpert => isExpert ?? false;
  get isUserLoggedIn => token != '';
  get fullName => '${name??''} ${lastName??''}';
  get userPhoneNumber => phoneNumber??'';

  SettingState copyWith({
    AppTheme? theme,
    AppLanguage? language,
    UserPermissions? permissions,
    bool? isExpert,
    bool? isLoggedIn,
    String? token,
    String? phoneNumber,
    String? name,
    String? lastName,
  }) {
    return SettingState(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      permissions: permissions ?? this.permissions,
      isExpert: isExpert == '' ? null : this.isExpert,
      token: token ?? this.token,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
    );
  }

  void reset() {
    this.theme = AppTheme.light;
    this.language = AppLanguage.persian;
    this.permissions = UserPermissions();
    this.isExpert = false;
    this.token = '';
    this.phoneNumber = null;
    this.name = null;
    this.lastName = null;
  }
}