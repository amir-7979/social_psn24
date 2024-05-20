import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cooperation_event.dart';
part 'cooperation_state.dart';

class CooperationBloc extends Bloc<CooperationEvent, CooperationState> {
  CooperationBloc() : super(CooperationInitial()) {
    on<SubmitCooperation>(_submitCooperation);
  }

  FutureOr<void> _submitCooperation(event, emit) async {
    emit(CooperationLoading());
    await Future.delayed(Duration(seconds: 3));
    emit(CooperationSubmitted());

  }

/*
  void _loadCooperation(Emitter<CooperationState> emit) async {
    emit(CooperationLoading());
    // Fetch whether the user is an expert or not
    // This is just a placeholder, replace with your actual logic
    bool isUserExpert = await Future.delayed(Duration(seconds: 2), () => true);
    emit(CooperationLoaded(isUserExpert: isUserExpert));
  }
*/


}