import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../repos/models/media.dart';

class MyVideoPlayer extends StatefulWidget {
  final Media media;

  MyVideoPlayer({required this.media});

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late FlickManager flickManager;


  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.networkUrl(Uri.parse(widget.media.getVideoUrl() ?? '')),
      autoPlay: false,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if (!widget.isInView) flickManager.flickControlManager?.pause();
    return FlickVideoPlayer(
      flickManager: flickManager,
      flickVideoWithControls: FlickVideoWithControls(
        controls: FlickPortraitControls(),
      ),
    );
  }
}