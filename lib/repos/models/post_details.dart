import 'media.dart';

class PostDetails {
  final String id;
  final String name;
  final List<Media> medias;

  PostDetails({required this.id, required this.name, required this.medias});

  factory PostDetails.fromJson(Map<String, dynamic> json) {
    return PostDetails(
      id: json['id'],
      name: json['name'],
      medias: (json['medias'] as List<dynamic>)
          .map((item) => Media.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
