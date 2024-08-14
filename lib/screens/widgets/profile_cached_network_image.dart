import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileCacheImage extends StatelessWidget {
  final String? url;
  double? width;
  double? height;

  ProfileCacheImage(this.url);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(25),
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) =>
          Image.asset('assets/images/profile/profile.png'),
    );
  }
}