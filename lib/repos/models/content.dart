import 'media.dart';


class Content {
  final String? id;
  final String? name;
  final int? postType;
  final List<Media>? medias;

  Content({this.id, this.name, this.postType, this.medias});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'] as String?,
      name: json['name'] as String?,
      postType: json['post_type'] as int?,
      medias: (json['medias'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}


