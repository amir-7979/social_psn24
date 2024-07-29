import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/configs/setting/themes.dart';
import 'package:social_psn/screens/main/widgets/screen_builder.dart';
import 'package:social_psn/screens/profile/profile_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/models/profile.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/profile_cached_network_image.dart';
import 'shimmer/shimmer_user_info.dart';

class UserInfo extends StatefulWidget {
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late AnimationController _controller;
  final advanceSwitchController = ValueNotifier<bool>(false);
  late Animation<double> _animation;
  Widget? _lastWidget;
  bool _checked = false;
  bool _isProfileFetched = false;
  int? profileId;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.addListener(() {
      setState(() {
        _checked = advanceSwitchController.value;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isProfileFetched) {
      profileId = ModalRoute.of(context)?.settings.arguments as int?;
      context.read<ProfileBloc>().add(FetchProfile(id: profileId));
      _isProfileFetched = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
        }
      },
      builder: (context, state) {
        Widget? currentWidget = infoWidget(context, state, profileId);
        if (currentWidget != null && currentWidget != _lastWidget) {
          _lastWidget = currentWidget;
        }
        return Container(child: _lastWidget);
      },
    );
  }

  Widget? infoWidget(BuildContext context, ProfileState state, profileId) {
    if (state is ProfileInfoLoading) {
      return ShimmerUserInfo();
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
      return buildBody(context, state.profile, profileId);
    }
  }

  Widget buildBody(BuildContext context, Profile profile, profileId) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 30),
                      child: Container(
                        width: 150,
                        height: 150,
                        child: Column(
                          children: [
                            Container(
                              padding:
                                  EdgeInsetsDirectional.symmetric(vertical: 8),
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
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                                        child: ProfileCacheImage(
                                                            profile.photo)),
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/images/profile/profile2.svg'),
                                          ),
                                          if (profileId == null &&
                                              profile.online == false)
                                            Padding(
                                              padding: const EdgeInsetsDirectional
                                                  .only(start: 7, top: 7),
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
                                                      EdgeInsetsDirectional.all(
                                                          2.5),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                        ],
                                      ),
                                    ),
                                    if (profileId != null)
                                      Align(
                                        alignment: AlignmentDirectional
                                            .bottomEnd,
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 5, 5),
                                          child: Container(
                                            padding: EdgeInsetsDirectional.all(2),
                                            decoration: BoxDecoration(

                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                            ),
                                            child: Container(
                                              width: 35,
                                              height: 35,
                                              padding: EdgeInsetsDirectional.zero,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: profile
                                                    .currentUserNotificationEnabled
                                                    ? Theme.of(context)
                                                    .primaryColor
                                                    : cameraBackgroundColor,
                                              ),
                                              child: Center(
                                                child: IconButton(
                                                  padding: EdgeInsetsDirectional.zero,
                                                  icon:
                                                  profile.currentUserNotificationEnabled
                                                      ? FaIcon(
                                                      size: 20,
                                                      FontAwesomeIcons
                                                          .solidBellOn,
                                                      color: whiteColor)
                                                      : FaIcon(
                                                      size: 20,
                                                      FontAwesomeIcons
                                                          .solidBellPlus,
                                                      color: Theme.of(
                                                          context)
                                                          .primaryColor),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "${profile.name} ${profile.family}",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      color: Theme.of(context).hoverColor,
                                    ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "(${profile.displayName})",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                              ),
                              SizedBox(height: 8),
                              // i want to show switch button here
                              if (profileId == null)
                                BlocProvider.of<SettingBloc>(context)
                                            .state
                                            .canChangeOnlineStatus ??
                                        false
                                    ? AdvancedSwitch(
                                        controller: advanceSwitchController,
                                        thumb: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(2, 2, 0, 2),
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        inactiveColor:
                                            Theme.of(context).hintColor,
                                        height: 28,
                                        width: 75,
                                        inactiveChild: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  end: 8),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translateNested(
                                                    "profileScreen", "online"),
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
                                              const EdgeInsetsDirectional.only(
                                                  start: 10),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translateNested(
                                                    "profileScreen", "offline"),
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
                                        onChanged: (value) {
                                          BlocProvider.of<ProfileBloc>(context)
                                              .add(ChangeStatusEvent(value));
                                        },
                                      )
                                    : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (profile.username != '')
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    '@${profile.username}' ?? '',
                                    textDirection: TextDirection.ltr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            if (profile.username != '') SizedBox(height: 16),
                            if (profile.field != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translateNested(
                                            "profileScreen", "field"),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            if (profile.field != null) SizedBox(height: 16),
                            if (profile.experience != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translateNested(
                                            "params", "experience"),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            if (profile.experience != null)
                              SizedBox(height: 16),
                            if (profile.biography != null)
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            if (profile.biography != null) SizedBox(height: 16),
                            if (profile.address != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translateNested(
                                            "profileScreen", "address"),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                            if (profile.address != null) SizedBox(height: 16),
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
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 8),
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
                            if (profile.offices != null &&
                                profile.offices!.isNotEmpty)
                              SizedBox(height: 16),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
                if (profileId == null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      //surfaceTintColor: Colors.transparent,
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
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                    ),
                  ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.2),
                  Theme.of(context).primaryColor.withOpacity(0.0),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 7),
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    if (_isExpanded) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  });
                },
                iconAlignment: IconAlignment.end,
                icon: RotationTransition(
                  turns: _animation,
                  child: _isExpanded
                      ? Icon(Icons.expand_less)
                      : Icon(Icons.expand_more),
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
                      .translateNested("profileScreen", "showMore"),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700),
                  textDirection: TextDirection.rtl,
                ),
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
            Theme.of(context).colorScheme.surface.withOpacity(0.5),
            Theme.of(context).colorScheme.surface.withOpacity(01),
            Theme.of(context).colorScheme.surface.withOpacity(0.5),
            Theme.of(context).colorScheme.surface.withOpacity(0),
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
    );
  }
}
