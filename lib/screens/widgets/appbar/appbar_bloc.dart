import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'appbar_event.dart';
part 'appbar_state.dart';

class AppbarBloc extends Bloc<AppbarEvent, AppbarState> {
  AppbarBloc() : super(AppbarInitial()) {
    on<AppbarSearch> ((event, emit) {
      emit(Searching(event.title));
    });
    on<AppbarResetSearch> ((event, emit) {
      emit(NotSearching());
    });
  }
}
