import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../repos/models/media.dart';
import 'cached_network_image.dart';

Widget selectImage(List<Media> medias) {
  if (medias.isEmpty) {
    return SvgPicture.asset('assets/images/profile/text.svg');
  } else if (medias.isNotEmpty && medias[0].type!.contains('audio')) {
    return SvgPicture.asset('assets/images/profile/audio.svg');
  } else {
    return CacheImage(medias[0].getMediaUrl());
  }
}
