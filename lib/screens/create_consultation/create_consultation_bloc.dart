import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:social_psn/repos/models/consultation_model/consultant.dart';
import 'package:social_psn/repos/models/consultation_model/user.dart';

import '../../repos/models/consultation_model/counseling_center.dart';
import '../../repos/repositories/dio/consultation/consultants_repository.dart';
import '../../repos/repositories/dio/profile_repository.dart';

part 'create_consultation_event.dart';

part 'create_consultation_state.dart';

class CreateConsultationBloc
    extends Bloc<CreateConsultationEvent, CreateConsultationState> {
  ConsultantsRepository consultantsRepository = ConsultantsRepository();
  ProfileRepository profileRepository = ProfileRepository();

  CreateConsultationBloc() : super(CreateConsultationInitial()) {
    on<GetConsultantsEvent>(_onGetConsultantsEvent);
    on<GetCounselingCentersEvent>(_onGetCounselingCentersEvent);
  }

  Future<void> _onGetConsultantsEvent(CreateConsultationEvent event,
      Emitter<CreateConsultationState> emit) async {
    emit(FetchConsultantsLoading());
    try {
      Response result = await consultantsRepository.getConsultants();
      if (result.data == null || result.data['data'] == null) {
        emit(FetchConsultantsFailure('خطا در دریافت اطلاعات'));
      }
      final List<Consultant> consultants = (result.data['data'] as List)
          .map((item) => Consultant.fromJson(item))
          .toList();
      final List<int> consultationIds = consultants.map((c) => c.id!).toList();

      try {
        result = await profileRepository.getInfoList(consultationIds);
        if (result.data == null || result.data['data'] == null) {
          emit(FetchConsultantsFailure('خطا در دریافت اطلاعات'));
          return;
        }
      }catch (e) {
        print(e.toString());
        emit(FetchConsultantsFailure('خطا در دریافت اطلاعات'));
        return;
      }
      final Map<String, dynamic> infoUrls = result.data['data'];
      for (var consultant in consultants) {
        final String consultIdStr = consultant.id.toString();
        if (infoUrls.containsKey(consultIdStr)) {
          consultant.infoUrl = infoUrls[consultIdStr]['photo'];
        }
      }

      emit(FetchConsultantsSuccess(consultants));
    } catch (e) {
      emit(FetchConsultantsFailure(e.toString()));
    }
  }

  Future<void> _onGetCounselingCentersEvent(GetCounselingCentersEvent event, Emitter<CreateConsultationState> emit) async {
    emit(FetchCounselingCentersLoading());
    try {
      Response result = await consultantsRepository.getCounselingCenters();
      if (result.data == null || result.data['data'] == null) {
        emit(FetchCounselingCentersFailure('خطا در دریافت اطلاعات'));

      }
      print(result.data);
      final List<CounselingCenter> centers = (result.data['data'] as List)
          .map((item) => CounselingCenter.fromJson(item))
          .toList();
      emit(FetchCounselingCentersSuccess(centers));
    } catch (e) {
      emit(FetchCounselingCentersFailure(e.toString()));
    }
  }
}
