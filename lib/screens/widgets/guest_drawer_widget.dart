import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../configs/consts.dart';
import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/themes.dart';
import '../main/widgets/screen_builder.dart';
import 'custom_snackbar.dart';

class GuestDrawer extends StatelessWidget {
  final BuildContext snackBarContext;
  final GlobalKey<NavigatorState> navigatorKey;

  GuestDrawer(this.snackBarContext, this.navigatorKey);

  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.transparent,
                    child: SvgPicture.asset('assets/images/drawer/profile2.svg'),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translateNested(
                        'drawer', 'guest'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: blackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsetsDirectional.only(top: 17, bottom: 5, start: 7, end: 7),
                  child: Text(
                    textAlign: TextAlign.center,
                    AppLocalizations.of(context)!.translateNested(
                        'drawer', 'loginForAllOptions'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: whiteColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 30, 16, 0),
              color: Theme.of(context).drawerTheme.backgroundColor,
              child: ListView(
                children: <Widget>[
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
                        fit: BoxFit.cover,
                        child: SvgPicture.asset('assets/images/drawer/login.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),),),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerLogin'),
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hoverColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.login);
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
                        fit: BoxFit.cover,
                        child:
                        SvgPicture.asset('assets/images/drawer/invite.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),),),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerInvite'),
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hoverColor,
                      ),
                    ),
                    onTap: () async {
                      FlutterClipboard.copy(inviteLink).then((value) {
                        ScaffoldMessenger.of(snackBarContext).showSnackBar(
                          CustomSnackBar(
                              function: () => ScaffoldMessenger.of(snackBarContext).hideCurrentSnackBar(),
                              content: AppLocalizations.of(context)!.translateNested('drawer', 'invite'),
                              backgroundColor: Theme.of(context).primaryColor
                          ).build(snackBarContext),
                        );                          });
                      Navigator.pop(context);

                    },
                  ),
/*
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
                          SvgPicture.asset('assets/images/drawer/mobile.svg', color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor) ),),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerPhone'),
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).hoverColor,
                      ),
                    ),
                    onTap: () {Navigator.pop(context);},
                  ),
*/
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
                        fit: BoxFit.cover,
                        child:
                        SvgPicture.asset('assets/images/drawer/rules.svg', color: Colors.grey),),),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerRules'),
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
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
                        fit: BoxFit.cover,
                        child:
                        SvgPicture.asset('assets/images/drawer/asks.svg', color: Colors.grey),),),
                    title: Text(
                      AppLocalizations.of(context)!.translateNested(
                          'drawer', 'drawerAsks'),
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {Navigator.pop(context);},
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
