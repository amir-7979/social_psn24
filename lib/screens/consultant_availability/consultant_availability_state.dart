part of 'consultant_availability_bloc.dart';

@immutable
sealed class ConsultantAvailabilityState {}

final class ConsultantAvailabilityInitial extends ConsultantAvailabilityState {}

final class ConsultantAvailabilityLoading extends ConsultantAvailabilityState {}
final class ConsultantAvailabilityLoaded extends ConsultantAvailabilityState {
  final ConsultantAvailability? consultantAvailability;

  ConsultantAvailabilityLoaded({
    required this.consultantAvailability,
  });
}

final class ConsultantAvailabilityError extends ConsultantAvailabilityState {
  final String message;

  ConsultantAvailabilityError(this.message);
}

final class ConsultantAvailabilitySubmitting extends ConsultantAvailabilityState {}
final class ConsultantAvailabilitySubmitted extends ConsultantAvailabilityState {
  final String message;

  ConsultantAvailabilitySubmitted(this.message);
}
final class ConsultantAvailabilitySubmitError extends ConsultantAvailabilityState {
  final String message;

  ConsultantAvailabilitySubmitError(this.message);
}
