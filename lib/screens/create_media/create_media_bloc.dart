import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_media_event.dart';
part 'create_media_state.dart';

class CreateMediaBloc extends Bloc<CreateMediaEvent, CreateMediaState> {
  CreateMediaBloc() : super(CreateMediaInitial()) {
    on<CreateMediaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
