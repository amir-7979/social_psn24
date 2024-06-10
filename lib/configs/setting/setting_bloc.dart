import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_psn/services/storage_service.dart';

import '../../repos/models/profile.dart';
import '../../repos/models/user_permissions.dart';
import '../../repos/repositories/profile_repository.dart';
import '../../services/core_graphql_service.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final StorageService _storageService = StorageService();
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;

  SettingBloc() : super(_handleInitialSetting()) {
    on<SettingThemeEvent>(_handleSettingThemeEvent);
    on<SettingLanguageEvent>(_handleSettingLanguageEvent);
    on<UpdateLoginStatus>(_handleUpdateLoginStatus);
    on<ClearInfo>(_handelClearUserInformation);
    on<FetchUserProfileWithPermissionsEvent>(_fetchUserProfileWithPermissions); // Add this line
    _loadSettingsFromStorage();
  }

  static SettingState _handleInitialSetting() {
    return SettingState(theme: AppTheme.light, language: AppLanguage.persian, token: '');
  }

  Future<void> _fetchUserProfileWithPermissions(event, emit) async {
    final QueryOptions options =  getUserProfileWithPermissions() ;
    final QueryResult result = await coreGraphQLService.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final Map<String, dynamic> data = result.data!;
      final Map<String, dynamic> profileData = data['profile'];
      final Map<String, dynamic> userPermissionsData = data['userPermissions'];
      final Profile profile = Profile.fromJson(profileData);
      final UserPermissions userPermissions = UserPermissions.fromJson(userPermissionsData);
      emit(state.copyWith(profile: profile, permissions: userPermissions));
    }
  }

  Future<void> _loadSettingsFromStorage() async {
    AppTheme theme = (await _storageService.readData('theme')) == 'AppTheme.dark' ? AppTheme.dark : AppTheme.light;
    AppLanguage language = (await _storageService.readData('language')) == 'english' ? AppLanguage.english : AppLanguage.persian;
    String? token = await _storageService.readData('token');
    emit(state.copyWith(theme: theme, language: language, token: token));
  }


  Future<void> _handleUpdateLoginStatus(event, emit) async {
    await writeInStorage(_storageService, event.data);
    emit(state.copyWith(token: event.data?['verifyToken'][2]));
  }

  Future<void> _handleSettingLanguageEvent(event, emit) async {
    await _storageService.saveData('language', event.language.toString()); // Save the language to storage
    if (event.language == AppLanguage.english) {
      emit(state.copyWith(language: AppLanguage.english));
    } else {
      emit(state.copyWith(language: AppLanguage.persian));
    }

  }

  Future<void> _handleSettingThemeEvent(event, emit) async {
    if (event.theme == AppTheme.light) {
      emit(state.copyWith(theme: AppTheme.light));
    } else {
      emit(state.copyWith(theme: AppTheme.dark));
    }
    await _storageService.saveData('theme', event.theme.toString()); // Save the theme to storage
  }

  FutureOr<void> _handelClearUserInformation(event, emit) async {
    await _storageService.deleteData('bearer');
    await _storageService.deleteData('expiry');
    await _storageService.deleteData('token');
    await _storageService.deleteData('refreshToken');
    await _storageService.deleteData('userId');
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