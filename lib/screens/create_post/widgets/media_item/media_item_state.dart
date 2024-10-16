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


final class MediaDeleting extends MediaItemState {
  final String mediaId;
  MediaDeleting(this.mediaId);
}

final class MediaDeleted extends MediaItemState {
  final String mediaId;
  MediaDeleted(this.mediaId);
}



final class MediaDeleteFailed extends MediaItemState {
  final String message;
  MediaDeleteFailed(this.message);
}

final class MediaItemUploadCancelled extends MediaItemState {}

final class MediaUploadProgress extends MediaItemState {
  final double progress;
  final String message;
  MediaUploadProgress({required this.progress, required this.message});
}
