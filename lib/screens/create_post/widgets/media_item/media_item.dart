import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/configs/setting/themes.dart';
import 'package:social_psn/screens/create_post/widgets/media_item/media_item_bloc.dart';
import 'package:social_psn/screens/widgets/cached_network_image.dart';
import 'package:social_psn/screens/widgets/white_circular_progress_indicator.dart';
import '../../../../repos/models/media.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../create_post_bloc.dart';

class MediaItem extends StatelessWidget {
  final MediaItemBloc mediaItemBloc;
  final Media postMedia;
  final int index;
  final File? file;

  MediaItem({
    required this.mediaItemBloc,
    required this.postMedia,
    required this.index,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: mediaItemBloc,
      child: BlocListener<MediaItemBloc, MediaItemState>(
        listener: (context, state) {
          if (state is MediaUploadFailed ) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(content: state.message).build(context),
            );
          }else if (state is MediaDeleteFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(content: state.message).build(context),
            );
          }
        },
        child: _buildMediaItemContent(context),
      ),
    );
  }

  Widget _buildMediaItemContent(BuildContext context) {
    return Stack(
      children: [
        _buildMediaThumbnail(),
        _buildMediaControls(context),
      ],
    );
  }

  Widget _buildMediaThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CacheImage(postMedia.getMediaUrl()),
    );
  }

  Widget _buildMediaControls(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: IconButton(
        icon: Icon(Icons.close, color: Colors.red),
        onPressed: () {
          mediaItemBloc.add(DeleteMediaEvent(postMedia.id!));
        },
      ),
    );
  }
}
