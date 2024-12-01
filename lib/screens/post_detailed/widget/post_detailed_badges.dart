import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/configs/localization/app_localizations.dart';
import 'package:social_psn/configs/setting/themes.dart';

import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/models/post.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/custom_snackbar.dart';
import '../post_detailed_bloc.dart';
import 'comment_bottom_sheet.dart';

class PostDetailedBadges extends StatefulWidget {
  Post post;
  bool? isUserLoggedIn;

  PostDetailedBadges(this.post, this.isUserLoggedIn);

  @override
  State<PostDetailedBadges> createState() => _PostDetailedBadgesState();
}

class _PostDetailedBadgesState extends State<PostDetailedBadges> {
  bool? isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    isUserLoggedIn = context.read<SettingBloc>().state.isUserLoggedIn;
    widget.post.voteDown = widget.post.currentUserDownVotes;
    widget.post.voteUp = widget.post.currentUserUpVotes;
  }

  void submitComment(String postId, String message, [String? replyId]) {
    BlocProvider.of<PostDetailedBloc>(context).add(CreateCommentEvent(
      postId: postId,
      message: message,
      replyId: replyId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var badgePosition = badges.BadgePosition.topEnd(end: -12, top: -2);

    return Row(
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
                if (BlocProvider.of<SettingBloc>(context).state.hasUsername) {
                  final postDetailedBloc =
                      BlocProvider.of<PostDetailedBloc>(context);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => BlocProvider.value(
                      value: postDetailedBloc,
                      child: CommentBottomSheet(
                          function: submitComment, postId: widget.post.id),
                    ),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    isDismissible: true,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar(
                            content: AppLocalizations.of(context)!
                                .translateNested('postScreen', 'setUsername'))
                        .build(context),
                  );
                }
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
                  child: BlocListener<PostDetailedBloc, PostDetailedState>(
                    listener: (context, state) {
                      if (state is CommentCountRefresh) {
                        setState(() {
                          widget.post.commentsCount =
                              widget.post.commentsCount! + 1;
                        });
                      }
                    },
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
                  print(widget.post.voteDown);
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
                  BlocProvider.of<PostDetailedBloc>(context)
                      .add(UserVoteDownEvent(widget.post.id, 'down'));
                } else {
                  Navigator.of(context).pushNamed(AppRoutes.login);
                }
              },
              icon: BlocListener<PostDetailedBloc, PostDetailedState>(
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
                  BlocProvider.of<PostDetailedBloc>(context)
                      .add(UserVoteUpEvent(widget.post.id, 'up'));
                } else {
                  Navigator.of(context).pushNamed(AppRoutes.login);
                }
              },
              icon: BlocListener<PostDetailedBloc, PostDetailedState>(
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
    );
  }
}
