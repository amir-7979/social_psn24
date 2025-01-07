import 'setting_bloc.dart';

class UserSettings {
  final AppTheme theme;
  final AppLanguage language;
  final bool autoPlayVideos;
  final bool showLikeCountHomeScreen;
  final bool showLikeCountPostScreen;
  final bool enableNotifications;
  final bool enableContentNotifications;
  final bool showCharityNotifications;
  final bool showConsultNotifications;
  final bool hideDownloadedMediaSize;

  UserSettings({
    required this.theme,
    required this.language,
    this.autoPlayVideos = true,
    this.showLikeCountHomeScreen = true,
    this.showLikeCountPostScreen = true,
    this.enableNotifications = true,
    this.enableContentNotifications = true,
    this.showCharityNotifications = true,
    this.showConsultNotifications = true,
    this.hideDownloadedMediaSize = false,
  });

  UserSettings copyWith({
    AppTheme? theme,
    AppLanguage? language,
    bool? autoPlayVideos,
    bool? showLikeCountHomeScreen,
    bool? showLikeCountPostScreen,
    bool? enableNotifications,
    bool? enableContentNotifications,
    bool? showCharityNotifications,
    bool? showConsultNotifications,
    bool? hideDownloadedMediaSize,
  }) {
    return UserSettings(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      showLikeCountHomeScreen: showLikeCountHomeScreen ?? this.showLikeCountHomeScreen,
      showLikeCountPostScreen: showLikeCountPostScreen ?? this.showLikeCountPostScreen,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableContentNotifications: enableContentNotifications ?? this.enableContentNotifications,
      showCharityNotifications: showCharityNotifications ?? this.showCharityNotifications,
      showConsultNotifications: showConsultNotifications ?? this.showConsultNotifications,
      hideDownloadedMediaSize: hideDownloadedMediaSize ?? this.hideDownloadedMediaSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme.toString(),
      'language': language.toString(),
      'autoPlayVideos': autoPlayVideos,
      'showLikeCountHomeScreen': showLikeCountHomeScreen,
      'showLikeCountPostScreen': showLikeCountPostScreen,
      'enableNotifications': enableNotifications,
      'enableContentNotifications': enableContentNotifications,
      'showCharityNotifications': showCharityNotifications,
      'showConsultNotifications': showConsultNotifications,
      'hideDownloadedMediaSize': hideDownloadedMediaSize,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      theme: AppTheme.values.firstWhere((e) => e.toString() == json['theme']),
      language:
      AppLanguage.values.firstWhere((e) => e.toString() == json['language']),
      autoPlayVideos: json['autoPlayVideos'] ?? true,
      showLikeCountHomeScreen: json['showLikeCountHomeScreen'] ?? true,
      showLikeCountPostScreen: json['showLikeCountPostScreen'] ?? true,
      enableNotifications: json['enableNotifications'] ?? true,
      enableContentNotifications: json['enableContentNotifications'] ?? true,
      showCharityNotifications: json['showCharityNotifications'] ?? true,
      showConsultNotifications: json['showConsultNotifications'] ?? true,
      hideDownloadedMediaSize: json['hideDownloadedMediaSize'] ?? false,
    );
  }
}
