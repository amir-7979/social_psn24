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

final class MediaUploadFailed extends MediaItemState {
  final String message;
  MediaUploadFailed(this.message);
}

final class MediaDeleting extends MediaItemState {
  final String mediaId;
  MediaDeleting(this.mediaId);
}

final class MediaDeleted extends MediaItemState {
  final String mediaId;
  MediaDeleted(this.mediaId);
}


final class MediaUploading extends MediaItemState {
  final File mediaFile;
  MediaUploading(this.mediaFile);
}

final class MediaUploadingPlaceholder extends MediaItemState {
  final File mediaFile;
  MediaUploadingPlaceholder(this.mediaFile);
}

final class MediaUploaded extends MediaItemState {
  final Media postMedia;

  MediaUploaded(this.postMedia);
}

final class MediaDeleteFailed extends MediaItemState {
  final String message;
  MediaDeleteFailed(this.message);
}
