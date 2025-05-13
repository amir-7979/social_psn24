part of 'consultant_availability_bloc.dart';

@immutable
sealed class ConsultantAvailabilityEvent {}

class FetchConsultantAvailabilityEvent extends ConsultantAvailabilityEvent {
  final int consultantId;

  FetchConsultantAvailabilityEvent({
    required this.consultantId,
  });
}
