part of 'requests_list_bloc.dart';

@immutable
sealed class RequestsListState {}

final class RequestsListInitial extends RequestsListState {}
final class RequestsLoading extends RequestsListState {}
final class RequestsError extends RequestsListState {
  final String message;

  RequestsError(this.message);
}

final class RequestsDataLoaded extends RequestsListState {
  final List<RequestData> requestsData;

  RequestsDataLoaded(this.requestsData);
}