import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_request_event.dart';
part 'create_request_state.dart';

class CreateRequestBloc extends Bloc<CreateRequestEvent, CreateRequestState> {
  CreateRequestBloc() : super(CreateRequestInitial()) {
    on<CreateRequestEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
