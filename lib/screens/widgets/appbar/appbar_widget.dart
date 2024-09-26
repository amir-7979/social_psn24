import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/setting_bloc.dart';
import '../../../../configs/setting/themes.dart';
import '../../../configs/utilities.dart';
import '../../home/home_bloc.dart';
import '../../notification/notification_bloc.dart';
import '../../notification/notification_screen.dart';
import '../../post_search/post_search_screen.dart';
import 'appbar_bloc.dart';

class SocialAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SocialAppBar({
    super.key,
  });

  @override
  State<SocialAppBar> createState() => _SocialAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _SocialAppBarState extends State<SocialAppBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppbarBloc, AppbarState>(
      builder: (context, state) {
        if (state is Searching) {
          _controller.text = state.title;
          return AppBar(
            automaticallyImplyLeading: false,
            title: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          textDirection: detectDirection(_controller.text),
                          controller: _controller,
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.zero,
                                  elevation: 0,
                                  surfaceTintColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  insetAnimationDuration: Duration.zero,
                                  child: PostSearchScreen(_controller.text),
                                );
                              },
                            );
                          },
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.shadow,
                                    fontWeight: FontWeight.w500,
                                  ),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsetsDirectional.symmetric(vertical: 8),
                            // Adjust vertical padding
                            hintText: AppLocalizations.of(context)!
                                .translateNested('search', 'search'),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.w500,
                                ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 40,
                            onPressed: () {
                              //Navigator.of(context).pop();
                              BlocProvider.of<HomeBloc>(context).resetState();
                              _controller.clear();
                              BlocProvider.of<AppbarBloc>(context)
                                  .add(AppbarResetSearch());
                            },
                            icon: SvgPicture.asset(
                                'assets/images/search/close.svg')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else
          return AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate('appTitle'),
              style: iranYekanTheme.headlineMedium!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: Builder(builder: (context) {
              return IconButton(
                color: Theme.of(context).appBarTheme.iconTheme!.color,
                icon: SvgPicture.asset(
                  'assets/images/appbar/bars.svg',
                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            }),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: IconButton(
                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                  icon: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? 'assets/images/appbar/dark.svg'
                          : 'assets/images/appbar/light.svg'),
                  onPressed: () {
                    BlocProvider.of<SettingBloc>(context).add(
                      SettingThemeEvent(
                          Theme.of(context).brightness == Brightness.light
                              ? AppTheme.dark
                              : AppTheme.light),
                    );
                  },
                ),
              ),
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: IconButton(
                      color: Theme.of(context).appBarTheme.iconTheme!.color,
                      icon: state is NotificationLoaded && state.unreadNotifications > 0
                          ? badges.Badge(
                              badgeStyle: badges.BadgeStyle(
                                shape: badges.BadgeShape.circle,
                                badgeColor:
                                    Theme.of(context).primaryColor,
                                padding: EdgeInsets.all(2),
                                elevation: 0,
                              ),
                              position: badges.BadgePosition.topEnd(
                                  end: -8, top: -3),
                              badgeContent: Container(
                                height: 15,
                                width: 15,
                                child: Text(
                                    state.unreadNotifications.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                    color: whiteColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    vertical: 2),
                                child: SvgPicture.asset(
                                  'assets/images/appbar/bell.svg',
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .iconTheme!
                                      .color,
                                ),
                              ),
                            )
                          : SvgPicture.asset(
                              'assets/images/appbar/bell.svg',
                              color: Theme.of(context)
                                  .appBarTheme
                                  .iconTheme!
                                  .color,
                            ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            useSafeArea: true,
                            barrierDismissible: true,
                            useRootNavigator: true,
                            builder: (BuildContext context) {
                              return Dialog(
                                elevation: 1,
                                child: NotificationScreen(),
                              );
                            });
                      },
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 15.0),
                child: IconButton(
                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                  icon: SvgPicture.asset(
                    'assets/images/appbar/search.svg',
                    color: Theme.of(context).appBarTheme.iconTheme!.color,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        //todo show dialog based on screen
                        return Dialog(
                          insetPadding: EdgeInsets.zero,
                          elevation: 0,
                          surfaceTintColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          insetAnimationDuration: Duration.zero,
                          child: PostSearchScreen(''),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
      },
    );
  }
}
