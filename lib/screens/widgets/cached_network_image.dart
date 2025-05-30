import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CacheImage extends StatelessWidget {
  final String? url;
  CacheImage(this.url,);

  @override
  Widget build(BuildContext context) {
    return url == null ? Container(): CachedNetworkImage(
      imageUrl: url!,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) =>
          SvgPicture.asset('assets/images/profile/placeholder.svg', fit: BoxFit.cover,),
    );
  }
}