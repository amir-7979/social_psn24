import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/screens/widgets/audio_player.dart';

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
              return Container(
                  width: 375,
                  height: 375,
                child: CachedNetworkImage(
                  imageUrl: media.getMediaUrl() ?? '',
                  height: 375,
                  width: 375,
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) =>
                      SvgPicture.asset('assets/images/profile/placeholder.svg', fit: BoxFit.fill),
                )
              );
            } else if (media.type!.contains('video')) {
              return SizedBox(
                  width: double.infinity,
                  child: MyVideoPlayer(media: media));
            }else if(media.type!.contains('audio')){
              return MyAudioPlayer(media: media);
            } else {
              return Container();
            }
          },
          options: CarouselOptions(
            aspectRatio: 375 / 240,
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