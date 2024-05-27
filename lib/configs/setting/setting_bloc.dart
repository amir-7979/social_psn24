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
      SettingState(theme: AppTheme.light, language: AppLanguage.persian, token: '')) {
    on<SettingThemeEvent>(_handleSettingThemeEvent);
    on<SettingLanguageEvent>(_handleSettingLanguageEvent);
    on<UpdateLoginStatus>(_handleUpdateLoginStatus);
    on<UpdateUserPermissions>(_handleUpdateUserPermissions);
    on<UpdateIsExpert>(_handleUpdateIsExpert);
    on<UpdateInfoEvent>(_handleUpdateInfoEvent);
    on<ClearInfo>(_handelClearUserInformation);
    _loadSettingsFromStorage(); // Load the settings from storage when the bloc is created

  }

  Future<void> _loadSettingsFromStorage() async {

    AppTheme theme = (await _storageService.readData('theme')) == 'AppTheme.dark' ? AppTheme.dark : AppTheme.light;
    AppLanguage language = (await _storageService.readData('language')) == 'english' ? AppLanguage.english : AppLanguage.persian;
    String? token = await _storageService.readData('token');
    String? name = await _storageService.readData('name');
    String? family = await _storageService.readData('family');
    String? phone = await _storageService.readData('phone');
    String? isExpert = await _storageService.readData('isExpert');
    String? permissionsJson = await _storageService.readData('permissions');
    UserPermissions permissions = UserPermissions.fromJson(jsonDecode(permissionsJson ?? '{}'));
    emit(state.copyWith(theme: theme, language: language, token: token, permissions: permissions, isExpert: isExpert == 'true' ? true : false, name: name, lastName: family, phoneNumber: phone));
  }

  Future<void> _handleUpdateInfoEvent(event, emit) async {
    await _storageService.saveData('name', event.name);
    await _storageService.saveData('family', event.lastName);
    if (event.phoneNumber != null) await _storageService.saveData('phone', event.phoneNumber);
    emit(state.copyWith(name: event.name, lastName: event.lastName, phoneNumber: event.phoneNumber));

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
    String permissionsJson = jsonEncode(event.permissions);
    _storageService.saveData('permissions', permissionsJson);
    emit(state.copyWith(permissions: event.permissions));
  }

  Future<void> _handleUpdateIsExpert(UpdateIsExpert event, Emitter<SettingState> emit) async {
    await _storageService.saveData('isExpert', event.isExpert.toString()); // Save the language to storage
    emit(state.copyWith(isExpert: event.isExpert));
  }

  FutureOr<void> _handelClearUserInformation(event, emit) async {
    await _storageService.deleteData('bearer');
    await _storageService.deleteData('expiry');
    await _storageService.deleteData('token');
    await _storageService.deleteData('refreshToken');
    await _storageService.deleteData('userId');
    await _storageService.deleteData('isExpert');
    await _storageService.deleteData('permissions');
    await _storageService.deleteData('name');
    await _storageService.deleteData('family');
    await _storageService.deleteData('phone');
    state.reset();
    emit(state.copyWith());
  }

  Future<void> writeInStorage(StorageService storageService, Map<String, dynamic>? data) async {
    await storageService.saveData('bearer', data?['verifyToken'][0]);
    await storageService.saveData('expiry', data?['verifyToken'][1]);
    await storageService.saveData('token', data?['verifyToken'][2]);
    await storageService.saveData('refreshToken', data?['verifyToken'][3]);
    await storageService.saveData('userId', data?['verifyToken'][4]);
  }

}