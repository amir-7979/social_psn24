import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

import '../../../repos/repositories/auth_repository.dart';
import '../../../services/core_graphql_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
  late String loginId;
  LoginBloc() : super(LoginInitial()) {
    on<LogInEvent>(_handleLogInEvent);

  }

  Future<void> _handleLogInEvent(
      LogInEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final QueryResult result =
      await coreGraphQLService.mutate(getLogInOptions(event.phoneNumber));
      if (result.hasException) {
        print(result.exception.toString());

        if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']['code'][0] == 'کد قبلی قابل استفاده است') {
          print(result.exception!.graphqlErrors.first.extensions!['validation']['code'][0]);
          emit(LoginSuccess(event.phoneNumber, loginId));
        } else if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']
            ['phone'] !=
                null) {
          emit(LoginFailure(result.exception!.graphqlErrors.first.extensions!['validation']
          ['phone']));
        }
      } else {
        loginId = result.data!['logIn'];
        emit(LoginSuccess(event.phoneNumber,loginId));
      }
    } catch (exception) {
      emit(LoginFailure('خطا'));
    }
  }


}
