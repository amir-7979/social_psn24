import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'package:social_psn/screens/notification/notification_bloc.dart';

import '../../configs/consts.dart';
import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/themes.dart';
import '../../configs/utilities.dart';
import '../main/widgets/screen_builder.dart';
import 'custom_snackbar.dart';
import 'dialogs/my_confirm_dialog.dart';
import 'profile_cached_network_image.dart';

class UserDrawer extends StatelessWidget {
  final BuildContext snackBarContext;
  final GlobalKey<NavigatorState> navigatorKey;

  UserDrawer(this.snackBarContext, this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        String? photo = BlocProvider.of<SettingBloc>(context).state.profile?.photo;
        final BuildContext dialogContext = context;

        return Drawer(
          width: 270,
          backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 8),
                            child: ClipOval(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(2), // Adjust the padding thickness
                                  child: ClipOval(
                                    child: SizedBox.fromSize(
                                      size: Size.fromRadius(30), // Image radius
                                      child: photo != null
                                          ? ProfileCacheImage(photo)
                                          : SvgPicture.asset('assets/images/drawer/profile2.svg'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          color: whiteColor,
                          icon :  FaIcon(
                              size: 24,

                              Theme.of(context).brightness == Brightness.light ? FontAwesomeIcons.solidMoon : FontAwesomeIcons.solidSunBright, color: whiteColor),
                          onPressed: () {
                            BlocProvider.of<SettingBloc>(context).add(
                              SettingThemeEvent(
                                  Theme.of(context).brightness == Brightness.light
                                      ? AppTheme.dark
                                      : AppTheme.light),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            BlocProvider.of<SettingBloc>(context).state.profile?.fullName?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              color: whiteColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                BlocProvider.of<SettingBloc>(context).state.profile?.phone?? '',
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400,),
                              ),
                              Container(
                                padding:
                                const EdgeInsetsDirectional.fromSTEB(8, 2, 8, 2),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  BlocProvider.of<SettingBloc>(context).state.profile?.displayName?? '',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: blackColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
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
                        contentPadding: const EdgeInsetsDirectional.all(0),
                        horizontalTitleGap: 10,
                        dense: true,
                        leading: SizedBox(
                          width: 22,
                          height: 22,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SvgPicture.asset(
                              'assets/images/drawer/wallet.svg',
                              color:  (Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
                            ),
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.translateNested('drawer', 'drawerWallet'),
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).hoverColor,
                          ),
                        ),
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
                            SvgPicture.asset('assets/images/drawer/heart.svg',
                                color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
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
                        onTap: () {
                          navigatorKey.currentState!.pushNamed(AppRoutes.interest);
                          Navigator.pop(context);},
                      ),
                      /*ListTile(
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
                            SvgPicture.asset('assets/images/drawer/money.svg', color: Colors.grey),
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.translateNested(
                              'drawer', 'drawerMoney'),
                          style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey
                          ),
                        ),
                        onTap: () {Navigator.pop(context);},
                      ),*/
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
                            SvgPicture.asset('assets/images/drawer/hands.svg',
                                color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
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
                         // navigatorKey.currentState!.pushNamed(AppRoutes.cooperate);
                          // Navigator.pop(context);
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
                            child: SvgPicture.asset(
                                'assets/images/drawer/settings.svg',
                                color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
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
                        onTap: () {
                          navigatorKey.currentState!.pushNamed(AppRoutes.settings);
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
                            SvgPicture.asset('assets/images/drawer/invite.svg',
                                color: Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor),
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
                        onTap: () async {
                          shareMethod(inviteLink);
                         /* FlutterClipboard.copy(inviteLink).then((value) {
                            ScaffoldMessenger.of(snackBarContext).showSnackBar(
                              CustomSnackBar(
                                  function: () => ScaffoldMessenger.of(snackBarContext).hideCurrentSnackBar(),
                                  content: AppLocalizations.of(context)!.translateNested('drawer', 'invite'),
                                  backgroundColor: Theme.of(context).primaryColor
                              ).build(snackBarContext),
                            );                          });*/
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
                            SvgPicture.asset('assets/images/drawer/rules.svg', color: Colors.grey),
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.translateNested(
                              'drawer', 'drawerRules'),
                          style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
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
                            SvgPicture.asset('assets/images/drawer/asks.svg', color: Colors.grey),
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.translateNested(
                              'drawer', 'drawerAsks'),
                          style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
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
                            SvgPicture.asset('assets/images/drawer/exit.svg', color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.error),
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.translateNested(
                              'drawer', 'drawerExit'),
                          style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color:Theme.of(context).colorScheme.error,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: dialogContext,
                            builder: (BuildContext context) {
                              return MyConfirmDialog(
                                title: AppLocalizations.of(context)!.translateNested(
                                  'dialog', 'exitFromAppTitle'), description: AppLocalizations.of(context)!.translateNested(
                                  'dialog', 'exitFromAppAccountDescription'), cancelText: AppLocalizations.of(context)!.translateNested(
                                  'dialog', 'cancel'),confirmText: AppLocalizations.of(context)!.translateNested(
                                  'dialog', 'exit'),
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onConfirm: () {
                                  //reset notification bloc
                                  BlocProvider.of<NotificationBloc>(context).reset();
                                  dialogContext.read<SettingBloc>().add(ClearInfo());
                                  Navigator.pop(context);
                                  navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
                                },
                              );
                            },
                          )..then((value) {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 16),
            child: Text(
              'ver 0.0.1',
              style:
              Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),),
              ),
            ],
          ),
        );
      }
    );
  }


}
