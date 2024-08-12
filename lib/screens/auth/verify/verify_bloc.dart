import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';
import '../../../configs/setting/setting_bloc.dart';

import '../../../repos/repositories/dio_auth_repository.dart';
import '../../../services/core_graphql_service.dart';
import '../../../services/graphql_service.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final AuthRepository _authRepository = AuthRepository();
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
  final SettingBloc settingBloc;
  late String loginId;

  VerifyBloc(this.settingBloc) : super(VerifyInitial()) {
    on<VerifyTokenEvent>(_handleVerifyTokenEvent);
    //on<ResendCode>(_handleResendCode);
  }

  Future<void> _handleVerifyTokenEvent(
      VerifyTokenEvent event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    try {
      var response = await _authRepository.verifyToken(int.parse(event.loginId), event.code);
      if (response.statusCode == 200) {
        Completer<void> completer = Completer<void>();
        settingBloc.add(UpdateLoginStatus(response.data['data'], completer: completer));
        await completer.future;
        await GraphQLService.instance.addTokenToAuthLink();
        await CoreGraphQLService.instance.addTokenToAuthLink();
        if (response.data?['data']['status'] == '1'){
          settingBloc.add(FetchUserProfileWithPermissionsEvent());
          emit(VerifyFinished());}
        else
          emit(VerifySuccess());
      } else {
        emit(VerifyFailure('خطا در ورود'));
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 406 && e.response!.data['message'].toString().contains('کد وارد شده اشتباه است')) {
        emit(VerifyFailure(e.response!.data['message'].toString()));
      } else {
        emit(VerifyFailure('خطا در ورود'));
      }
    } catch (e) {
      emit(VerifyFailure('خطا در ورود'));
    }
  }
}
