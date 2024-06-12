import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../configs/consts.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/post.dart';
import '../../main/main_bloc.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/profile_cached_network_image.dart';
import '../home_bloc.dart';

class PostItem extends StatefulWidget {
  final Post post;

  PostItem(this.post);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool? isUserLoggedIn;
  bool? isLiked;
  bool? isNotificationEnabled;

  @override
  void initState() {
    isUserLoggedIn = context.read<SettingBloc>().state.isUserLoggedIn;
    isLiked = widget.post.currentUserLiked;
    isNotificationEnabled = widget.post.currentUserNotificationEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(25), // Image radius
                child: widget.post.creator?.photo != null
                    ? ProfileCacheImage(widget.post.creator?.photo)
                    : SvgPicture.asset('assets/images/drawer/profile2.svg'),
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
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.shadow,
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
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${widget.post.creator?.displayName}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.surface,
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is InterestSuccessState) {
                  widget.post.currentUserLiked = !widget.post.currentUserLiked!;
                  print(widget.post.currentUserLiked);
                  isLiked = widget.post.currentUserLiked;
                }else if(state is InterestFailureState){
                  isLiked = !isLiked!;
                }else if(state is NotificationSuccessState){
                  widget.post.currentUserNotificationEnabled = !widget.post.currentUserNotificationEnabled!;
                  isNotificationEnabled = widget.post.currentUserNotificationEnabled;
                }else if(state is NotificationFailureState){
                  isNotificationEnabled = !isNotificationEnabled!;
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
                        isLiked = !isLiked!;
                        setState(() {});
                        if(isUserLoggedIn == true){
                          BlocProvider.of<HomeBloc>(context).add(AddToInterestEvent(widget.post.id));
                        }else{
                          BlocProvider.of<MainBloc>(context).add(AuthenticationClicked());
                        }
                      },
                      value: 1,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            child: SvgPicture.asset(
                              'assets/images/post/heart.svg',
                              height: 20,
                              width: 20,
                              color: isLiked??false ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.shadow,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!
                                .translateNested("postScreen", isLiked??false ? "delete_interest" : "interest"),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.shadow,
                                ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        isNotificationEnabled = !isNotificationEnabled!;
                        setState(() {});
                        if(isNotificationEnabled == true){
                          BlocProvider.of<HomeBloc>(context).add(EnableNotificationEvent(widget.post.id));
                        }else{
                          BlocProvider.of<MainBloc>(context).add(AuthenticationClicked());
                        }
                      },
                      value: 2,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/post/bell.svg',
                            height: 20,
                            width: 20,
                            color: isNotificationEnabled??false ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.shadow,
                          ),
                          SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!
                                .translateNested("postScreen", isNotificationEnabled??false ? "delete_notification" : "notification"),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.shadow,
                                ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        FlutterClipboard.copy(inviteLink).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                function: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                                content: AppLocalizations.of(context)!.translateNested('drawer', 'invite'),
                                backgroundColor: Theme.of(context).primaryColor
                            ).build(context),
                          );                          });

                      },
                      value: 3,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/post/share.svg',
                            height: 20,
                            width: 20,
                            color: Theme.of(context).colorScheme.shadow,
                          ),
                          SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!
                                .translateNested("postScreen", "share"),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.shadow,
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
        Row(
          children: [
            Container(height: 200),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                '${widget.post.name}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.shadow,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${widget.post.description}',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.shadow,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
        SizedBox(height: 16),

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
                    height: 20,
                    width: 30,
                    child: SvgPicture.asset(
                      'assets/images/post/eye.svg',
                      color: Theme.of(context).colorScheme.shadow,
                    ),
                  ),
                  Text(
                    '${widget.post.viewCount}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).hoverColor,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(
                        'assets/images/post/comment.svg',
                        color: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(
                        'assets/images/post/dislike.svg',
                        color: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: SizedBox(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(
                        'assets/images/post/like.svg',
                        color: Theme.of(context).colorScheme.shadow,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
