import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../repos/models/user_permissions.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(
      SettingState(theme: AppTheme.light, language: AppLanguage.persian)) {
    on<SettingThemeEvent>(_handleSettingThemeEvent);
    on<SettingLanguageEvent>(_handleSettingLanguageEvent);
    on<UpdateLoginStatus>(_handleUpdateLoginStatus);
    on<UpdateUserPermissions>(_handleUpdateUserPermissions);
    on<UpdateIsExpert>(_handleUpdateIsExpert);
  }

  FutureOr<void> _handleUpdateLoginStatus(event, emit) {
    emit(state.copyWith(token: event.token));
  }

  FutureOr<void> _handleSettingLanguageEvent(event, emit) {
    if (event.language == AppLanguage.english) {
      emit(state.copyWith(language: AppLanguage.english));
    } else {
      emit(state.copyWith(language: AppLanguage.persian));
    }
  }

  FutureOr<void> _handleSettingThemeEvent(event, emit) {
    if (event.theme == AppTheme.light) {
      emit(state.copyWith(theme: AppTheme.light));
    } else {
      emit(state.copyWith(theme: AppTheme.dark));
    }
  }

  FutureOr<void> _handleUpdateUserPermissions(UpdateUserPermissions event, Emitter<SettingState> emit) {
    emit(state.copyWith(permissions: event.permissions));
  }

  FutureOr<void> _handleUpdateIsExpert(UpdateIsExpert event, Emitter<SettingState> emit) {
    emit(state.copyWith(isExpert: event.isExpert));
  }
}