part of 'media_item_bloc.dart';

@immutable
sealed class MediaItemEvent {}

final class UploadMediaItemEvent extends MediaItemEvent {
  final File? mediaFile;

  UploadMediaItemEvent({required this.mediaFile});
}

final class CancelUploadMediaItemEvent extends MediaItemEvent {
  CancelUploadMediaItemEvent();
}

class DeleteMediaEvent extends MediaItemEvent {
  final String mediaId;

  DeleteMediaEvent(this.mediaId);
}
