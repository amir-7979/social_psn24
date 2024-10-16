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
  static const double itemWidth = 110;
  static const double itemHeight = 110;

  MediaItem({
    required this.mediaItemBloc,
    required this.createMedia,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: mediaItemBloc,
      child: BlocConsumer<MediaItemBloc, MediaItemState>(
        listener: (context, state) {
          if (state is MediaDeleteFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(content: state.message).build(context));
          } else if (state is MediaItemUploaded) {
            createMedia.setMedia(state.postMedia);
          }else if(state is MediaItemUploaded){
          } else if (state is MediaItemUploadFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(content: state.message).build(context));
            mediaItemBloc.createPostBloc
                .add(RemoveItemEvent(createMedia.media!.id!));
          }
        },
        builder: (context, state) {
          return Container(
            width: itemWidth,
            height: itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: state is MediaUploadProgress
                ? mediaLoading(context)
                : mediaLoaded(context),
          );
        },
      ),
    );
  }

  Widget mediaLoading(BuildContext context) {
    return BlocBuilder<MediaItemBloc, MediaItemState>(
      buildWhen: (previous, current) => current is MediaUploadProgress,
      builder: (context, state) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: itemWidth,
                  height: itemHeight,
                  child: (createMedia.type == 'audio')
                      ? SvgPicture.asset('assets/images/profile/audio.svg')
                      : (createMedia.media != null)
                          ? CacheImage(createMedia.media!.getMediaUrl())
                          : _buildMediaPlaceholder(createMedia, context),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            if (state is MediaUploadProgress)
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      value: state.progress ,
                      strokeWidth: 4.0,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  // Centered "X" icon
                  Center(
                    child: IconButton(
                      iconSize: 16,
                      icon: FaIcon(FontAwesomeIcons.xmark, color: Colors.white),
                      onPressed: () {mediaItemBloc.cancelToken.cancel();},
                    ),
                  ),
                ],
              ),
            if (state is MediaUploadProgress)
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                      bottom: 4, end: 4),
                  child: Text(
                    state.message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: whiteColor),
                  ),
                ),
              )
          ],
        );
      },
    );
  }

  Widget mediaLoaded(BuildContext context) {
    return BlocBuilder<CreatePostBloc, CreatePostState>(
      buildWhen: (previous, current) =>
          current is MediaItemUploaded ||
          current is MediaDeleting ||
          current is MediaDeleteFailed ||
          current is MediaItemUploadFailed,
      builder: (context, state) {
        if (state is MediaItemUploaded) {
        }
        return Stack(
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
                      width: itemWidth,
                      height: itemHeight,
                      child: (createMedia.type == 'audio')
                          ? SvgPicture.asset('assets/images/profile/audio.svg')
                          : (createMedia.media != null)
                              ? CacheImage(createMedia.media!.getMediaUrl())
                              : _buildMediaPlaceholder(createMedia, context),
                    );
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 4, vertical: 4),
              child: SizedBox(
                width: itemWidth,
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
                          style: Theme.of(context)
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
                          color: Theme.of(context).colorScheme.error,
                        ),
                        height: 20,
                        width: 20,
                        child: BlocBuilder<MediaItemBloc, MediaItemState>(
                          buildWhen: (previous, current) =>
                              current is MediaDeleting ||
                              current is MediaDeleteFailed,
                          builder: (context, state) {
                            return (state is MediaDeleting &&
                                    state.mediaId == createMedia.media!.id)
                                ? Center(
                                    child: WhiteCircularProgressIndicator())
                                : Center(
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      icon: FaIcon(
                                          size: 17,
                                          FontAwesomeIcons.thinClose,
                                          color: whiteColor),
                                      onPressed: () {
                                        print('delete');
                                        if (createMedia.media!= null)mediaItemBloc.add(DeleteMediaEvent(
                                            createMedia.media!.id!));
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
            if (createMedia.type == "audio")
              Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                      top: 4, bottom: 4, end: 4),
                  child: SizedBox(
                    width: itemWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            createMedia.name!.substring(
                                createMedia.name!.lastIndexOf('.') - 8),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: whiteColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            locale:
                                const Locale.fromSubtags(languageCode: 'en'),
                          ),
                        ),
                        FaIcon(
                          size: 17,
                          FontAwesomeIcons.solidHeadphones,
                          color: whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (createMedia.type == "video")
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 4),
                  child: FaIcon(
                      size: 17, FontAwesomeIcons.solidVideo, color: whiteColor),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMediaPlaceholder(CreateMedia createMedia, BuildContext context) {
    switch (createMedia.type) {
      case 'image':
        return createMedia.file != null
            ? Image.file(createMedia.file!, fit: BoxFit.cover)
            : shimmerContainer(context, width: 50, height: 50);
      case 'video':
        return createMedia.thumbnail != null
            ? Image.memory(
                createMedia.thumbnail!,
                fit: BoxFit.cover,
              )
            : shimmerContainer(context, width: 50, height: 50);
      case 'audio':
        return SvgPicture.asset('assets/images/profile/audio.svg');
      default:
        return shimmerContainer(context, width: 50, height: 50);
    }
  }
}
