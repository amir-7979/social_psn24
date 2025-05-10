import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../repos/models/consultation_model/consultation.dart';
import '../../repos/repositories/dio/consultation/invoice_repository.dart';

part 'my_consultation_event.dart';
part 'my_consultation_state.dart';

class MyConsultationBloc extends Bloc<MyConsultationEvent, MyConsultationState> {
  InvoiceRepository invoiceRepository = InvoiceRepository();
  MyConsultationBloc() : super(MyConsultationInitial()) {
    on<FetchMyConsultationEvent>(_onFetchMyConsultationEvent);
  }

  Future<void> _onFetchMyConsultationEvent(FetchMyConsultationEvent event, Emitter<MyConsultationState> emit) async {
    emit(MyConsultationLoading());
    try {
      Response result = await invoiceRepository.getInvoices();
      if (result.data == null) {
        emit(MyConsultationError('خطا در دریافت اطلاعات'));
      }
      final List<Consultation> consultations = (result.data['data'] as List).map((item) => Consultation.fromJson(item)).toList();


      emit(MyConsultationLoaded(consultations));
    } catch (e) {
      print(e.toString());
      emit(MyConsultationError('Failed to fetch consultations'));
    }
  }
}
