import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../repos/models/request_data.dart';
import '../../../repos/repositories/dio/cosultation_repository.dart';

part 'requests_list_event.dart';
part 'requests_list_state.dart';

class RequestsListBloc extends Bloc<RequestsListEvent, RequestsListState> {
  final RequestsRepository requestsRepository = RequestsRepository();

  RequestsListBloc() : super(RequestsListInitial()) {
    on<FetchRequests>(_onFetchRequests);

  }

  Future<void> _onFetchRequests(FetchRequests event, Emitter<RequestsListState> emit) async {
    emit(RequestsLoading());
    try {
      Response result = await requestsRepository.getRequests();
      if (result.data == null) {
        emit(RequestsError('خطا در دریافت اطلاعات'));
      }
      final List<RequestData> requestsData = (result.data['data'] as List).map((item) => RequestData.fromJson(item)).toList();

      emit(RequestsDataLoaded(requestsData));

    } catch (exception) {
      emit(RequestsError('خطا در دریافت اطلاعات'));
    }
  }
}
