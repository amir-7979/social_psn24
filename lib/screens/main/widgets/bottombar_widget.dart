import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../../configs/localization/app_localizations.dart';
import '../main_bloc.dart';

Widget buildStylishBottomBar(MainState state, BuildContext context) {
  return StylishBottomBar(
    backgroundColor: Theme.of(context).bottomAppBarTheme.color,
    items: [
      BottomBarItem(
        icon: state.index == 0 ? SvgPicture.asset('assets/images/bottom_navbar/profile2.svg') : SvgPicture.asset('assets/images/bottom_navbar/profile1.svg', color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,),
        title: state.index == 0
            ? Text(
                AppLocalizations.of(context)!.translateNested('bottomBar', 'profile'),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              )
            : Container(),
        selectedIcon:
            SvgPicture.asset('assets/images/bottom_navbar/profile2.svg'),
      ),
      BottomBarItem(
        icon: state.index == 1 ? SvgPicture.asset('assets/images/bottom_navbar/home2.svg') : SvgPicture.asset('assets/images/bottom_navbar/home1.svg', color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,),

        title: state.index == 1
            ? Text(
          AppLocalizations.of(context)!.translateNested('bottomBar', 'home'),

          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              )
            : Container(),
        selectedIcon: SvgPicture.asset('assets/images/bottom_navbar/home2.svg'),
      ),
      BottomBarItem(icon: Container(), title: Container()),
      BottomBarItem(
        icon: state.index == 3 ? SvgPicture.asset('assets/images/bottom_navbar/medical2.svg') : SvgPicture.asset('assets/images/bottom_navbar/medical1.svg', color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,),
        title: state.index == 3
            ? Text(
          AppLocalizations.of(context)!.translateNested('bottomBar', 'consultation'),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              )
            : Container(),
        selectedIcon:
            SvgPicture.asset('assets/images/bottom_navbar/medical2.svg'),
      ),
      BottomBarItem(
        icon: state.index == 4 ? SvgPicture.asset('assets/images/bottom_navbar/charity2.svg') : SvgPicture.asset('assets/images/bottom_navbar/charity1.svg', color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,),
        title: state.index == 4
            ? Text(
          AppLocalizations.of(context)!.translateNested('bottomBar', 'charity'),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              )
            : Container(),
        selectedIcon:
            SvgPicture.asset('assets/images/bottom_navbar/charity2.svg'),
      ),
    ],
    currentIndex: state.index,
    onTap: (index) {
      if( state.index != index) {
        BlocProvider.of<MainBloc>(context).add(MainUpdate(index));
      }},
    fabLocation: StylishBarFabLocation.center,
    hasNotch: true,
    notchStyle: NotchStyle.circle,
    option: AnimatedBarOptions(
      padding: EdgeInsets.all(0),
      barAnimation: BarAnimation.blink,
      iconStyle: IconStyle.animated,
    ),
  );
}
