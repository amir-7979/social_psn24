import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/screens/main/widgets/search_widget.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../configs/setting/themes.dart';
import '../notification/notification_screen.dart';

AppBar buildAppBar(BuildContext context) {
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
              SettingThemeEvent(Theme.of(context).brightness == Brightness.light
                  ? AppTheme.dark
                  : AppTheme.light),


            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: IconButton(
          color: Theme.of(context).appBarTheme.iconTheme!.color,
          icon: SvgPicture.asset(
            'assets/images/appbar/bell.svg',
            color: Theme.of(context).appBarTheme.iconTheme!.color,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: NotificationScreen(),
                  );
                });
          },
        ),
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
            /*showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(
                    alignment: Alignment.topCenter,
                    insetPadding: EdgeInsets.only(top: 70),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    insetAnimationDuration: Duration.zero,
                    child: SizedBox(
                        height: 110,
                        child: SearchWidget()),
                  );
                });*/
          },
        ),
      ),
    ],
  );
}
