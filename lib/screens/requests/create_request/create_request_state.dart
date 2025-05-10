part of 'create_request_bloc.dart';

@immutable
sealed class CreateRequestState {}

final class CreateRequestInitial extends CreateRequestState {}
final class TypeLoading extends CreateRequestState {}


final class TypeLoaded extends CreateRequestInitial {
  final List<CooperationType> types;

  TypeLoaded(this.types);
}
final class TypeError extends CreateRequestState {
  final String message;

  TypeError(this.message);
}
final class SubmittingRequestLoading extends CreateRequestState {}

final class SubmittingRequestSuccess extends CreateRequestState {}

final class SubmittingRequestError extends CreateRequestState {
  final String message;

  SubmittingRequestError(this.message);
}

final class CancelRequestLoading extends CreateRequestState {}
final class CancelRequestSuccess extends CreateRequestState {}
final class CancelRequestError extends CreateRequestState {
  final String message;

  CancelRequestError(this.message);
}