
import 'consultation_type.dart';

class Consultant {
  final int? id;
  final String? name;
  final int? score;
  final List<ConsultationType>? consultationTypes;
  String? infoUrl;

  final bool hasInPerson;
  final bool hasChat;
  final bool hasAudio;
  final bool hasVideo;

  Consultant({
    this.id,
    this.name,
    this.score,
    this.consultationTypes,
    this.hasInPerson = false,
    this.hasChat = false,
    this.hasAudio = false,
    this.hasVideo = false,
  });

  factory Consultant.fromJson(Map<String, dynamic> json) {
    List<ConsultationType> types = (json['consultation_types'] as List<dynamic>?)
        ?.map((e) => ConsultationType.fromJson(e))
        .toList() ?? [];

    bool inPerson = types.any((t) => t.name == 'in_person');
    bool chat = types.any((t) => t.name == 'chat');
    bool audio = types.any((t) => t.name == 'audio');
    bool video = types.any((t) => t.name == 'video');


    return Consultant(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      name: json['name'] as String?,
      score: json['score'] as int?,
      consultationTypes: (json['consultation_types'] as List<dynamic>?)
          ?.map((e) => ConsultationType.fromJson(e))
          .toList(),
      hasInPerson: inPerson,
      hasChat: chat,
      hasAudio: audio,
      hasVideo: video,
    );
  }
}
