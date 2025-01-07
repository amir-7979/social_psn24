import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(widget.media.getVideoUrl() ?? ''),
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false),
      ),
      autoPlay: BlocProvider.of<SettingBloc>(context).state.userSettings.autoPlayVideos,
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
    return VisibilityDetector(
      key: Key(widget.media.getVideoUrl() ?? 'video'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction < 0.1 && flickManager.flickVideoManager!.isPlaying) {
          flickManager.flickControlManager?.pause();
        }
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: FlickVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: FlickVideoWithControls(
            controls: FlickPortraitControls(),
            aspectRatioWhenLoading: 16 / 9,
            videoFit: BoxFit.contain,

          ),
        ),
      ),
    );
  }
}
