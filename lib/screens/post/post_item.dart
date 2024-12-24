import 'package:clipboard/clipboard.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/screens/widgets/media_loader.dart';
import '../../../configs/consts.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/models/post.dart';
import '../../configs/setting/themes.dart';
import '../../configs/utilities.dart';
import '../../services/request_queue.dart';
import '../main/widgets/screen_builder.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/profile_cached_network_image.dart';
import 'post_bloc.dart';

class PostItem extends StatefulWidget {
  Post post;

  PostItem(this.post);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool? isUserLoggedIn;

  late PostBloc _postBloc = PostBloc();

  @override
  void initState() {
    isUserLoggedIn = context.read<SettingBloc>().state.isUserLoggedIn;
    widget.post.voteDown = widget.post.currentUserDownVotes;
    widget.post.voteUp = widget.post.currentUserUpVotes;
    super.initState();
  }

  @override
  void dispose() {
    _postBloc.close();
    super.dispose();
  }

  double measureTextHeight(
      String text, TextStyle style, int maxLines, double width) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width);
    return textPainter.size.height;
  }

  @override
  Widget build(BuildContext context) {
    var badgePosition = badges.BadgePosition.topEnd(end: -12, top: -2);

    return BlocProvider(
      create: (context) => _postBloc,
      child: Builder(builder: (context) {
        return BlocConsumer<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostUpdate) {
              setState(() {
                widget.post = state.post;
              });
            }
          },
          builder: (context, state) {
            return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.postDetailed,
              arguments: <String, dynamic>{
                'post': widget.post,
                'postId': widget.post.id,
                'postBloc': _postBloc,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 16),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (isUserLoggedIn != true) {
                      Navigator.of(context).pushNamed(AppRoutes.login);
                    }else {
                      if (BlocProvider
                          .of<SettingBloc>(context)
                          .state
                          .profile
                          ?.globalId == widget.post.creator?.globalId) {
                        Navigator.of(context).pushNamed(AppRoutes.myProfile);
                      } else {
                        Navigator.of(context).pushNamed(AppRoutes.profile,
                            arguments: widget.post.creator?.globalId);
                      }
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
                                if(widget.post.creator?.username != null && widget.post.creator!.username!.isNotEmpty && widget.post.creator?.username != '@')Flexible(
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
                      BlocConsumer<PostBloc, PostState>(
                        listener: (context, state) {
                          if (state is InterestSuccessState) {
                            widget.post.currentUserLiked =
                                !widget.post.currentUserLiked;

                            widget.post.isLiked = widget.post.currentUserLiked;
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
                                  if (isUserLoggedIn == true) {
                                    BlocProvider.of<PostBloc>(context).add(
                                        AddToInterestEvent(widget.post.id));
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
                              if(BlocProvider.of<SettingBloc>(context).state.profile?.globalId != widget.post.creator?.globalId)PopupMenuItem(
                                onTap: () {
                                  widget.post.isNotificationEnabled =
                                      !widget.post.isNotificationEnabled;
                                  setState(() {});
                                  if (isUserLoggedIn == true) {
                                    BlocProvider.of<PostBloc>(context).add(
                                        EnableNotificationEvent(
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
                                      color:
                                          Theme.of(context).colorScheme.shadow,
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
                SizedBox(height: 16),
                if (widget.post.medias != null && widget.post.medias!.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(bottom: 16),
                    child: MediaLoader(medias: widget.post.medias),
                  ),
                Row(
                  children: [
                    Directionality(
                      textDirection: detectDirection(widget.post.name),
                      child: Expanded(
                        child: Text(
                          '${widget.post.name}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).colorScheme.shadow,
                            fontFamily: 'IRANSansX',
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Directionality(
                  textDirection: detectDirection(widget.post.description),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final style = Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              color: Theme.of(context).colorScheme.shadow,
                              fontWeight: FontWeight.w500,
                              height: 1.5);
                      final textHeight = measureTextHeight(
                        widget.post.description ?? '',
                        style,
                        2,
                        constraints.maxWidth,
                      );
                      return Stack(
                        children: [
                          Container(
                            width: constraints.maxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.description ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: style,
                                ),
                                if (textHeight > style.fontSize! * 2)
                                  SizedBox(height: style.fontSize! * 2),
                              ],
                            ),
                          ),
                          if (textHeight > style.fontSize! * 2)
                            Container(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.bottomCenter,
                              width: constraints.maxWidth,
                              height: style.fontSize! * 5 + 10,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .background
                                        .withOpacity(0.3),
                                    Theme.of(context).colorScheme.background,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsetsDirectional.zero,
                                    height: 31,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          AppRoutes.postDetailed,
                                          arguments: <String, dynamic>{
                                            'post': widget.post,
                                            'postId': widget.post.id,
                                          },
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translateNested(
                                                'postScreen', 'show_more'),
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 16,
                            width: 26,
                            child: SvgPicture.asset(
                              'assets/images/post/eye.svg',
                              color: Theme.of(context).colorScheme.shadow,
                            ),
                          ),
                          Text(
                            '${widget.post.viewCountString}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color:
                              Theme.of(context).colorScheme.shadow.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.postDetailed,
                                arguments: <String, dynamic>{
                                  'post': widget.post,
                                  'postId': widget.post.id,
                                },
                              );
                            },
                            icon: badges.Badge(
                              badgeStyle: badges.BadgeStyle(
                                shape: badges.BadgeShape.circle,
                                badgeColor: Theme.of(context).primaryColor,
                                padding: EdgeInsets.all(2),
                                elevation: 0,
                              ),
                              position: badgePosition,
                              badgeContent: Container(
                                padding: EdgeInsetsDirectional.only(top: 3),
                                height: 20,
                                width: 20,
                                child: Text(
                                  widget.post.commentsCountString,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(vertical: 2),
                                child: FaIcon(
                                    size: 30,
                                    FontAwesomeIcons.thinComment,
                                    color: Theme.of(context).colorScheme.shadow),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                widget.post.voteDown = !widget.post.voteDown;
                                if (widget.post.voteDown == true)
                                  widget.post.downVotes = widget.post.downVotes! + 1;
                                else
                                  widget.post.downVotes = widget.post.downVotes! - 1;
                                if (widget.post.voteUp == true) {
                                  widget.post.voteUp = false;
                                  widget.post.upVotes = widget.post.upVotes! - 1;
                                }
                              });
                              if (isUserLoggedIn == true) {
                                BlocProvider.of<PostBloc>(context)
                                    .add(UserVoteDownEvent(widget.post.id, 'down'));
                              } else {
                                BlocProvider.of<PostBloc>(context).saveDisLikeRequest(widget.post.id, 'down');

                                Navigator.of(context).pushNamed(AppRoutes.login);
                              }
                            },
                            icon: BlocListener<PostBloc, PostState>(
                              listener: (context, state) {
                                if (state is UserVoteDownSuccessState) {
                                  widget.post.currentUserDownVotes =
                                  !widget.post.currentUserDownVotes;
                                  widget.post.currentUserUpVotes = false;
                                }
                                widget.post.voteDown = widget.post.currentUserDownVotes;
                                widget.post.voteUp = widget.post.currentUserUpVotes;
                                setState(() {});
                              },
                              child: badges.Badge(
                                badgeStyle: badges.BadgeStyle(
                                  shape: badges.BadgeShape.circle,
                                  badgeColor: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.all(2),
                                  elevation: 0,
                                ),
                                position: badgePosition,
                                badgeContent: Container(
                                  padding: EdgeInsetsDirectional.only(top: 3),
                                  height: 20,
                                  width: 20,
                                  child: Text(
                                    widget.post.downVotesString,
                                    overflow: TextOverflow.fade,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    widget.post.voteDown == true
                                        ? FaIcon(
                                        size: 30,
                                        FontAwesomeIcons.solidThumbsDown,
                                        color: Theme.of(context).colorScheme.shadow)
                                        : FaIcon(
                                        size: 30,
                                        FontAwesomeIcons.thinThumbsDown,
                                        color: Theme.of(context).colorScheme.shadow),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                widget.post.voteUp = !widget.post.voteUp;
                                if (widget.post.voteUp == true)
                                  widget.post.upVotes = widget.post.upVotes! + 1;
                                else
                                  widget.post.upVotes = widget.post.upVotes! - 1;
                                if (widget.post.voteDown == true){
                                  widget.post.downVotes = widget.post.downVotes! - 1;
                                  widget.post.voteDown = false;
                                }
                              });
                              if (isUserLoggedIn == true) {
                                BlocProvider.of<PostBloc>(context)
                                    .add(UserVoteUpEvent(widget.post.id, 'up', ));
                              } else {
                                BlocProvider.of<PostBloc>(context).saveLikeRequest(widget.post.id, 'up');

                                Navigator.of(context).pushNamed(AppRoutes.login);
                              }
                            },
                            icon: BlocListener<PostBloc, PostState>(
                              listener: (context, state) {
                                if (state is UserVoteUpSuccessState) {
                                  widget.post.currentUserUpVotes =
                                  !widget.post.currentUserUpVotes;

                                  widget.post.currentUserDownVotes = false;
                                }
                                widget.post.voteUp = widget.post.currentUserUpVotes;
                                widget.post.voteDown = widget.post.currentUserDownVotes;
                                setState(() {});
                              },
                              child: badges.Badge(
                                badgeStyle: badges.BadgeStyle(
                                  shape: badges.BadgeShape.circle,
                                  badgeColor: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.all(2),
                                  elevation: 0,
                                ),
                                position: badgePosition,
                                badgeContent: Container(
                                  padding: EdgeInsetsDirectional.only(top: 3),
                                  height: 20,
                                  width: 20,
                                  child: Text(
                                    widget.post.upVotesString,
                                    overflow: TextOverflow.fade,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    widget.post.voteUp == true
                                        ? FaIcon(
                                        size: 30,
                                        FontAwesomeIcons.solidThumbsUp,
                                        color: Theme.of(context).colorScheme.shadow)
                                        : FaIcon(
                                        size: 30,
                                        FontAwesomeIcons.thinThumbsUp,
                                        color: Theme.of(context).colorScheme.shadow),
                                    SizedBox(height: 4),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 5),
                  child: Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .shadow
                              .withOpacity(0.02),
                          Theme.of(context).colorScheme.shadow.withOpacity(0.1),
                          Theme.of(context)
                              .colorScheme
                              .shadow
                              .withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  },
);
      }),
    );
  }
}
