import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/configs/setting/themes.dart';
import 'package:social_psn/screens/widgets/cached_network_image.dart';
import 'package:social_psn/screens/widgets/white_circular_progress_indicator.dart';
import '../../../repos/models/media.dart';
import '../create_post_bloc.dart';

class MediaItem extends StatelessWidget {
  Media postMedia;
  int index;

  MediaItem(this.postMedia, this.index);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CacheImage(postMedia.getMediaUrl())),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 4, vertical: 4),
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
                    child:  Center(
                          child: Text(
                              index.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: whiteColor),
                            ),
                        )

                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.error),
                      height: 20,
                      width: 20,
                      child: BlocBuilder<CreatePostBloc, CreatePostState>(
                        buildWhen: (previous, current) =>
                            current is MediaDeleting ||
                            current is MediaDeleteFailed,
                        builder: (context, state) {
                          return (state is MediaDeleting && state.mediaId == postMedia.id) ? Center(child: WhiteCircularProgressIndicator()) : Center(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              color: Theme.of(context).colorScheme.error,
                              icon: FaIcon(
                                  size: 17,
                                  FontAwesomeIcons.thinClose,
                                  color: whiteColor),
                              onPressed: () {
                                BlocProvider.of<CreatePostBloc>(context)
                                    .add(DeleteMediaEvent(postMedia.id!));
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
          // an image viwer with blur effect
        ],
      ),
    );
  }
}
