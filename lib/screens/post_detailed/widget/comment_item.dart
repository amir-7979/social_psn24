import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/screens/post_detailed/widget/comment_bottom_sheet.dart';
import 'package:social_psn/screens/post_detailed/widget/reply_item.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/models/comment.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/TrianglePainter.dart';
import '../../widgets/profile_cached_network_image.dart';
import '../post_detailed_bloc.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final String postId;

  CommentItem(this.comment, this.postId);

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool? isUserLoggedIn;

  @override
  void initState() {
    isUserLoggedIn = context.read<SettingBloc>().state.isUserLoggedIn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void submitComment(String postId, String message, [String? replyId]) {
      BlocProvider.of<PostDetailedBloc>(context).add(CreateCommentEvent(
        postId: postId,
        message: message,
        replyId: replyId,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                if (isUserLoggedIn != true) {
                  Navigator.of(context).pushNamed(AppRoutes.login);
                }else {
                  if (BlocProvider
                      .of<SettingBloc>(context)
                      .state
                      .profile
                      ?.globalId == widget.comment.sender?.globalId) {
                    Navigator.of(context).pushNamed(AppRoutes.myProfile);
                  } else {
                    Navigator.of(context).pushNamed(AppRoutes.profile,
                        arguments: widget.comment.sender?.globalId);
                  }
                }
              },
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: Size.fromRadius(20), // Image radius
                  child: widget.comment.sender?.photo != null
                      ? ProfileCacheImage(widget.comment.sender?.photo)
                      : SvgPicture.asset('assets/images/drawer/profile2.svg'),
                ),
              ),
            ),
            SizedBox(width: 8),
            Padding(
              padding: EdgeInsetsDirectional.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //rectangular container
                  CustomPaint(
                    size: Size(10, 10), // Specify your size
                    painter: TrianglePainter(
                      strokeColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      strokeWidth: 10,
                      paintingStyle: PaintingStyle.fill,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 122,
                    constraints: BoxConstraints(
                      minHeight: 80,
                    ),
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(0),
                        topEnd: Radius.circular(8),
                        bottomEnd: Radius.circular(8),
                        bottomStart: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Wrapping entire name and username in Flexible
                            Flexible(
                              child: Row(
                                children: [
                                  // Name and family with Flexible
                                  Flexible(
                                    child: Text(
                                      '${widget.comment.sender?.name} ${widget.comment.sender?.family}',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                        color: Theme.of(context).colorScheme.shadow,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  if (widget.comment.sender?.username != null)
                                    Text(
                                      '(${widget.comment.sender?.username})',
                                      textDirection: TextDirection.ltr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: 3),
                            SvgPicture.asset(
                              'assets/images/profile/calendar.svg',
                              width: 10,
                              height: 12,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '${widget.comment.persianDate ?? ''}',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.comment.message?.trim() ?? '',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.shadow,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                final postDetailedBloc =
                                    BlocProvider.of<PostDetailedBloc>(context);

                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => BlocProvider.value(
                                    value: postDetailedBloc,
                                    child: CommentBottomSheet(
                                        function: submitComment,
                                        postId: widget.postId,
                                        replyTo: widget.comment.id),
                                  ),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  isDismissible: true,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    bottom: 8, end: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.thinShare,
                                      color: Theme.of(context).primaryColor,
                                      size: 18,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translateNested(
                                              "postScreen", "reply"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //SizedBox(width: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        //for reply in comment , create repliitem
        if (widget.comment.replies != null && widget.comment.replies!.isNotEmpty)
          for (var reply in widget.comment.replies!) ReplyItem(reply),
      ],
    );
  }
}
