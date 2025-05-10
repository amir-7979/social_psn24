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

