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
  Media postMedia;
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
          if (state is MediaUploadFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(content: state.message).build(context),
            );
          } else if (state is MediaDeleteFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(content: state.message).build(context),
            );
          } else if (state is MediaUploadFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(content: state.message).build(context),
            );
            mediaItemBloc.createPostBloc.add(RemoveItemEvent(postMedia.id!));
          }
        },
        child: Container(
          width: 110,
          height: 110,
          child: Stack(
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: BlocBuilder<MediaItemBloc, MediaItemState>(
                    buildWhen: (previous, current) =>
                        current is MediaItemUploaded ||
                        current is MediaItemUploading,
                    builder: (context, state) {
                      return SizedBox(
                        width: 110,
                        height: 110,
                        child: (state is MediaItemUploaded)
                            ? CacheImage(state.postMedia.getMediaUrl())
                            : (state is MediaItemUploading) ? Image.file(file!,fit: BoxFit.cover) : CacheImage(postMedia.getMediaUrl()),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 4, vertical: 4),
                child: SizedBox(
                  width: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                        ),
                        child: Center(
                          child: Text(
                            index.toString(),
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .error,
                          ),
                          height: 20,
                          width: 20,
                          child: BlocBuilder<MediaItemBloc, MediaItemState>(
                            buildWhen: (previous, current) =>
                            current is MediaDeleting || current is MediaDeleteFailed,
                            builder: (context, state) {
                              return (state is MediaDeleting &&
                                  state.mediaId == postMedia.id)
                                  ? Center(
                                  child: WhiteCircularProgressIndicator())
                                  : Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .error,
                                  icon: FaIcon(size: 17,
                                      FontAwesomeIcons.thinClose,
                                      color: whiteColor),
                                  onPressed: () {
                                    mediaItemBloc.add(DeleteMediaEvent(postMedia.id!));
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
