import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'consultation_event.dart';
part 'consultation_state.dart';

class ConsultationBloc extends Bloc<ConsultationEvent, ConsultationState> {
  ConsultationBloc() : super(ConsultationInitial()) {
    on<ConsultationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
