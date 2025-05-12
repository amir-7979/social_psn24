part of 'create_consultation_bloc.dart';

@immutable
sealed class CreateConsultationState {}

final class CreateConsultationInitial extends CreateConsultationState {}

final class FetchConsultantsLoading extends CreateConsultationState {}

final class FetchConsultantsSuccess extends CreateConsultationState {
  final List<Consultant> consultants;

  FetchConsultantsSuccess(this.consultants);
}

final class FetchConsultantsFailure extends CreateConsultationState {
  final String error;

  FetchConsultantsFailure(this.error);
}

final class FetchCounselingCentersLoading extends CreateConsultationState {}

final class FetchCounselingCentersSuccess extends CreateConsultationState {
  final List<CounselingCenter> centers;

  FetchCounselingCentersSuccess(this.centers);
}

final class FetchCounselingCentersFailure extends CreateConsultationState {
  final String error;

  FetchCounselingCentersFailure(this.error);
}

