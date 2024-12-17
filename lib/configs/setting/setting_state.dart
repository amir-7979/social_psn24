part of 'setting_bloc.dart';

enum AppTheme { light, dark }
enum AppLanguage { english, persian }

class SettingState {
   AppTheme? theme;
   AppLanguage language;
   AdminSettings? adminSettings;
   Profile? profile;
  String token = '';
  List<Tag>? tags;


  SettingState({
    this.theme,
    required this.language,
    this.adminSettings,
    this.profile,
    required this.token,
    this.tags,
  });


  get isUserLoggedIn {
    return token != '';
  }
  get getProfile => profile;
  get getPermissions => profile?.permissions;
   get languageCode => language == AppLanguage.english ? 'en' : 'fa';

   get hasUsername => profile?.username != null && profile!.username!.isNotEmpty;

   get seeExpertPost {
     if (profile?.permissions != null) {
       for (var permission in profile!.permissions!) {
         if (permission == "view expert posts") {
           return true;
         }
       }
     }
     return false;
   }
   get seeExpertComment {
     if (profile?.permissions != null) {
       for (var permission in profile!.permissions!) {
         if (permission == "view expert comments") {
           return true;
         }
       }
     }
     return false;
   }

   get canChangeOnlineStatus {
     if (profile?.permissions != null) {
       for (var permission in profile!.permissions!) {
         if (permission == "change online status") {
           return true;
         }
       }
     }
     return false;
   }

   get canCreateExpertPost {
     if (profile?.permissions != null) {
       for (var permission in profile!.permissions!) {
         if (permission == "create expert post") {
           return true;
         }
       }
     }
     return false;
   }
   get tagsList => tags;
   get adminSettingsData => adminSettings;
/*
  set newTheme(AppTheme value) {
     theme = value;
     _storageService.saveData('theme', value.toString());
   }
*/

  SettingState copyWith({
    AppTheme? theme,
    AppLanguage? language,
    AdminSettings? adminSettings,
    Profile? profile,
    String? token,
    List<Tag>? tags,

  }) {
    return SettingState(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      adminSettings: adminSettings ?? this.adminSettings,
      profile: profile ?? this.profile,
      token: token ?? this.token,
      tags: tags ?? this.tags,
    );
  }

  void reset() {
    this.profile = Profile();
    this.adminSettings = AdminSettings();
    this.token = '';
    this.tags = null;
  }
}