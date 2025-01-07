part of 'setting_bloc.dart';

abstract class SettingEvent {}

class SettingThemeEvent extends SettingEvent {
  final AppTheme theme;

  SettingThemeEvent(this.theme);
}

class SettingLanguageEvent extends SettingEvent {
  final AppLanguage language;

  SettingLanguageEvent(this.language);
}


class UpdateIsExpert extends SettingEvent {
  final bool isExpert;

  UpdateIsExpert(this.isExpert);
}

class UpdateLoginStatus extends SettingEvent {
  final Map<String, dynamic>? data;
  final Completer<void>? completer;
  UpdateLoginStatus(this.data, {this.completer});
}

class UpdateInfoEvent extends SettingEvent {
  String name;
  String lastName;
  String? phoneNumber;
  String? photo;

  UpdateInfoEvent(this.name, this.lastName, {this.phoneNumber, this.photo});
}

class ClearInfo extends SettingEvent {

  ClearInfo();
}

class FetchUserProfileWithPermissionsEvent extends SettingEvent {}

class FetchUserPermissionsEvent extends SettingEvent {}

class FetchTagsEvent extends SettingEvent {}

class UpdateUserSettingEvent extends SettingEvent {
  final String key;
  final dynamic value;

  UpdateUserSettingEvent(this.key, this.value);
}
