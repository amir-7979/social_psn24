import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:social_psn/services/storage_service.dart';

import '../../repos/models/user_permissions.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final StorageService _storageService = StorageService(); // Add a StorageService instance

  SettingBloc() : super(
      SettingState(theme: AppTheme.light, language: AppLanguage.persian)) {
    on<SettingThemeEvent>(_handleSettingThemeEvent);
    on<SettingLanguageEvent>(_handleSettingLanguageEvent);
    on<UpdateLoginStatus>(_handleUpdateLoginStatus);
    on<UpdateUserPermissions>(_handleUpdateUserPermissions);
    on<UpdateIsExpert>(_handleUpdateIsExpert);
    on<ClearStatus>((event, emit) async {
      await _handelClearUserInformation();
    });
    _loadSettingsFromStorage(); // Load the settings from storage when the bloc is created

  }

  Future<void> _loadSettingsFromStorage() async {
    AppTheme theme = (await _storageService.readData('theme')) == 'AppTheme.dark' ? AppTheme.dark : AppTheme.light;
    AppLanguage language = (await _storageService.readData('language')) == 'english' ? AppLanguage.english : AppLanguage.persian;
    String? token = await _storageService.readData('token');
    print(await _storageService.readData('theme'));
    String? isExpert = await _storageService.readData('isExpert');
    String? permissionsJson = await _storageService.readData('permissions');
    UserPermissions permissions = UserPermissions.fromJson(jsonDecode(permissionsJson ?? '{}'));
    emit(state.copyWith(theme: theme, language: language, token: token, permissions: permissions, isExpert: isExpert == 'true' ? true : false));
  }

  Future<void> _handleUpdateLoginStatus(event, emit) async {
    await writeInStorage(_storageService, event.data);
    emit(state.copyWith(token: event.data?['verifyToken'][2]));
  }

  Future<void> _handleSettingLanguageEvent(event, emit) async {
    if (event.language == AppLanguage.english) {
      emit(state.copyWith(language: AppLanguage.english));
    } else {
      emit(state.copyWith(language: AppLanguage.persian));
    }
    await _storageService.saveData('language', event.language.toString()); // Save the language to storage

  }

  Future<void> _handleSettingThemeEvent(event, emit) async {
    if (event.theme == AppTheme.light) {
      emit(state.copyWith(theme: AppTheme.light));
    } else {
      emit(state.copyWith(theme: AppTheme.dark));
    }
    await _storageService.saveData('theme', event.theme.toString()); // Save the theme to storage
  }

  FutureOr<void> _handleUpdateUserPermissions(UpdateUserPermissions event, Emitter<SettingState> emit) {
    emit(state.copyWith(permissions: event.permissions));
  }

  Future<void> _handleUpdateIsExpert(UpdateIsExpert event, Emitter<SettingState> emit) async {
    await _storageService.saveData('isExpert', event.isExpert.toString()); // Save the language to storage
    emit(state.copyWith(isExpert: event.isExpert));
  }

  Future<void> _handelClearUserInformation() async {
    await _storageService.deleteData('bearer');
    await _storageService.deleteData('expiry');
    await _storageService.deleteData('token');
    await _storageService.deleteData('refreshToken');
    await _storageService.deleteData('userId');
    await _storageService.deleteData('isExpert');
    await _storageService.deleteData('permissions');
    emit(state.copyWith(isExpert: false, token: '', permissions: UserPermissions()));
  }

  Future<void> writeInStorage(StorageService storageService, Map<String, dynamic>? data) async {
    await storageService.saveData('bearer', data?['verifyToken'][0]);
    await storageService.saveData('expiry', data?['verifyToken'][1]);
    await storageService.saveData('token', data?['verifyToken'][2]);
    await storageService.saveData('refreshToken', data?['verifyToken'][3]);
    await storageService.saveData('userId', data?['verifyToken'][4]);
  }

}