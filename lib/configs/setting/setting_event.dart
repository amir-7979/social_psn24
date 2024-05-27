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

class UpdateUserPermissions extends SettingEvent {
  final UserPermissions permissions;

  UpdateUserPermissions(this.permissions);
}

class UpdateIsExpert extends SettingEvent {
  final bool isExpert;

  UpdateIsExpert(this.isExpert);
}

class UpdateLoginStatus extends SettingEvent {
  final Map<String, dynamic>? data;

  UpdateLoginStatus(this.data);
}

class UpdateInfoEvent extends SettingEvent {
  String name;
  String lastName;
  String? phoneNumber;

  UpdateInfoEvent(this.name, this.lastName, {this.phoneNumber});
}

class ClearInfo extends SettingEvent {

  ClearInfo();
}