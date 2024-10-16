import 'dart:io';
import 'dart:typed_data';
import 'media.dart';

class CreateMedia {
  Media? media;
  String? type, name;
  File? file;
  String? size;
  Uint8List? thumbnail;

  setMedia(Media media) {
    this.media = media;
    print('Media set');
  }

  CreateMedia.file({required this.type, required this.file, required this.size, this.thumbnail, this.name});
  CreateMedia.network({required this.media, required this.type, this.name, this.thumbnail}){
    this.media = media;
    this.type = type!.contains('video') ? 'video' : type!.contains('audio')
        ? 'audio'
        : 'image';
    if (name != null) {
      this.name = name;
    }
    if(thumbnail != null){
      this.thumbnail = thumbnail;
    }
  }

}