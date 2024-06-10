part of 'setting_bloc.dart';

enum AppTheme { light, dark }
enum AppLanguage { english, persian }

class SettingState {
   AppTheme theme;
   AppLanguage language;
   UserPermissions? permissions;
   Profile? profile;
  String token = '';


  SettingState({
    required this.theme,
    required this.language,
    this.permissions,
    this.profile,
    required this.token,

  });


  get isUserLoggedIn => token != '';
  get getProfile => profile;
  get getPermissions => permissions;
   get seeExpertPost {
     if (permissions?.permissions != null) {
       for (var permission in permissions!.permissions!) {
         if (permission.id == 25 || permission.id == 29) {
           return true;
         }
       }
     }
     return false;
   }
/*
  set newTheme(AppTheme value) {
     theme = value;
     _storageService.saveData('theme', value.toString());
   }
*/

  SettingState copyWith({
    AppTheme? theme,
    AppLanguage? language,
    UserPermissions? permissions,
    Profile? profile,
    String? token,

  }) {
    return SettingState(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      permissions: permissions ?? this.permissions,
      profile: profile ?? this.profile,
      token: token ?? this.token,
    );
  }

  void reset() {
    this.theme = AppTheme.light;
    this.language = AppLanguage.persian;
    this.permissions = UserPermissions();
    this.profile = Profile();
    this.token = '';
  }
}