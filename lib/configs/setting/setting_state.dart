part of 'setting_bloc.dart';

enum AppTheme {light, dark}
enum AppLanguage {english, persian}

class SettingState {
   UserSettings userSettings;
   String token;
   Profile? profile;
   AdminSettings? adminSettings;
   List<Tag>? tags;

  SettingState({
    required this.userSettings,
    required this.token,
    this.profile,
    this.adminSettings,
    this.tags,
  });

  factory SettingState.initial() {
    return SettingState(
      userSettings: UserSettings(theme: AppTheme.light, language: AppLanguage.persian),
      token: '',
      profile: null,
      adminSettings: null,
      tags: [],
    );
  }

  SettingState copyWith({
    UserSettings? userSettings,
    String? token,
    Profile? profile,
    AdminSettings? adminSettings,
    List<Tag>? tags}) {
    return SettingState(
      userSettings: userSettings ?? this.userSettings,
      token: token ?? this.token,
      profile: profile ?? this.profile,
      adminSettings: adminSettings ?? this.adminSettings,
      tags: tags ?? this.tags,
    );
  }

  void reset() {
    profile = null;
    adminSettings = null;
    token = '';
    tags = [];

  }

  bool get isUserLoggedIn => token.isNotEmpty;
  Profile? get getProfile => profile;
  List<String>? get getPermissions => profile?.permissions;
  bool get hasUsername => profile?.username != null && profile!.username!.isNotEmpty;
  bool get seeExpertPost => profile?.permissions?.contains("view expert posts") ?? false;
  bool get seeExpertComment => profile?.permissions?.contains("view expert comments") ?? false;
  bool get canChangeOnlineStatus => profile?.permissions?.contains("change online status") ?? false;
  bool get canCreateExpertPost => profile?.permissions?.contains("create expert post") ?? false;
  List<Tag>? get tagsList => tags;
  AdminSettings? get adminSettingsData => adminSettings;
   UserSettings get getUserSettings => userSettings;

   AppTheme get theme => userSettings.theme;
  AppLanguage get language => userSettings.language;
  bool get autoPlayVideos => userSettings.autoPlayVideos;
  bool get showLikeCountHomeScreen => userSettings.showLikeCountHomeScreen;
  bool get showLikeCountPostScreen => userSettings.showLikeCountPostScreen;
  bool get enableNotifications => userSettings.enableNotifications;
  bool get enableContentNotifications => userSettings.enableContentNotifications;
  bool get showCharityNotifications => userSettings.showCharityNotifications;
  bool get showConsultNotifications => userSettings.showConsultNotifications;
  bool get hideDownloadedMediaSize => userSettings.hideDownloadedMediaSize;
}
