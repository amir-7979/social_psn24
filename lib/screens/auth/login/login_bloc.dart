import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import '../../../repos/repositories/dio/auth_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository = AuthRepository();
  late String loginId;

  LoginBloc() : super(LoginInitial()) {
    on<LogInEvent>(_handleLogInEvent);
  }

  Future<void> _handleLogInEvent(LogInEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      Response<dynamic> response = await _authRepository.logIn(event.phoneNumber);
      print(response.data);
      if (response.statusCode == 200) {
        loginId = response.data['data']['id'].toString();
        emit(LoginSuccess(event.phoneNumber, loginId));
      }else if(response.data['status'] == 422){
        emit(LoginSuccess(event.phoneNumber, loginId));
      } else {
        emit(LoginFailure('خطا در ورود'));
      }
    } on DioException catch (e) {
      if (e.response!.data['status'] == 422) {
        emit(LoginAgain(event.phoneNumber, e.response!.data['message'].toString()));
      } else {

        emit(LoginFailure(e.response!.data['message'].toString()));
      }
    } catch (e) {
      emit(LoginFailure('خطا در ورود'));
    }
  }

}
