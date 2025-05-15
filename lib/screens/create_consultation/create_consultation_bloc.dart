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

  Future<void> _onGetCounselingCentersEvent(
      GetCounselingCentersEvent event,
      Emitter<CreateConsultationState> emit
      ) async {
    emit(FetchCounselingCentersLoading());
    try {
      // 1) get raw centers
      Response result = await consultantsRepository.getCounselingCenters();
      if (result.data == null || result.data['data'] == null) {
        emit(FetchCounselingCentersFailure('خطا در دریافت اطلاعات'));
        return;
      }

      // 2) parse into model
      final centers = (result.data['data'] as List)
          .map((item) => CounselingCenter.fromJson(item))
          .toList();

      // 3) gather all consultant IDs across all centers
      final allIds = centers
          .expand((c) => c.consultants ?? <Consultant>[])  // if null, use empty list
          .map((consultant) => consultant.id!)
          .toSet()
          .toList();

      // 4) fetch profile infos in one batch
      Response infoResult;
      try {
        infoResult = await profileRepository.getInfoList(allIds);
        if (infoResult.data == null || infoResult.data['data'] == null) {
          emit(FetchCounselingCentersFailure('خطا در دریافت اطلاعات'));
          return;
        }
      } catch (e) {
        print(e);
        emit(FetchCounselingCentersFailure('خطا در دریافت اطلاعات'));
        return;
      }
      final Map<String, dynamic> infoMap = infoResult.data['data'];

      // 5) assign photo URLs back onto each consultant
      for (var center in centers) {
        for (var consultant in center.consultants!) {
          final key = consultant.id.toString();
          if (infoMap.containsKey(key)) {
            consultant.infoUrl = infoMap[key]['photo'];
          }
        }
      }

      // 6) emit the updated list
      emit(FetchCounselingCentersSuccess(centers));
    } catch (e) {
      emit(FetchCounselingCentersFailure(e.toString()));
    }
  }
}
