part of 'create_request_bloc.dart';

@immutable
abstract class CreateRequestEvent {}

class FetchCooperationType extends CreateRequestEvent {}

class AddCooperation extends CreateRequestEvent {
   String title = "_";
  final String description;
  final int type;
   List<Requirement> attachments = [];

  AddCooperation(this.title, this.description, this.type, this.attachments);
}

class CancelCooperation extends CreateRequestEvent {
  final int id;

  CancelCooperation(this.id);
}