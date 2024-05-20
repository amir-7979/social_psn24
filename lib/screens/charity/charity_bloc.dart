import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'charity_event.dart';
part 'charity_state.dart';

class CharityBloc extends Bloc<CharityEvent, CharityState> {
  CharityBloc() : super(CharityInitial()) {
    on<CharityEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
