import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../configs/setting/setting_bloc.dart';
import '../../services/storage_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final SettingBloc settingBloc;

  MainBloc(this.settingBloc) : super(MainState(1)) {
    on<MainUpdate>((event, emit) {
      if((event.index == 0 || event.index == 3 || event.index == 4) && settingBloc.state.isUserLoggedIn == false){
        emit(AuthenticationState());
      }else {
        emit(MainState(event.index));
      }
    });
    on<CooperatingClicked>((event, emit) {
      emit(CooperatingState());
    });

    on<AuthenticationClicked>((event, emit) {
      emit(AuthenticationState());
    });
    on<InterestClicked>((event, emit) {
      emit(InterestState());
    });
    on<LogoutClicked>((event, emit) async {
      settingBloc.add(ClearStatus());
      emit(LogoutState());
    });
  }
  //delete info

}