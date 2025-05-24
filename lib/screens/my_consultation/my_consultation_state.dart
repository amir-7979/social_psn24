part of 'my_consultation_bloc.dart';

@immutable
sealed class MyConsultationState {}

final class MyConsultationInitial extends MyConsultationState {}

final class MyConsultationLoading extends MyConsultationState {}

final class MyConsultationLoaded extends MyConsultationState {
  final List<Consultation> consultations;

   MyConsultationLoaded(this.consultations);
}

final class MyConsultationError extends MyConsultationState {
  final String message;

   MyConsultationError(this.message);
}

final class MyConsultationDeleteSuccess extends MyConsultationState {
  final String message;

   MyConsultationDeleteSuccess(this.message);
}
final class MyConsultationEditSuccess extends MyConsultationState {
  final String message;

   MyConsultationEditSuccess(this.message);
}
final class MyConsultationDeleteError extends MyConsultationState {
  final String message;

   MyConsultationDeleteError(this.message);
}
final class MyConsultationEditError extends MyConsultationState {
  final String message;

   MyConsultationEditError(this.message);
}
final class MyConsultationDeleteLoading extends MyConsultationState {}


