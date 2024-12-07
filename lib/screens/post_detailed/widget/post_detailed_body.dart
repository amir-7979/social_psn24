
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/consts.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../configs/utilities.dart';
import '../../../repos/models/post.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/media_loader.dart';
import '../../widgets/profile_cached_network_image.dart';
import '../post_detailed_bloc.dart';
import 'post_detailed_badges.dart';

class PostDetailedBody extends StatefulWidget{
  Post post;
  bool isUserLoggedIn;

  PostDetailedBody(this.post, this.isUserLoggedIn);

  @override
  State<PostDetailedBody> createState() => _PostDetailedBodyState();
}

class _PostDetailedBodyState extends State<PostDetailedBody> {

  @override
  build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        InkWell(
          onTap: () {
            if(BlocProvider.of<SettingBloc>(context).state.profile?.globalId == widget.post.creator?.globalId){
              Navigator.of(context).pushNamed(AppRoutes.myProfile);
            }else{
              Navigator.of(context).pushNamed(AppRoutes.profile,
                  arguments: widget.post.creator?.globalId);
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: SizedBox.fromSize(
                  size: Size.fromRadius(24), // Image radius
                  child: widget.post.creator?.photo != null
                      ? ProfileCacheImage(widget.post.creator?.photo)
                      : SvgPicture.asset(
                      'assets/images/drawer/profile2.svg'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            '${widget.post.creator?.name} ${widget.post.creator?.family}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .shadow,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            '(${widget.post.creator?.username})',
                            textDirection: TextDirection.ltr,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${widget.post.creator?.displayName}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                        color:
                        Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/profile/calendar.svg',
                          width: 10,
                          height: 12,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '${widget.post.persianDate}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .surface,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BlocConsumer<PostDetailedBloc, PostDetailedState>(
                listener: (context, state) {
                  if (state is InterestSuccessState) {
                    widget.post.currentUserLiked =
                    !widget.post.currentUserLiked;
                    widget.post.isLiked =
                        widget.post.currentUserLiked;
                  } else if (state is InterestFailureState) {
                    widget.post.isLiked = !widget.post.isLiked;
                  } else if (state is NotificationSuccessState) {
                    widget.post.currentUserNotificationEnabled =
                    !widget.post.currentUserNotificationEnabled;
                    widget.post.isNotificationEnabled =
                        widget.post.currentUserNotificationEnabled;
                  } else if (state is NotificationFailureState) {
                    widget.post.isNotificationEnabled =
                    !widget.post.isNotificationEnabled;
                  }
                  setState(() {});
                },
                builder: (context, state) {
                  return PopupMenuButton<int>(
                    color: Theme.of(context).colorScheme.background,
                    elevation: 1,
                    shadowColor: Theme.of(context).colorScheme.shadow,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    icon: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        // semi-transparent background
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/profile/three_dots.svg',
                        width: 6,
                        height: 14,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          widget.post.isLiked = !widget.post.isLiked;
                          setState(() {});
                          if (widget.isUserLoggedIn == true) {
                            BlocProvider.of<PostDetailedBloc>(context)
                                .add(AddToInterestEvent(
                                widget.post.id));
                          } else {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.login);
                          }
                        },
                        value: 1,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            widget.post.isLiked
                                ? FaIcon(
                                size: 20,
                                FontAwesomeIcons.solidHeart,
                                color: Theme.of(context)
                                    .colorScheme
                                    .error)
                                : FaIcon(
                                size: 20,
                                FontAwesomeIcons.lightHeart,
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadow),
                            SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!
                                  .translateNested(
                                  "postScreen",
                                  widget.post.isLiked
                                      ? "delete_interest"
                                      : "interest"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadow,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          widget.post.isNotificationEnabled =
                          !widget.post.isNotificationEnabled;
                          setState(() {});
                          if (widget.isUserLoggedIn == true) {
                            BlocProvider.of<PostDetailedBloc>(context)
                                .add(EnableNotificationEvent(
                                widget.post.id));
                          } else {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.login);
                          }
                        },
                        value: 2,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            widget.post.isNotificationEnabled
                                ? FaIcon(
                                size: 20,
                                FontAwesomeIcons.solidBell,
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary)
                                : FaIcon(
                                size: 20,
                                FontAwesomeIcons.lightBell,
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadow),
                            SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!
                                  .translateNested(
                                  "postScreen",
                                  widget.post.isNotificationEnabled
                                      ? "delete_notification"
                                      : "notification"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadow,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          shareMethod("${inviteLink}posts/${widget.post.id}");
                        },
                        value: 3,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/post/share.svg',
                              height: 20,
                              width: 20,
                              color: Theme.of(context)
                                  .colorScheme
                                  .shadow,
                            ),
                            SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!
                                  .translateNested(
                                  "postScreen", "share"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .shadow,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        widget.post.medias == null || widget.post.medias!.isEmpty
            ? SizedBox(height: 40)
            : Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              vertical: 16),
          child: MediaLoader(medias: widget.post.medias),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: detectDirection(widget.post.name),
              child: Expanded(
                child: Text(
                  '${widget.post.name}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style:
                  Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.shadow,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Directionality(
          textDirection: detectDirection(widget.post.description),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.post.description ?? '',
                  overflow: TextOverflow.ellipsis,
                  textDirection: detectDirection(widget.post.description),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.shadow,
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        PostDetailedBadges(widget.post, widget.isUserLoggedIn),
        SizedBox(height: 8),
      ],
    );
  }
}
