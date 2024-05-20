import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../configs/consts.dart';
import '../../configs/setting/setting_bloc.dart';
import '../../repos/repositories/auth_repository.dart';
import '../../services/core_graphql_service.dart';
import '../../services/graphql_service.dart';
import '../../services/storage_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
  final SettingBloc settingBloc;
  String? loginId;
  String? phoneNumber;

  AuthBloc(this.settingBloc) : super(InitState()) {
    on<LogInEvent>(_handleLogInEvent);
    on<VerifyTokenEvent>(_handleVerifyTokenEvent);
    on<EditUserEvent>(_handleEditUserEvent);
    on<GotoLoginEvent>(_handleGotoLoginEvent);
  }

  Future<void> _handleLogInEvent(LogInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final QueryResult result = await coreGraphQLService.mutate(getLogInOptions(event.phoneNumber));
      if (result.hasException) {
        if(result.exception!.graphqlErrors.isNotEmpty && result.exception!.graphqlErrors.first.extensions!['validation']['code'] != null){
          emit(AuthVerifyState(event.phoneNumber));
        }else if(result.exception!.graphqlErrors.isNotEmpty && result.exception!.graphqlErrors.first.extensions!['validation']['phone'] != null){
          emit(AuthFailure(result.exception!.graphqlErrors[0].extensions!['validation']['phone'][0]));
        }
      } else {
        loginId = result.data!['logIn'];
        emit(AuthVerifyState(event.phoneNumber));
      }
    } catch (exception) {
      emit(AuthFailure('خطا'));
    }
  }


Future<void> _handleVerifyTokenEvent(VerifyTokenEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final QueryResult result = await coreGraphQLService.mutate(getVerifyTokenOptions(loginId??'', event.code));
    if (result.hasException) {
      if(result.exception!.graphqlErrors.isNotEmpty && result.exception!.graphqlErrors.first.extensions!['validation']['code'] != null){
        emit(AuthResetPin());
        emit(AuthResetPinNotif(result.exception!.graphqlErrors[0].extensions!['validation']['code'][0]));
      }
    } else {
      var data = result.data;
      final storageService = StorageService();
      if (data?['verifyToken'] != null) {
        await writeInStorage(storageService, data);
        settingBloc.add(UpdateLoginStatus(data?['verifyToken'][2])); // Dispatch the new event when the user logs in
      }
      GraphQLService.instance.addTokenToAuthLink();
      //todo if first one :
      print('data: $data');
      emit(AuthRegisterState());
    }
  } catch (exception) {
    emit(AuthResetPin());
    emit(AuthResetPinNotif('خطا'));

  }
}

Future<void> writeInStorage(StorageService storageService, Map<String, dynamic>? data) async {
    await storageService.saveData('bearer', data?['verifyToken'][0]);
    await storageService.saveData('expiry', data?['verifyToken'][1]);
    await storageService.saveData('token', data?['verifyToken'][2]);
    await storageService.saveData('refreshToken', data?['verifyToken'][3]);
    await storageService.saveData('userId', data?['verifyToken'][4]);
  }

Future<void> _handleEditUserEvent(EditUserEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    final QueryResult result = await coreGraphQLService.mutate(getEditUserOptions(event.name, event.family, event.username, event.photo, event.show_activity));
    if (result.hasException) {
      if(result.exception!.graphqlErrors.isNotEmpty && result.exception!.graphqlErrors.first.extensions!['validation']['name'] != null){
        emit(AuthFailure(result.exception!.graphqlErrors[0].extensions!['validation']['name'][0]));
      }
    } else {
      emit(AuthFinished('success'));
    }
  } catch (exception) {
    emit(AuthFailure('خطا'));
  }
}
  Future<void> _handleGotoLoginEvent(GotoLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoginState());
  }

}


