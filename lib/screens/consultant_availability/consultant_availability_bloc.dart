import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../repos/models/consultation_model/consultant_availability.dart';
import '../../repos/repositories/dio/consultation/consultants_repository.dart';
import '../../repos/repositories/dio/consultation/invoice_repository.dart';

part 'consultant_availability_event.dart';
part 'consultant_availability_state.dart';

class ConsultantAvailabilityBloc extends Bloc<ConsultantAvailabilityEvent, ConsultantAvailabilityState> {
  ConsultantsRepository consultantsRepository = ConsultantsRepository();
  InvoiceRepository invoiceRepository = InvoiceRepository();
  ConsultantAvailabilityBloc() : super(ConsultantAvailabilityInitial()) {
    on<FetchConsultantAvailabilityEvent>(_onFetchConsultantAvailability);
    on<SubmitConsultantAvailabilityEvent>(_onSubmitConsultantAvailability);
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

  Future<void> _onSubmitConsultantAvailability(SubmitConsultantAvailabilityEvent event, Emitter<ConsultantAvailabilityState> emit) async {
    emit(ConsultantAvailabilitySubmitting());

    try {
      final response = await invoiceRepository.bookSession(event.availableTimeId, event.consultantId, event.nationalId, event.type);
      if (response.data == null || response.data['data'] == null) {
        print(response.data);
        emit(ConsultantAvailabilitySubmitError('خطا در ارسال اطلاعات'));
      }
      print(response.data.toString());
      emit(ConsultantAvailabilitySubmitted(response.data['message']));

    } catch (e) {
      print(e.toString());

      emit(ConsultantAvailabilitySubmitError(e.toString()));
    }
  }
}
