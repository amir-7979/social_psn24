part of 'consultant_availability_bloc.dart';

@immutable
sealed class ConsultantAvailabilityEvent {}

class FetchConsultantAvailabilityEvent extends ConsultantAvailabilityEvent {
  final int consultantId;

  FetchConsultantAvailabilityEvent({
    required this.consultantId,
  });
}
//submit

class SubmitConsultantAvailabilityEvent extends ConsultantAvailabilityEvent {


  final int availableTimeId;
  final String consultantId;
  final String nationalId;
  final String type;

  SubmitConsultantAvailabilityEvent({
    required this.availableTimeId,
    required this.consultantId,
    required this.nationalId,
    required this.type,
  });
}