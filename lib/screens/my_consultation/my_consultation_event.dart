part of 'my_consultation_bloc.dart';

@immutable
sealed class MyConsultationEvent {}

class FetchMyConsultationEvent extends MyConsultationEvent {
   FetchMyConsultationEvent();
}
//delete

class DeleteMyConsultationEvent extends MyConsultationEvent {
  final int id;
  DeleteMyConsultationEvent(this.id);
}

//edit

class EditMyConsultationEvent extends MyConsultationEvent {
  final int id;
  EditMyConsultationEvent(this.id);
}

