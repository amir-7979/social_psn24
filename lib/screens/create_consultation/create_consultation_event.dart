part of 'create_consultation_bloc.dart';

@immutable
sealed class CreateConsultationEvent {}

class GetConsultantsEvent extends CreateConsultationEvent {}

class GetCounselingCentersEvent extends CreateConsultationEvent {}
