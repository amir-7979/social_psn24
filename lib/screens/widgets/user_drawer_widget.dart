import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';

import '../../configs/consts.dart';
import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/themes.dart';
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
        final BuildContext dialogContext = context; // Store the BuildContext in a variable

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
                      color: Colors.transparent,
                      child:  Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
                        child: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(70), // Image radius
                            child: photo != null ? ProfileCacheImage(photo) :  SvgPicture.asset('assets/images/drawer/profile2.svg'),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      BlocProvider.of<SettingBloc>(context).state.profile?.fullName?? '',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: whiteColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      BlocProvider.of<SettingBloc>(context).state.profile?.phone?? '',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: whiteColor,
                        fontWeight: FontWeight.w400,

                      ),
                    ),
                    SizedBox(height: 5),
                    /*Container(
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(16, 2, 16, 2),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        BlocProvider.of<SettingBloc>(context).state.profile?.displayName?? '',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: blackColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),*/
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
                              color:  Colors.grey /*: (Theme.of(context).brightness == Brightness.light ? null : Theme.of(context).hoverColor)*/,
                            ),
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.translateNested('drawer', 'drawerWallet'),
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey /*: Theme.of(context).hoverColor*/,
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
                        onTap: () {
                          navigatorKey.currentState!.pushNamed(AppRoutes.interest);
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
                            fit: BoxFit.cover,
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
                          navigatorKey.currentState!.pushNamed(AppRoutes.cooperate);
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
                            fit: BoxFit.cover,
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
                                  'dialog', 'exitFromAppDescription'), cancelText: AppLocalizations.of(context)!.translateNested(
                                  'dialog', 'cancel'),confirmText: AppLocalizations.of(context)!.translateNested(
                                  'dialog', 'exit'),
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onConfirm: () {
                                  dialogContext.read<SettingBloc>().add(ClearInfo());
                                  Navigator.pop(context);
                                  navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
                                },
                              );
                             /* return AlertDialog(
                                backgroundColor: Theme.of(context).colorScheme.background,
                                title: Text(
                                  AppLocalizations.of(context)!.translateNested(
                                      'drawer', 'drawerExit'),
                                  style:
                                  Theme.of(context).textTheme.displaySmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.shadow,
                                  ),
                                ),
                                content: Text(
                                  AppLocalizations.of(context)!.translateNested(
                                      'drawer', 'sure'),
                                  style:
                                  Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.shadow,
                                  ),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text(
                                      AppLocalizations.of(context)!.translateNested(
                                          'drawer', 'no'),
                                      style:
                                      Theme.of(context).textTheme.titleLarge!.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.transparent,
                                      //foregroundColor: Theme.of(context).colorScheme.tertiary,
                                      backgroundColor: Color(0x3300A6ED),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text(
                                      AppLocalizations.of(context)!.translateNested(
                                          'drawer', 'yes'),
                                      style:
                                      Theme.of(context).textTheme.titleLarge!.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      dialogContext.read<SettingBloc>().add(ClearInfo());
                                      Navigator.pop(context);
                                      navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);

                                    },
                                  ),
                                ],
                              );*/
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
            ],
          ),
        );
      }
    );
  }
}
