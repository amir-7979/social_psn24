import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_psn/services/storage_service.dart';
import '../../repos/models/admin_setting.dart';
import '../../repos/models/profile.dart';
import '../../repos/models/tag.dart';
import '../../repos/repositories/dio/profile_repository.dart';
import '../../repos/repositories/graphql/post_repository.dart';
import '../../services/dio_auth_service.dart';
import '../../services/firebase_notification_service.dart';
import '../../services/graphql_service.dart';
import 'user_settings.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final ProfileRepository _profileRepository = ProfileRepository();
  final StorageService _storageService = StorageService();
  final GraphQLClient graphQLService = GraphQLService.instance.client;
  final Completer<void> _settingsLoadedCompleter = Completer<void>();
  final List<SettingEvent> _eventQueue = [];

  SettingBloc(UserSettings userSettings, String token)
      : super(_handleInitialSetting(userSettings, token)) {
    on<SettingThemeEvent>(_handleSettingThemeEvent);
    on<SettingLanguageEvent>(_handleSettingLanguageEvent);
    on<UpdateLoginStatus>(_handleUpdateLoginStatus);
    on<ClearInfo>(_handelClearUserInformation);
    on<FetchUserProfileWithPermissionsEvent>(_fetchUserProfileWithPermissions);
    on<FetchTagsEvent>(_fetchTags);
    on<UpdateUserSettingEvent>(_handleUpdateUserSettingEvent);

    _loadSettingsFromStorage();
  }

  static SettingState _handleInitialSetting(UserSettings userSettings, String token) {
    return SettingState(userSettings: userSettings, token: token);
  }

  Future<void> _fetchUserProfileWithPermissions(event, emit) async {
    await _settingsLoadedCompleter.future;
    try {
      var response = await _profileRepository.getProfile();
      final Profile profile = Profile.fromJson(response.data!['data']);
      print(response.data.toString());
      emit(state.copyWith(profile: profile));
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _loadSettingsFromStorage() async {
    _settingsLoadedCompleter.complete();
    _processEventQueue();
    if (state.isUserLoggedIn) {
      add(FetchUserProfileWithPermissionsEvent());
      add(FetchTagsEvent());
    }
  }

  void _processEventQueue() {
    while (_eventQueue.isNotEmpty) {
      add(_eventQueue.removeAt(0));
    }
  }

  Future<void> _handleUpdateLoginStatus(event, emit) async {
    await _settingsLoadedCompleter.future;
    await writeInStorage(_storageService, event.data);
    emit(state.copyWith(token: event.data?['access_token']));
    event.completer?.complete();
    add(FetchTagsEvent());
  }

  Future<void> _handleSettingLanguageEvent(event, emit) async {
    await _settingsLoadedCompleter.future;
    final updatedSettings = state.userSettings.copyWith(language: event.language);
    final jsonString = jsonEncode(updatedSettings.toJson());
    await _storageService.saveData('userSettings', jsonString);
    emit(state.copyWith(userSettings: updatedSettings));
  }

  Future<void> _handleSettingThemeEvent(event, emit) async {
    print(event.theme);
    await _settingsLoadedCompleter.future;
    final updatedSettings = state.userSettings.copyWith(theme: event.theme);
    final jsonString = jsonEncode(updatedSettings.toJson());
    await _storageService.saveData('userSettings', jsonString);
    emit(state.copyWith(userSettings: updatedSettings));
  }

  FutureOr<void> _handelClearUserInformation(event, emit) async {
    await _settingsLoadedCompleter.future;

    // Clear data from storage
    await _storageService.deleteData('token');
    await _storageService.deleteData('refreshToken');

    // Remove tokens from services
    GraphQLService.instance.removeTokenFromAuthLink();
    DioAuthService.instance.removeToken();

    // Remove Firebase notification token
    await FirebaseNotificationService.instance.removeToken();
    await FirebaseMessaging.instance.deleteToken();

    // Reset other state
    emit(state.copyWith(
      token: '',
      profile: null,
      adminSettings: null,
      userSettings: null,
      tags: [],
    ));
  }

  Future<void> writeInStorage(StorageService storageService, Map<String, dynamic>? data) async {
    await storageService.saveData('token', data?['access_token']);
    await storageService.saveData('refreshToken', data?['refresh_token']);
  }

  @override
  void onEvent(SettingEvent event) {
    if (!_settingsLoadedCompleter.isCompleted) {
      _eventQueue.add(event);
    } else {
      super.onEvent(event);
    }
  }

  Future<void> _fetchTags(FetchTagsEvent event, Emitter<SettingState> emit) async {
    final QueryOptions options = getTags();
    final QueryResult result = await graphQLService.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final List<Tag> tags =
      (result.data!['tags'] as List).map((tag) => Tag.fromJson(tag)).toList();
      emit(state.copyWith(tags: tags));
    }
  }

  Future<void> _handleUpdateUserSettingEvent(UpdateUserSettingEvent event, Emitter<SettingState> emit) async {
    try {
      final updatedSettings = state.userSettings.toJson();
      updatedSettings[event.key] = event.value;
      final newSettings = UserSettings.fromJson(updatedSettings);
      final jsonString = jsonEncode(newSettings.toJson());
      await _storageService.saveData("userSettings", jsonString);
      emit(state.copyWith(userSettings: newSettings));
    } catch (e) {
      print('Error updating setting: $e');
    }
  }

}
