part of 'my_consultation_bloc.dart';

@immutable
sealed class MyConsultationEvent {}

class FetchMyConsultationEvent extends MyConsultationEvent {
   FetchMyConsultationEvent();
}
