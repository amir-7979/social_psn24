import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

class CustomFlickPortraitControls extends StatelessWidget {
  const CustomFlickPortraitControls({
    Key? key,
    required this.manager,
  }) : super(key: key);

  final FlickControlManager manager;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FlickVideoProgressBar(
            flickProgressBarSettings: FlickProgressBarSettings(
              height: 5,
              handleRadius: 10,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              backgroundColor: Colors.white24,
              bufferedColor: Colors.white38,
              playedColor: Colors.white,
              handleColor: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Other controls (e.g., rewind, forward)
              FlickPlayToggle(
                color: Colors.white,
                size: 50,
              ),
              // Add other controls here as needed
              FlickFullScreenToggle(
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
