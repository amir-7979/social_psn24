import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/configs/setting/themes.dart';
import 'package:badges/badges.dart' as badges;
import '../../configs/consts.dart';
import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/creator.dart';
import '../../repos/models/post.dart';
import '../main/main_bloc.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/media_loader.dart';
import '../widgets/profile_cached_network_image.dart';
import 'post_bloc.dart';
import 'widget/comment_item.dart';

class PostDetailed extends StatefulWidget {
  final Post post = Post(
      id: '1',
      name:
          'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است.',
      description:
          'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است. چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد. کتابهای زیادی در شصت و سه درصد گذشته، حال و آینده شناخت فراوان جامعه و متخصصان را می طلبد تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی و فرهنگ پیشرو در زبان فارسی ایجاد کرد. در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها و شرایط سخت تایپ به پایان رسد وزمان مورد نیاز شامل حروفچینی دستاوردهای اصلی و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.',
      creator: Creator(
          name: 'name',
          family: 'family',
          username: 'username',
          displayName: 'displayName'),
      persianDate: '1399/01/01',
      viewCount: 100,
      voteUp: false,
      voteDown: false,
      currentUserUpVotes: false,
      currentUserDownVotes: false,
      currentUserLiked: false,
      currentUserNotificationEnabled: false,
      isLiked: false,
      isNotificationEnabled: false,
      medias: []);
  final Function changeIndex;

  PostDetailed(this.changeIndex);

  @override
  State<PostDetailed> createState() => _PostDetailedState();
}

class _PostDetailedState extends State<PostDetailed> {
  bool? isUserLoggedIn;
  late PostBloc _postBloc = PostBloc();

  @override
  void initState() {
    isUserLoggedIn = context.read<SettingBloc>().state.isUserLoggedIn;
    super.initState();
  }

  @override
  void dispose() {
    _postBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var badgePosition = badges.BadgePosition.topEnd(end: -15, top: -2);


    return BlocProvider(
      create: (context) => PostBloc(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: SizedBox.fromSize(
                  size: Size.fromRadius(24), // Image radius
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
                                  color: Theme.of(context).colorScheme.tertiary,
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.surface,
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
                    print(widget.post.currentUserLiked);
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
                            BlocProvider.of<PostBloc>(context)
                                .add(AddToInterestEvent(widget.post.id));
                          } else {
                            BlocProvider.of<MainBloc>(context)
                                .add(AuthenticationClicked());
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
                                    color: Theme.of(context).colorScheme.error)
                                : FaIcon(
                                    size: 20,
                                    FontAwesomeIcons.lightHeart,
                                    color:
                                        Theme.of(context).colorScheme.shadow),
                            SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.translateNested(
                                  "postScreen",
                                  widget.post.isLiked ?? false
                                      ? "delete_interest"
                                      : "interest"),
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
                          widget.post.isNotificationEnabled =
                              !widget.post.isNotificationEnabled;
                          setState(() {});
                          if (isUserLoggedIn == true) {
                            BlocProvider.of<PostBloc>(context)
                                .add(EnableNotificationEvent(widget.post.id));
                          } else {
                            BlocProvider.of<MainBloc>(context)
                                .add(AuthenticationClicked());
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
                                    color: Theme.of(context).colorScheme.error)
                                : FaIcon(
                                    size: 20,
                                    FontAwesomeIcons.lightBell,
                                    color:
                                        Theme.of(context).colorScheme.shadow),
                            SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.translateNested(
                                  "postScreen",
                                  widget.post.isNotificationEnabled ?? false
                                      ? "delete_notification"
                                      : "notification"),
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
                                      function: () =>
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar(),
                                      content: AppLocalizations.of(context)!
                                          .translateNested('drawer', 'invite'),
                                      backgroundColor:
                                          Theme.of(context).primaryColor)
                                  .build(context),
                            );
                          });
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
          widget.post.medias == null || widget.post.medias!.isEmpty
              ? SizedBox(height: 40)
              : Padding(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
                  child: MediaLoader(medias: widget.post.medias),
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
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            widget.post.description ?? '',
            maxLines: null,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.shadow, height: 1.5),
          ),
          SizedBox(height: 24),
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
                      '${widget.post.viewCount}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .shadow
                                .withOpacity(0.6),
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
                        print('comment');
                      },
                      icon: badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.circle,
                          badgeColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(2),
                          elevation: 0,
                        ),
                        position:
                            badgePosition,
                        badgeContent: Container(
                          padding: EdgeInsetsDirectional.only(top: 3),
                          height: 20,
                          width: 20,
                          child: Text(
                            (widget.post.commentsCount??0).toString(),
                            overflow: TextOverflow.fade,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
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
                              color:
                              Theme.of(context).colorScheme.shadow),
                        )
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        widget.post.voteDown =
                            widget.post.voteDown == false ? true : false;
                        widget.post.voteUp = false;
                        setState(() {});
                        if (isUserLoggedIn == true) {
                          BlocProvider.of<PostBloc>(context)
                              .add(UserVoteDownEvent(widget.post.id, 'down'));
                        } else {
                          BlocProvider.of<MainBloc>(context)
                              .add(AuthenticationClicked());
                        }
                      },
                      icon: BlocListener<PostBloc, PostState>(
                        listener: (context, state) {
                          if (state is UserVoteDownSuccessState) {
                            widget.post.currentUserDownVotes =
                                !widget.post.currentUserDownVotes;
                            widget.post.currentUserUpVotes = false;
                          }
                          widget.post.voteDown =
                              widget.post.currentUserDownVotes;
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
                          position:
                              badgePosition,
                          badgeContent: Container(
                            padding: EdgeInsetsDirectional.only(top: 3),
                            height: 20,
                            width: 20,
                            child: Text(
                              (widget.post.downVotes??0).toString(),
                              overflow: TextOverflow.fade,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
                                      color: Theme.of(context).colorScheme.error)
                                  : FaIcon(
                                      size: 30,
                                      FontAwesomeIcons.thinThumbsDown,
                                      color:
                                          Theme.of(context).colorScheme.shadow),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.post.voteUp =
                              widget.post.voteUp == false ? true : false;
                          widget.post.voteDown = false;
                        });
                        if (isUserLoggedIn == true) {
                          BlocProvider.of<PostBloc>(context)
                              .add(UserVoteUpEvent(widget.post.id, 'up'));
                        } else {
                          BlocProvider.of<MainBloc>(context)
                              .add(AuthenticationClicked());
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
                          widget.post.voteDown =
                              widget.post.currentUserDownVotes;
                          setState(() {});
                        },
                        child: badges.Badge(
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.circle,
                            badgeColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.all(2),
                            elevation: 0,
                          ),
                          position:
                              badgePosition,
                          badgeContent: Container(
                            padding: EdgeInsetsDirectional.only(top: 3),
                            height: 20,
                            width: 20,
                            child: Text(
                              (widget.post.upVotes??0).toString(),
                              overflow: TextOverflow.fade,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
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
                                      color: Theme.of(context).colorScheme.error)
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
          SizedBox(height: 24),
          CommentItem(),
        ],
      ),
    );
  }
}
