import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/configs/setting/themes.dart';
import 'package:social_psn/repos/models/create_media.dart';
import 'package:social_psn/screens/create_post/widgets/media_item/media_item_bloc.dart';
import 'package:social_psn/screens/widgets/cached_network_image.dart';
import 'package:social_psn/screens/widgets/white_circular_progress_indicator.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/shimmer.dart';
import '../../create_post_bloc.dart';

class MediaItem extends StatelessWidget {
  final MediaItemBloc mediaItemBloc;
  CreateMedia createMedia;
  final int index;

  MediaItem({
    required this.mediaItemBloc,
    required this.createMedia,
    required this.index,
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
            mediaItemBloc.createPostBloc.add(RemoveItemEvent(createMedia.media!.id!));
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
                      if (state is MediaItemUploaded) {
                        createMedia = CreateMedia.network(media: state.postMedia);
                      }
                      return SizedBox(
                        width: 110,
                        height: 110,
                        child: (state is MediaItemUploaded)
                            ? CacheImage(createMedia.media!.getMediaUrl())
                            : (createMedia.media!= null) ? CacheImage(createMedia.media!.getMediaUrl()) : _buildMediaPlaceholder(createMedia, context),
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
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Center(
                          child: Text(
                            index.toString(),
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          height: 20,
                          width: 20,
                          child: BlocBuilder<MediaItemBloc, MediaItemState>(
                            buildWhen: (previous, current) =>
                            current is MediaDeleting || current is MediaDeleteFailed,
                            builder: (context, state) {
                              return (state is MediaDeleting &&
                                  state.mediaId == createMedia.media!.id)
                                  ? Center(child: WhiteCircularProgressIndicator())
                                  : Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  color: Theme.of(context).colorScheme.error,
                                  icon: FaIcon(size: 17,
                                      FontAwesomeIcons.thinClose,
                                      color: whiteColor),
                                  onPressed: () {
                                    mediaItemBloc.add(DeleteMediaEvent(createMedia.media!.id!));
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


  Widget _buildMediaPlaceholder(CreateMedia createMedia, BuildContext context) {
    switch (createMedia.type) {
      case 'image':
        return createMedia.file != null
            ? Image.file(createMedia.file!, fit: BoxFit.cover)
            : shimmerContainer(context,
            width: 50, height: 50);
      case 'video':
        return  createMedia.thumbnail != null ? Image.memory(createMedia.thumbnail!, fit: BoxFit.cover,) : shimmerContainer(context,
    width: 50, height: 50);
      case 'audio':
        return SvgPicture.asset('assets/images/profile/audio.svg');
      default:
        return shimmerContainer(context,
            width: 50, height: 50);
    }
  }
}
