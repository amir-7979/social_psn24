import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:social_psn/repos/repositories/dio/dio_notification_repository.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/repositories/dio/dio_auth_repository.dart';
import '../../../services/firebase_notification_service.dart';
import '../../../services/graphql_service.dart';
import '../../../services/request_queue.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final AuthRepository _authRepository = AuthRepository();
  final NotificationRepository _notifRepository = NotificationRepository();
  final SettingBloc settingBloc;
  late String loginId;

  VerifyBloc(this.settingBloc) : super(VerifyInitial()) {
    on<VerifyTokenEvent>(_handleVerifyTokenEvent);
    on<ResendCode>(_handleResendCode);
  }
  Future<void> _handleResendCode(ResendCode event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    try {
      Response<dynamic> response = await _authRepository.logIn(event.phone);
      if (response.statusCode == 200) {
        print(response.data);
        loginId = response.data['data']['id'].toString();
        emit(ResendSuccess(loginId));
      } else {
        emit(VerifyFailure('خطا در ارسال دوباره کد'));
      }
    } catch (e) {
      emit(VerifyFailure('خطا در ارسال دوباره کد'));
    }
  }


  Future<void> _handleVerifyTokenEvent(
      VerifyTokenEvent event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    try {
      var response = await _authRepository.verifyToken(int.parse(event.loginId), event.code);
      print(response.data);
      if (response.statusCode == 200) {

        Completer<void> completer = Completer<void>();
        settingBloc.add(UpdateLoginStatus(response.data['data'], completer: completer));
        await completer.future;
        await GraphQLService.instance.addTokenToAuthLink();
        settingBloc.add(FetchUserProfileWithPermissionsEvent());
        await RequestQueue().processQueue();
        await setFCM();
        if (response.data?['data']['status'] == '1'){
          settingBloc.add(FetchUserProfileWithPermissionsEvent());
          emit(VerifyFinished());
        } else
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

  Future<void> setFCM() async {
    String? fcmToken = await FirebaseNotificationService().getToken();
    if (fcmToken != null) {
       await _notifRepository.setFirebaseToken(fcmToken);
    }
  }

}
