import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../main_bloc.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? photo = BlocProvider.of<SettingBloc>(context).state.photo;
    return Drawer(
      width: 240,
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child:  Padding(
                    padding:
                    EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: photo != null ? Image.network(photo).image :  const AssetImage(
                          'assets/images/profile/profile.png'),
                    ),
                  ),
                ),
                Text(
                  BlocProvider.of<SettingBloc>(context).state.fullName ?? '',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: whiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: 3),
                Text(
                  BlocProvider.of<SettingBloc>(context).state.userPhoneNumber,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: whiteColor,
                        fontWeight: FontWeight.w400,

                      ),
                ),
                SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(16, 2, 16, 2),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'کاربر عادی',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: blackColor,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 25, 16, 0),
              color: Theme.of(context).drawerTheme.backgroundColor,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    dense: true,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: SvgPicture.asset(
                            'assets/images/drawer/profile.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                      ),
                    ),
                    title: Text(
                        AppLocalizations.of(context)!.translateNested(
                            'drawer', 'drawerProfile'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                    onTap: () {Navigator.pop(context);},
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    dense: true,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child:
                            SvgPicture.asset('assets/images/drawer/money.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerMoney'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                    onTap: () {Navigator.pop(context);},
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    dense: true,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child:
                            SvgPicture.asset('assets/images/drawer/heart.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerLike'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                    onTap: () {context.read<MainBloc>().add(InterestClicked());
                      Navigator.pop(context);},
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    dense: true,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child:
                            SvgPicture.asset('assets/images/drawer/hands.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerHand'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                    onTap: () {
/*
                      BlocProvider.of<MainBloc>(context).add(CooperatingClicked());
*/
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    dense: true,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: SvgPicture.asset(
                            'assets/images/drawer/settings.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerSetting'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                    onTap: () {Navigator.pop(context);},
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    dense: true,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child:
                            SvgPicture.asset('assets/images/drawer/invite.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerInvite'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                    onTap: () {Navigator.pop(context);},
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    dense: true,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child:
                            SvgPicture.asset('assets/images/drawer/mobile.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerPhone'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                    onTap: () {Navigator.pop(context);},
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    dense: true,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child:
                            SvgPicture.asset('assets/images/drawer/rules.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerRules'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                    onTap: () {Navigator.pop(context);},
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    dense: true,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child:
                            SvgPicture.asset('assets/images/drawer/asks.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerAsks'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                    onTap: () {Navigator.pop(context);},
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    contentPadding: const EdgeInsetsDirectional.all(0),
                    horizontalTitleGap: 10,
                    dense: true,
                    leading: SizedBox(
                      width: 22,
                      height: 22,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child:
                            SvgPicture.asset('assets/images/drawer/exit.svg', color: Theme.of(context).colorScheme.error,),
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerExit'),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.error,
                              ),
                    ),
                    onTap: () {
                      context.read<MainBloc>().add(LogoutClicked());
                      context.read<MainBloc>().add(MainUpdate(1));

                      Navigator.pop(context);},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
