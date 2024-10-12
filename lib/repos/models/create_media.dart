import 'dart:io';
import 'dart:typed_data';

import 'media.dart';

class CreateMedia {
  Media? media;
  String? type;
  File? file;
  String? size;
  Uint8List? thumbnail;

  setMedia(Media media) {
    this.media = media;
  }

  CreateMedia.file({required this.type, required this.file, required this.size, this.thumbnail});
  CreateMedia.network({required this.media});
}