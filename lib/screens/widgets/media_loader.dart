import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../../repos/models/media.dart';
import 'cached_network_image.dart';
import 'video_player.dart';

class MediaLoader extends StatefulWidget {
  final List<Media>? medias;

  MediaLoader({Key? key, required this.medias}) : super(key: key);

  @override
  _MediaLoaderState createState() => _MediaLoaderState();
}

class _MediaLoaderState extends State<MediaLoader> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.medias?.length ?? 0,
          itemBuilder: (context, index, realIndex) {
            final media = widget.medias![index];
            if (media.type!.contains('image')) {
              return SizedBox(
                width: 375,
                height: 340,
                child: CacheImage(
                  media.getMediaUrl(),
                ),
              );
            } else if (media.type!.contains('video')) {
              return MyVideoPlayer(media: media);
            } else {
              return Container();
            }
          },
          options: CarouselOptions(
            aspectRatio: 375 / 340,
            viewportFraction: 1.0,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        if (widget.medias != null && widget.medias!.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: DotsIndicator(
              dotsCount: widget.medias!.length,
              position: _currentIndex.toInt(),
              decorator: DotsDecorator(
                size: const Size.square(6.0),
                activeSize: const Size.square(6.0),
                spacing: EdgeInsets.all(4.0),
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}