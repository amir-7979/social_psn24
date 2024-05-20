import 'media.dart';

class Liked {
  final String? id;
  final String? name;
  final List<Media>? medias;
  final Creator? creator;

  Liked({required this.id, required this.name, required this.medias, required this.creator});

  factory Liked.fromJson(Map<String, dynamic> json) {
    return Liked(
      id: json['id'] as String?,
      name: json['name'] as String?,
      medias: (json['medias'] as List<dynamic>)
          .map((item) => Media.fromJson(item as Map<String, dynamic>))
          .toList(),
      creator: Creator.fromJson(json['creator'] as Map<String, dynamic>),
    );
  }
}


class Creator {
  final int id;
  final String phone;
  final String photo;
  final String name;
  final String family;

  Creator({required this.id, required this.phone, required this.photo, required this.name, required this.family});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] as int,
      phone: json['phone'] as String,
      photo: json['photo'] as String,
      name: json['name'] as String,
      family: json['family'] as String,
    );
  }
}