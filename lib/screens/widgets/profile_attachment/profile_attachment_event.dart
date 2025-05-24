part of 'profile_attachment_bloc.dart';

@immutable
abstract class ProfileAttachmentEvent {}

class UploadProfileAttachment extends ProfileAttachmentEvent {
  final File? file;
  final String name;
  final String fileName;

  UploadProfileAttachment(this.name, this.fileName, this.file);

}
class RemoveProfileAttachmentEvent extends ProfileAttachmentEvent {}
