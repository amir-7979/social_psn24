import 'media.dart';

class Liked {
  final String? id;
  final String? name;
  final List<Media>? medias;
  //final Creator? creator;

  Liked({required this.id, required this.name, required this.medias, /*required this.creator*/});

  factory Liked.fromJson(Map<String, dynamic> json) {
    return Liked(
      id: json['id'] as String?,
      name: json['name'] as String?,
      medias: (json['medias'] as List<dynamic>)
          .map((item) => Media.fromJson(item as Map<String, dynamic>))
          .toList(),
/*
      creator: Creator.fromJson(json['creator'] as Map<String, dynamic>),
*/
    );
  }
}


