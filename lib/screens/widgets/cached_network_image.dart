import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CacheImage extends StatelessWidget {
  final String? url;
  double? width;
  double? height;


  CacheImage(this.url);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url??'',
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => const Center(),
    );
  }
}
