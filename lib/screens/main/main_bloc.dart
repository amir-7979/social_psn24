import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState(1)) {
    on<MainUpdate>((event, emit) {
      emit(MainState(event.index));
    });
    on<CooperatingClicked>((event, emit) {
      emit(CooperatingState());
    });
  }
}