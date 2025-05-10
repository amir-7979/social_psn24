import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../repos/models/cooperation_type.dart';
import '../../../repos/repositories/dio/cosultation_repository.dart';

part 'create_request_event.dart';
part 'create_request_state.dart';

class CreateRequestBloc extends Bloc<CreateRequestEvent, CreateRequestState> {
  final RequestsRepository requestsRepository = RequestsRepository();

  CreateRequestBloc() : super(CreateRequestInitial()) {
    on<FetchCooperationType>(_onFetchCooperationType);
    on<AddCooperation>(_onAddCooperation);
    on<CancelCooperation>(_onCancelCooperation);

  }

  Future<void> _onFetchCooperationType(FetchCooperationType event, Emitter<CreateRequestState> emit) async {
    emit(TypeLoading());
    try {
      Response result = await requestsRepository.getRequestType();
      if (result.data == null) {
        emit(TypeError('خطا در دریافت اطلاعات'));
      }
      print(result.data.toString());
      final List<CooperationType> requestsData = (result.data['data'] as List).map((item) => CooperationType.fromJson(item)).toList();
      print(requestsData.toString());
      emit(TypeLoaded(requestsData));

    } catch (exception) {
      emit(TypeError('خطا در دریافت اطلاعات'));
    }
  }


  Future<void> _onAddCooperation(AddCooperation event, Emitter<CreateRequestState> emit) async {
    emit(SubmittingRequestLoading());
    try {
      Response result = await requestsRepository.postRequest(
          event.title, event.description, event.type, event.attachments);
      if (result.data == null) {
        emit(SubmittingRequestError('خطا در ارسال اطلاعات'));
      }
      print(result.data.toString());
      emit(SubmittingRequestSuccess());
    } catch (exception) {
      emit(SubmittingRequestError('خطا در ارسال اطلاعات'));
    }
  }

  Future<void> _onCancelCooperation(CancelCooperation event, Emitter<CreateRequestState> emit) async {
    emit(CancelRequestLoading());
    try {
      Response result = await requestsRepository.cancelRequest(event.id);
      if (result.data == null) {
        emit(CancelRequestError('خطا در ارسال اطلاعات'));
      }
      print(result.data.toString());
      emit(CancelRequestSuccess());
    } catch (exception) {
      emit(CancelRequestError('خطا در ارسال اطلاعات'));
    }
  }
}
