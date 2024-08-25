import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_psn/services/storage_service.dart';

import '../../repos/models/profile.dart';
import '../../repos/models/tag.dart';
import '../../repos/models/user_permissions.dart';
import '../../repos/repositories/graphql/post_repository.dart';
import '../../repos/repositories/graphql/profile_repository.dart';
import '../../services/core_graphql_service.dart';
import '../../services/graphql_service.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final StorageService _storageService = StorageService();
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
  final GraphQLClient graphQLService = GraphQLService.instance.client;
  final Completer<void> _settingsLoadedCompleter = Completer<void>();
  final List<SettingEvent> _eventQueue = [];

  SettingBloc() : super(_handleInitialSetting()) {
    on<SettingThemeEvent>(_handleSettingThemeEvent);
    on<SettingLanguageEvent>(_handleSettingLanguageEvent);
    on<UpdateLoginStatus>(_handleUpdateLoginStatus);
    on<ClearInfo>(_handelClearUserInformation);
    on<FetchUserPermissionsEvent>(_fetchUserPermissions);
    on<FetchUserProfileWithPermissionsEvent>(_fetchUserProfileWithPermissions);
    on<FetchTagsEvent>(_fetchTags);
    _loadSettingsFromStorage();
  }

  static SettingState _handleInitialSetting() {
    return SettingState(theme: AppTheme.light, language: AppLanguage.persian, token: '');
  }

  Future<void> _fetchUserProfileWithPermissions(event, emit) async {
    await _settingsLoadedCompleter.future;
    try {
      final QueryOptions options = getUserProfileWithPermissions();
      final QueryResult result = await coreGraphQLService.query(options);
      if (result.hasException) {
        print(result.exception.toString());
      } else {
        final Map<String, dynamic> data = result.data!;
        final Map<String, dynamic> profileData = data['profile'];
        final Map<String, dynamic> userPermissionsData = data['userPermissions'];
        print('copy profile');
        print(profileData.toString());
        final Profile profile = Profile.fromJson(profileData);
        final UserPermissions userPermissions = UserPermissions.fromJson(userPermissionsData);
        emit(state.copyWith(profile: profile, permissions: userPermissions));
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _fetchUserPermissions(event, emit) async {
    await _settingsLoadedCompleter.future;
    print('_fetchUserPermissions');
    try {
      final QueryOptions options = getUserPermissions();
      final QueryResult result = await coreGraphQLService.query(options);
      if (result.hasException) {
        print(result.exception.toString());
      } else {
        final Map<String, dynamic> data = result.data!;
        final Map<String, dynamic> userPermissionsData = data['userPermissions'];
        final UserPermissions userPermissions = UserPermissions.fromJson(userPermissionsData);
        emit(state.copyWith(permissions: userPermissions));
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _loadSettingsFromStorage() async {
    AppTheme theme = (await _storageService.readData('theme')) == 'AppTheme.dark' ? AppTheme.dark : AppTheme.light;
    AppLanguage language = (await _storageService.readData('language')) == 'english' ? AppLanguage.english : AppLanguage.persian;
    String? token = await _storageService.readData('token');
    emit(state.copyWith(theme: theme, language: language, token: token ?? ''));
    _settingsLoadedCompleter.complete();
    _processEventQueue();
    if (state.isUserLoggedIn) {
      add(FetchUserProfileWithPermissionsEvent());
    } else {
      add(FetchUserPermissionsEvent());
    }
    add(FetchTagsEvent());
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
  }

  Future<void> _handleSettingLanguageEvent(event, emit) async {
    await _settingsLoadedCompleter.future;
    await _storageService.saveData('language', event.language.toString());
    if (event.language == AppLanguage.english) {
      emit(state.copyWith(language: AppLanguage.english));
    } else {
      emit(state.copyWith(language: AppLanguage.persian));
    }
  }

  Future<void> _handleSettingThemeEvent(event, emit) async {
    await _settingsLoadedCompleter.future;
    if (event.theme == AppTheme.light) {
      emit(state.copyWith(theme: AppTheme.light));
    } else {
      emit(state.copyWith(theme: AppTheme.dark));
    }
    await _storageService.saveData('theme', event.theme.toString()); // Save the theme to storage
  }

  FutureOr<void> _handelClearUserInformation(event, emit) async {
    await _settingsLoadedCompleter.future;
    await _storageService.deleteData('bearer');
    await _storageService.deleteData('expiry');
    await _storageService.deleteData('token');
    await _storageService.deleteData('refreshToken');
    CoreGraphQLService.instance.removeTokenFromAuthLink();
    GraphQLService.instance.removeTokenFromAuthLink();
    state.reset();
    emit(state.copyWith());
  }

  Future<void> writeInStorage(StorageService storageService, Map<String, dynamic>? data) async {
    await storageService.saveData('bearer', data?['Bearer']);
    await storageService.saveData('expiry', data?['expires_in']);
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

  Future<FutureOr<void>> _fetchTags(FetchTagsEvent event, Emitter<SettingState> emit) async {
    final QueryOptions options = getTags();
    final QueryResult result = await graphQLService.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final List<Tag> tags = (result.data!['tags'] as List).map((tag) => Tag.fromJson(tag)).toList();
      emit(state.copyWith(tags: tags));
    }
  }
}
