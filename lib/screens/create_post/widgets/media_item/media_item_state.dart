part of 'media_item_bloc.dart';

@immutable
sealed class MediaItemState {}

final class MediaItemInitial extends MediaItemState {}


final class MediaItemUploading extends MediaItemState {
  final File mediaFile;
  MediaItemUploading(this.mediaFile);
}

final class MediaItemUploaded extends MediaItemState {
  final Media postMedia;
  MediaItemUploaded(this.postMedia);
}

final class MediaItemUploadFailed extends MediaItemState {
  final String message;
  MediaItemUploadFailed(this.message);
}
