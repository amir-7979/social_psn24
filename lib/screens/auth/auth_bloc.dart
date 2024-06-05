import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_psn/repos/repositories/profile_repository.dart';

import '../../configs/consts.dart';
import '../../configs/setting/setting_bloc.dart';
import '../../repos/repositories/auth_repository.dart';
import '../../services/core_graphql_service.dart';
import '../../services/graphql_service.dart';
import '../../services/storage_service.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GraphQLClient graphQLService = GraphQLService.instance.client;
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
  final SettingBloc settingBloc;
  String? loginId;
  String? photoUrl;

  AuthBloc(this.settingBloc) : super(InitState()) {
    on<LogInEvent>(_handleLogInEvent);
    on<VerifyTokenEvent>(_handleVerifyTokenEvent);
    on<EditUserEvent>(_handleRegisterEvent);
    on<GotoLoginEvent>(_handleGotoLoginEvent);
    on<PhotoUploadEvent>(_handlePhotoUploadEvent);
  }

  Future<void> _handleLogInEvent(
      LogInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final QueryResult result =
          await coreGraphQLService.mutate(getLogInOptions(event.phoneNumber));
      print('result: ${result.data}');
      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']
                    ['code'] !=
                null) {
          emit(AuthVerifyState(event.phoneNumber));
        } else if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']
                    ['phone'] !=
                null) {
          emit(AuthFailure(result.exception!.graphqlErrors[0]
              .extensions!['validation']['phone'][0]));
        }
      } else {
        loginId = result.data!['logIn'];
        emit(AuthVerifyState(event.phoneNumber));
      }
    } catch (exception) {
      emit(AuthFailure('خطا'));
    }
  }

  Future<void> _handleVerifyTokenEvent(
      VerifyTokenEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final QueryResult result = await coreGraphQLService
          .mutate(getVerifyTokenOptions(loginId ?? '', event.code));
      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']
                    ['code'] != null) {
          emit(AuthResetPin());
          emit(AuthResetPinNotif(result.exception!.graphqlErrors[0].extensions!['validation']['code'][0]));
        }
      } else {
        settingBloc.add(UpdateLoginStatus(result.data));
        GraphQLService.instance.addTokenToAuthLink();
        settingBloc.add(FetchUserProfileWithPermissionsEvent());

        if (result.data?['verifyToken'][4] == 2)
          emit(AuthRegisterState());
        else
          emit(AuthRegisterState());
      }
    } catch (exception) {
      emit(AuthResetPin());
      emit(AuthResetPinNotif('خطا'));
    }
  }

  Future<void> _handleRegisterEvent(EditUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final QueryResult result = await coreGraphQLService.mutate(
          getEditUserOptions(event.name, event.family, "@" + event.username, photoUrl, event.showActivity));
      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']
                    ['name'] !=
                null) {
          emit(AuthFailure(result.exception!.graphqlErrors[0]
              .extensions!['validation']['name'][0]));
        } else {
          emit(AuthFailure('خطا'));
        }
      } else {
        settingBloc.add(FetchUserProfileWithPermissionsEvent());
        photoUrl = null;
        emit(AuthFinished('ورود با موفقیت انجام شد'));
      }
    } catch (exception) {
      emit(AuthFailure('خطا'));
    }
  }

  Future<void> _handleGotoLoginEvent(
      GotoLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoginState());
  }

  Future<void> _handlePhotoUploadEvent(PhotoUploadEvent event, Emitter<AuthState> emit) async {
    photoUrl = event.file??null;
  }
}
