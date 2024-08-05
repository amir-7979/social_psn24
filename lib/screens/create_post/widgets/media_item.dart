import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/configs/setting/themes.dart';
import 'package:social_psn/screens/widgets/cached_network_image.dart';
import 'package:social_psn/screens/widgets/white_circular_progress_indicator.dart';
import '../../../repos/models/post_media.dart';
import '../create_post_bloc.dart';

class MediaItem extends StatelessWidget {
  PostMedia postMedia;

  MediaItem(this.postMedia);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.all(8),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage('assets/images/placeholder.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //circular container with text in it and with primarycolor background
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: (postMedia.order != null)
                          ? Text(
                              postMedia.order!.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: whiteColor),
                            )
                          : null,
                    ),
                  ),
                  Container(
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
                        return (state is MediaDeleting) ? WhiteCircularProgressIndicator() : IconButton(
                          color: Theme.of(context).colorScheme.error,
                          icon: FaIcon(
                              size: 20,
                              FontAwesomeIcons.thinClose,
                              color: whiteColor),
                          onPressed: () {
                            BlocProvider.of<CreatePostBloc>(context)
                                .add(DeleteMediaEvent(postMedia.id!));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // an image viwer with blur effect
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CacheImage(postMedia.mediaUrl),
            ),
          ],
        ),
      ),
    );
  }
}
