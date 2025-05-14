import 'thumbnail.dart';

class Media {
  String? id;
  final String? loc;
  final String? type;
  int? order;
  final List<Thumbnail>? thumbnails;

  Media({this.id, this.loc, this.type, this.order, this.thumbnails});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] as String?,
      loc: json['loc'] as String?,
      type: json['type'] as String?,
      order: json['order'] as int?,
      thumbnails: (json['thumbnails'] as List<dynamic>?)
          ?.map((e) => Thumbnail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String? getMediaUrl() {
    if (type!.contains('image') && loc != null) {
      return (loc ?? '');
    } else if (type!.contains('video') &&
        thumbnails != null &&
        thumbnails!.isNotEmpty) {
      return thumbnails![0].loc == null
          ? null
          : (thumbnails![0].loc ?? '');
    } else {
      return null;
    }
  }

  String? getVideoUrl() {
    if (type!.contains('video') && loc != null) {
      return (loc ?? '');
    } else {
      return null;
    }
  }

  String? getAudioUrl() {
    if (type!.contains('audio') && loc != null) {
      return (loc ?? '');
    } else {
      return null;
    }
  }

  String? getThumbnailUrl() {
    if (thumbnails != null && thumbnails!.isNotEmpty) {
      return (thumbnails![0].loc ?? '');
    } else {
      return null;
    }
  }
}
