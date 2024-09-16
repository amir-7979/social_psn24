part of 'media_item_bloc.dart';

@immutable
sealed class MediaItemEvent {}

final class UploadMediaItemEvent extends MediaItemEvent {
  final File mediaFile;
  UploadMediaItemEvent(this.mediaFile);
}

final class CancelUploadMediaItemEvent extends MediaItemEvent {
  final File mediaFile;
  CancelUploadMediaItemEvent(this.mediaFile);
}