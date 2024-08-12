import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'shimmer.dart';

class PostMediaCachedNetworkImage extends StatelessWidget {
  final String? url;
  final String? thumbnailUrl;

  PostMediaCachedNetworkImage({
    required this.url,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      fit: BoxFit.contain,
      placeholder: (context, url) => CachedNetworkImage( imageUrl:thumbnailUrl ?? '', fit: BoxFit.cover, errorWidget: (context, url, error) =>shimmerContainer(context,
          width: double.infinity, height: double.infinity, radius: 0),
      ),
      errorWidget: (context, url, error) => AspectRatio(
        aspectRatio: 16 / 9,
        child: SvgPicture.asset('assets/images/profile/placeholder.svg',
            fit: BoxFit.fitWidth),
      ),
    );
  }
}

