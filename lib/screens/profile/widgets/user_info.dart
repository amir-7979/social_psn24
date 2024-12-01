import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/configs/setting/themes.dart';
import 'package:social_psn/screens/main/widgets/screen_builder.dart';
import 'package:social_psn/screens/profile/profile_bloc.dart';

import '../../../configs/consts.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/models/profile.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/profile_cached_network_image.dart';
import '../../widgets/white_circular_progress_indicator.dart';
import 'shimmer/shimmer_user_info.dart';

class UserInfo extends StatefulWidget {
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> with TickerProviderStateMixin {
  bool _isInfoExpanded = false;
  bool _isActivitiesExpanded = false;
  late AnimationController _activitiesController;
  late AnimationController _infoController;
  late Animation<double> _infoAnimation;
  late Animation<double> _activitiesAnimation;
  final advanceSwitchController = ValueNotifier<bool>(false);
  int? profileId;
  bool isContent = true;

  @override
  void initState() {
    super.initState();
    _activitiesController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _activitiesAnimation = CurvedAnimation(
      parent: _activitiesController,
      curve: Curves.easeInOut,
    );
    _infoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _infoAnimation = CurvedAnimation(
      parent: _infoController,
      curve: Curves.easeInOut,
    );

  }

  @override
  void didChangeDependencies() {
    profileId = ModalRoute.of(context)?.settings.arguments as int?;
    if(profileId != null){context.read<ProfileBloc>().add(FetchProfileEvent(id: profileId));}else{
      context.read<ProfileBloc>().add(FetchMyProfileEvent());

    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _infoController.dispose();
    _activitiesController.dispose();
    advanceSwitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(content: state.message).build(context),
          );
        } else if (state is ToggleNotificationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(content: state.message).build(context),
          );
        }
      },
      buildWhen: (previous, current) {
        return current is ProfileInfoLoaded ||
            current is ProfileInfoLoading ||
            current is ProfileError;
      },
      builder: (context, state) {
        if (state is ProfileInfoLoading) {
          return ShimmerUserInfo(id: profileId);
        } else if (state is ProfileError) {
          return Container(
            height: 250,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Center(
              child: Text(
                state.message,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
          );
        } else if (state is ProfileInfoLoaded) {
          context.read<ProfileBloc>().add(FetchMyActivityEvent(id: state.profile.globalId));
          return buildBody(context, state.profile, profileId);
        } else {
          return Container(
            height: 250,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.background,
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!
                    .translateNested("profileScreen", "fetchError"),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildBody(BuildContext context, Profile profile, profileId) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      padding: EdgeInsetsDirectional.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          ClipOval(
                            child: (profile.photo != null)
                                ? FittedBox(
                                    fit: BoxFit.cover,
                                    child: Container(
                                        child:
                                            ProfileCacheImage(profileId != null ? MediaLink + profile.photo! : profile.photo)),
                                  )
                                : SvgPicture.asset(
                                    'assets/images/profile/profile2.svg'),
                          ),
                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              profile.showActivity =
                                  state is ChangeOnlineStatusSucceed
                                      ? state.status
                                      : profile.showActivity;
                              return profileId == null &&
                                      (profile.showActivity == 1)
                                  ? Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 7, top: 7),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: Container(
                                          height: 15,
                                          width: 15,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                          padding:
                                              EdgeInsetsDirectional.all(2.5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    if (profileId != null &&
                        profile.currentUserNotificationEnabled != null)
                      Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 5),
                          child: Container(
                            padding: EdgeInsetsDirectional.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            child: BlocConsumer<ProfileBloc, ProfileState>(
                              listenWhen: (previous, current) {
                                print(current);
                                return current is ToggleNotificationSuccess;
                              },
                              listener: (context, state) {
                                profile.currentUserNotificationEnabled = profile.currentUserNotificationEnabled == 1 ? 0 : 1;
                              },
                              buildWhen: (previous, current) {
                                return current is ToggleNotificationSuccess ||
                                    current is ToggleNotificationFailure ||
                                    current is TogglingNotificationState;
                              },
                              builder: (context, state) {
                                return Container(
                                  width: 35,
                                  height: 35,
                                  padding: EdgeInsetsDirectional.zero,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        profile.currentUserNotificationEnabled ==
                                                1
                                            ? Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                            : cameraBackgroundColor,
                                  ),
                                  child: state is TogglingNotificationState
                                      ? Padding(
                                          padding:
                                              const EdgeInsetsDirectional.all(
                                                  8.0),
                                          child:
                                              WhiteCircularProgressIndicator(),
                                        )
                                      : Center(
                                          child: IconButton(
                                            padding: EdgeInsetsDirectional.zero,
                                            icon:
                                                profile.currentUserNotificationEnabled ==
                                                        1
                                                    ? FaIcon(
                                                        size: 20,
                                                        FontAwesomeIcons
                                                            .solidBellOn,
                                                        color: whiteColor)
                                                    : FaIcon(
                                                        size: 20,
                                                        FontAwesomeIcons
                                                            .lightBellPlus,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiary),
                                            onPressed: () {
                                              BlocProvider.of<ProfileBloc>(
                                                      context)
                                                  .add(ToggleNotificationEvent(
                                                      profileId));
                                            },
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${profile.name} ${profile.family}",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).hoverColor,
                        ),
                  ),
                  if (profile.displayName != null &&
                      profile.displayName!.isNotEmpty)
                    SizedBox(height: 8),
                  if (profile.displayName != null &&
                      profile.displayName!.isNotEmpty)
                    Text(
                      "(${profile.displayName})",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                  SizedBox(height: 10),
                  // i want to show switch button here
                  if (profileId == null && BlocProvider.of<SettingBloc>(context)
                      .state
                      .canChangeOnlineStatus)
                    AdvancedSwitch(
                            initialValue: profile.showActivity == 1,
                            controller: advanceSwitchController,
                            thumb: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  2, 2, 0, 2),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: whiteColor,
                                ),
                              ),
                            ),
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: Theme.of(context).hintColor,
                            height: 28,
                            width: 75,
                            inactiveChild: Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translateNested("profileScreen", "online"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                            activeChild: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 10),
                              child: Text(
                                AppLocalizations.of(context)!.translateNested(
                                    "profileScreen", "offline"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.shadow,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                            onChanged: (value) {

                              BlocProvider.of<ProfileBloc>(context)
                                  .add(ChangeStatusEvent(status: value, name: profile.name??'', family: profile.family??''));

                            },
                          ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.all(16),
            child: buildSeparator(context),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isActivitiesExpanded = !_isActivitiesExpanded;
                if (_isActivitiesExpanded) {
                  _activitiesController.forward();
                } else {
                  _activitiesController.reverse();
                }
              });
            },
            iconAlignment: IconAlignment.end,
            icon: RotationTransition(
              turns: _activitiesAnimation,
              child: _isActivitiesExpanded
                  ? Icon(Icons.expand_less,
                      color: Theme.of(context).colorScheme.shadow)
                  : Icon(Icons.expand_more,
                      color: Theme.of(context).colorScheme.shadow),
            ),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return Colors.transparent;
                },
              ),
            ),
            label: Text(
              AppLocalizations.of(context)!
                  .translateNested("profileScreen", "myInfo"),
              style: iranYekanTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.shadow),
              textDirection: TextDirection.rtl,
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isActivitiesExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      if (profile.username != '')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translateNested("params", "username"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            Text(
                              '@${profile.username}',
                              textDirection: TextDirection.ltr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      if (profile.username != '') SizedBox(height: 16),
                      if (profile.field != null && profile.field != '')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translateNested("profileScreen", "field"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            Text(
                              profile.field ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      if (profile.field != null && profile.field != '')
                        SizedBox(height: 16),
                      if (profile.experience != null &&
                          profile.experience != '')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translateNested("params", "experience"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            Text(
                              profile.experience ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      if (profile.experience != null &&
                          profile.experience != '')
                        SizedBox(height: 16),
                      if (profile.biography != null && profile.biography != '')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translateNested("params", "biography"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              profile.biography ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      if (profile.biography != null && profile.biography != '')
                        SizedBox(height: 16),
                      if (profile.address != null && profile.address != '')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translateNested("profileScreen", "address"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              profile.address ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      if (profile.address != null && profile.address != '')
                        SizedBox(height: 16),
                      if (profile.offices != null &&
                          profile.offices!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translateNested("params", "offices"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                            for (var office in profile.offices!)
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(top: 8),
                                child: Text(
                                  office,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          Padding(
            padding: EdgeInsetsDirectional.all(16),
            child: buildSeparator(context),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isInfoExpanded = !_isInfoExpanded;
                if (_isInfoExpanded) {
                  _infoController.forward();
                } else {
                  _infoController.reverse();
                }
              });
            },
            iconAlignment: IconAlignment.end,
            icon: RotationTransition(
              turns: _infoAnimation,
              child: _isInfoExpanded
                  ? Icon(Icons.expand_less,
                      color: Theme.of(context).colorScheme.shadow)
                  : Icon(Icons.expand_more,
                      color: Theme.of(context).colorScheme.shadow),
            ),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return Colors.transparent;
                },
              ),
            ),
            label: Text(
              AppLocalizations.of(context)!
                  .translateNested("profileScreen", "activities"),
              style: iranYekanTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.shadow),
              textDirection: TextDirection.rtl,
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isInfoExpanded
                ? profileId != null
                    ? Column(
                        children: [
                          Container(
                            padding:
                                EdgeInsetsDirectional.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translateNested(
                                      "profileScreen", "posts"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                                Text(
                                  profile.contentCreated.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          buildSeparator(context),
                          Container(
                            padding:
                                EdgeInsetsDirectional.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translateNested(
                                      "profileScreen", "comments"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                                Text(
                                  profile.commentsCreated.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          buildSeparator(context),
                          Container(
                            padding:
                                EdgeInsetsDirectional.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translateNested(
                                      "profileScreen", "agreeVotes"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                                Text(
                                  profile.upvotes.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          buildSeparator(context),
                          Container(
                            padding:
                                EdgeInsetsDirectional.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translateNested(
                                      "profileScreen", "disagreeVotes"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                                Text(
                                  profile.downvotes.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : BlocBuilder<ProfileBloc, ProfileState>(
                        buildWhen: (previous, current) {
                          return current is activitySuccessState ||
                              current is activityFailureState;
                        },
                        builder: (context, state) {
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translateNested(
                                              "profileScreen", "posts"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Theme.of(context).hoverColor,
                                          ),
                                    ),
                                    if (state is activitySuccessState)
                                      Text(
                                        state.activity['contentCreated']
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color:
                                                  Theme.of(context).hoverColor,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              buildSeparator(context),
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translateNested(
                                              "profileScreen", "comments"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Theme.of(context).hoverColor,
                                          ),
                                    ),
                                    if (state is activitySuccessState)
                                      Text(
                                        state.activity['commentsCreated']
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color:
                                                  Theme.of(context).hoverColor,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              buildSeparator(context),
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translateNested(
                                              "profileScreen", "agreeVotes"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Theme.of(context).hoverColor,
                                          ),
                                    ),
                                    if (state is activitySuccessState)
                                      Text(
                                        state.activity['upvotes'].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color:
                                                  Theme.of(context).hoverColor,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              buildSeparator(context),
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translateNested(
                                              "profileScreen", "disagreeVotes"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Theme.of(context).hoverColor,
                                          ),
                                    ),
                                    if (state is activitySuccessState)
                                      Text(
                                        state.activity['downvotes'].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color:
                                                  Theme.of(context).hoverColor,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      )
                : SizedBox.shrink(),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      //surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      //foregroundColor: Theme.of(context).colorScheme.tertiary,
                      backgroundColor: Color(0x3300A6ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isContent
                              ? Theme.of(context).colorScheme.tertiary
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<ProfileBloc>(context)
                          .add(ChangeToPostEvent());
                      setState(() {
                        isContent = true;
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .translateNested("bottomBar", "content"),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      //surfaceTintColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      //foregroundColor: Theme.of(context).colorScheme.tertiary,
                      backgroundColor: Color(0x3300A6ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isContent
                              ? Colors.transparent
                              : Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<ProfileBloc>(context)
                          .add(ChangeToCommentEvent());
                      setState(() {
                        isContent = false;
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .translateNested("profileScreen", "comments"),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (profileId == null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shadowColor: Colors.transparent,
                //foregroundColor: Theme.of(context).colorScheme.tertiary,
                backgroundColor: Color(0x3300A6ED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.editProfile,
                    arguments: profile);
              },
              child: Text(
                AppLocalizations.of(context)!
                    .translateNested("profileScreen", "editUserInfo"),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Container buildSeparator(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface.withOpacity(0),
            Theme.of(context).colorScheme.surface.withOpacity(01),
            Theme.of(context).colorScheme.surface.withOpacity(0),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
