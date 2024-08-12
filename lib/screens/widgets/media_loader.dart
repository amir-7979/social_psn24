import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/configs/setting/themes.dart';
import 'package:social_psn/screens/widgets/audio_player.dart';

import '../../repos/models/media.dart';
import 'post_media_cached_network_image.dart';
import 'video_player.dart';

class MediaLoader extends StatefulWidget {
  final List<Media>? medias;

  MediaLoader({Key? key, required this.medias}) : super(key: key);

  @override
  _MediaLoaderState createState() => _MediaLoaderState();
}

class _MediaLoaderState extends State<MediaLoader> {
  int _currentIndex = 0;
  bool _showVideo = false;
  bool _showAudio = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.medias?.length ?? 0,
          itemBuilder: (context, index, realIndex) {
            final media = widget.medias![index];
            return RepaintBoundary(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildMediaContent(media),
              ),
            );
          },
          options: CarouselOptions(
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
                _showVideo = false;
                _showAudio = false;
              });
            },
          ),
        ),
        if (widget.medias != null && widget.medias!.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: DotsIndicator(
              dotsCount: widget.medias!.length,
              position: _currentIndex,
              decorator: DotsDecorator(
                size: const Size.square(6.0),
                activeSize: const Size.square(8.0),
                spacing: const EdgeInsets.all(2.0),
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMediaContent(Media media) {
    if (media.type!.contains('video')) {
      return _showVideo
          ? MyVideoPlayer(media: media)
          : GestureDetector(
                  onTap: () => setState(() => _showVideo = true),
                  child: Container(
          padding: EdgeInsetsDirectional.zero,
          color: blackColor,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              PostMediaCachedNetworkImage(url: media.getThumbnailUrl() ?? ''),
              Center(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.play_arrow,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
                  ),
                );
    } else if (media.type!.contains('audio')) {
      return _showAudio
          ? MyAudioPlayer(media: media)
          : GestureDetector(
        onTap: () => setState(() => _showAudio = true),
        child: Container(
          color: blackColor,
          child: Center(
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.play_arrow,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      );
    } else if (media.type!.contains('image')) {
      return PostMediaCachedNetworkImage(
        url: media.getMediaUrl() ?? '',
        thumbnailUrl: media.getThumbnailUrl()?.isNotEmpty == true ? media.getThumbnailUrl() : null,
      );

    }
    return SizedBox(); // Fallback for other media types
  }
}
