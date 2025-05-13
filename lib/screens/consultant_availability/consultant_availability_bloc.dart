import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repos/models/consultation_model/consultant_availability.dart';
import '../../repos/repositories/dio/consultation/consultants_repository.dart';

part 'consultant_availability_event.dart';
part 'consultant_availability_state.dart';

class ConsultantAvailabilityBloc extends Bloc<ConsultantAvailabilityEvent, ConsultantAvailabilityState> {
  ConsultantsRepository consultantsRepository = ConsultantsRepository();
  ConsultantAvailabilityBloc() : super(ConsultantAvailabilityInitial()) {
    on<FetchConsultantAvailabilityEvent>(_onFetchConsultantAvailability);
  }

  Future<void> _onFetchConsultantAvailability(FetchConsultantAvailabilityEvent event, Emitter<ConsultantAvailabilityState> emit) async {
  emit(ConsultantAvailabilityLoading());
    try {
      final response = await consultantsRepository.getAvailability(event.consultantId);
      if (response.data == null || response.data['data'] == null) {
        emit(ConsultantAvailabilityError('خطا در دریافت اطلاعات'));
      }
      print(response.data);
        final consultantAvailability = ConsultantAvailability.fromJson(response.data);
        emit(ConsultantAvailabilityLoaded(consultantAvailability: consultantAvailability));

    } catch (e) {
      print(e.toString());

      emit(ConsultantAvailabilityError( e.toString()));
    }

  }
}
