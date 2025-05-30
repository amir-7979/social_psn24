import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:social_psn/repos/repositories/dio/profile_repository.dart';

import '../../repos/models/consultation_model/consultation.dart';
import '../../repos/repositories/dio/consultation/invoice_repository.dart';

part 'my_consultation_event.dart';
part 'my_consultation_state.dart';

class MyConsultationBloc extends Bloc<MyConsultationEvent, MyConsultationState> {
  InvoiceRepository invoiceRepository = InvoiceRepository();
  ProfileRepository profileRepository = ProfileRepository();

  MyConsultationBloc() : super(MyConsultationInitial()) {
    on<FetchMyConsultationEvent>(_onFetchMyConsultationEvent);
    on<DeleteMyConsultationEvent>(_onDeleteMyConsultationEvent);
  }

  Future<void> _onFetchMyConsultationEvent(FetchMyConsultationEvent event, Emitter<MyConsultationState> emit) async {
    emit(MyConsultationLoading());
    try {
      Response result = await invoiceRepository.getInvoices();
      if (result.data == null || result.data['data'] == null) {

        emit(MyConsultationError('خطا در دریافت اطلاعات'));
      }
      List<Consultation> consultations = (result.data['data'] as List).map((item) => Consultation.fromJson(item)).toList();
      if (consultations.isEmpty) {
        emit(MyConsultationLoaded([]));

        return;
      }
      final List<int> consultationIds = consultations.map((c) => c.consultant!.id!).toList();
      try {
        result = await profileRepository.getInfoList(consultationIds);
      }catch (e) {
        print(e.toString());
        emit(MyConsultationError('خطا در دریافت اطلاعات'));
        return;
      }

      if (result.data == null || result.data['data'] == null) {
        emit(MyConsultationError('خطا در دریافت اطلاعات'));
        return;
      }


      final Map<String, dynamic> infoUrls = result.data['data'];
      for (var consultation in consultations) {
        final String consultIdStr = consultation.consultant!.id.toString();
        if (infoUrls.containsKey(consultIdStr)) {
          consultation.consultant!.infoUrl = infoUrls[consultIdStr]['photo'];
        }
      }
      //reverse the list of consultations and move first to end and end to first
      consultations = consultations.reversed.toList();


      emit(MyConsultationLoaded(consultations));
    } catch (e) {
      print(e.toString());
      emit(MyConsultationError('Failed to fetch consultations'));
    }
  }

  Map<int, List<int>> groupConsultationsByConsultant(Map<String, dynamic> json) {
    final Map<int, List<int>> grouped = {};

    final List<dynamic> consultations = json['data'];

    for (var consult in consultations) {
      final int consultationId = consult['id'];
      final int consultantId = consult['consultant']['id'];

      if (!grouped.containsKey(consultantId)) {
        grouped[consultantId] = [];
      }

      grouped[consultantId]!.add(consultationId);
    }

    return grouped;
  }

  Future<void> _onDeleteMyConsultationEvent(DeleteMyConsultationEvent event, Emitter<MyConsultationState> emit) async {
    emit(MyConsultationDeleteLoading());
    try {
      Response result = await invoiceRepository.cancelInvoice(event.id);
      if (result.data == null || result.data['data'] == null) {
        emit(MyConsultationDeleteError('خطا در حذف مشاوره'));
        return;
      }
      emit(MyConsultationDeleteSuccess('مشاوره با موفقیت حذف شد'));
    } catch (e) {
      print(e.toString());
      emit(MyConsultationDeleteError('خطا در حذف مشاوره'));
    }
  }
}

