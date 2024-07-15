import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/repositories/auth_repository.dart';
import '../../../services/core_graphql_service.dart';
import '../../../services/graphql_service.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
  final SettingBloc settingBloc;
  late String loginId;

  VerifyBloc(this.settingBloc) : super(VerifyInitial()) {
    on<VerifyTokenEvent>(_handleVerifyTokenEvent);
    on<ResendCode>(_handleResendCode);
  }


  Future<void> _handleVerifyTokenEvent(
      VerifyTokenEvent event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    try {
      final QueryResult result = await coreGraphQLService.mutate(getVerifyTokenOptions(event.loginId ?? '', event.code));
      print(event.loginId);
      print(event.code);
      print('result: ${result.data}');
      if (result.hasException) {
        print(result.exception.toString());
        if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']
            ['code'] != null) {
          emit(VerifyFailure(result.exception!.graphqlErrors.first.extensions!['validation']['code'][0]));
        }else{
          emit(VerifyFailure('خطا'));
        }
      } else {
        settingBloc.add(UpdateLoginStatus(result.data));
        GraphQLService.instance.addTokenToAuthLink();
        CoreGraphQLService.instance.addTokenToAuthLink();
        settingBloc.add(FetchUserProfileWithPermissionsEvent());
        if (result.data?['verifyToken'][4] == 2)
          emit(VerifyFinished());
        else
          emit(VerifySuccess());
      }
    } catch (exception) {
      emit(VerifyFailure('خطا'));
    }
  }


  Future<void> _handleResendCode(
      ResendCode event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    try {
      final QueryResult result =
      await coreGraphQLService.mutate(getLogInOptions(event.phone));
      if (result.hasException) {
        print(result.exception.toString());
        if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']['code'][0] == 'کد قبلی قابل استفاده است') {
          print(result.exception!.graphqlErrors.first.extensions!['validation']['code'][0]);
          emit(ResendSuccess(loginId));
        } else if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']
            ['phone'] !=
                null) {
          emit(ResendFailure('خطا'));
        }
      } else {
        loginId = result.data!['logIn'];
        emit(ResendSuccess(loginId));
      }
    } catch (exception) {
      emit(ResendFailure('خطا'));
    }
  }



}
