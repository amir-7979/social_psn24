import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/screens/main/widgets/screen_builder.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../configs/localization/app_localizations.dart';

class MyStylishBottomBar extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyStylishBottomBar(this.navigatorKey, {super.key});

  @override
  State<MyStylishBottomBar> createState() => _MyStylishBottomBarState();
}

class _MyStylishBottomBarState extends State<MyStylishBottomBar> {
  int _currentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      print('Current Index: $_currentIndex');
    });
    _navigateToScreen(index);
  }

  void _navigateToScreen(int index) {
    switch (index) {
      case 0:
        widget.navigatorKey.currentState!
            .pushReplacementNamed(AppRoutes.profile);
        break;
      case 1:
        widget.navigatorKey.currentState!.pushReplacementNamed(AppRoutes.home);
        break;
      case 2:
        //widget.navigatorKey.currentState!.pushReplacementNamed(AppRoutes.base);
        break;
      case 3:
        widget.navigatorKey.currentState!
            .pushReplacementNamed(AppRoutes.consultation);
        break;
      case 4:
        widget.navigatorKey.currentState!
            .pushReplacementNamed(AppRoutes.charity);
        break;
      default:
        widget.navigatorKey.currentState!.pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StylishBottomBar(
      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
      items: [
        BottomBarItem(
          icon: _currentIndex == 0
              ? SvgPicture.asset('assets/images/bottom_navbar/profile2.svg')
              : SvgPicture.asset(
                  'assets/images/bottom_navbar/profile1.svg',
                  color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,
                ),
          title: _currentIndex == 0
              ? Text(
                  AppLocalizations.of(context)!
                      .translateNested('bottomBar', 'profile'),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                )
              : Container(),
          selectedIcon:
              SvgPicture.asset('assets/images/bottom_navbar/profile2.svg'),
        ),
        BottomBarItem(
          icon: _currentIndex == 1
              ? SvgPicture.asset('assets/images/bottom_navbar/home2.svg')
              : SvgPicture.asset(
                  'assets/images/bottom_navbar/home1.svg',
                  color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,
                ),
          title: _currentIndex == 1
              ? Text(
                  AppLocalizations.of(context)!
                      .translateNested('bottomBar', 'home'),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                )
              : Container(),
          selectedIcon:
              SvgPicture.asset('assets/images/bottom_navbar/home2.svg'),
        ),
        BottomBarItem(icon: Container(), title: Container()),
        BottomBarItem(
          icon: _currentIndex == 3
              ? SvgPicture.asset('assets/images/bottom_navbar/medical2.svg')
              : SvgPicture.asset(
                  'assets/images/bottom_navbar/medical1.svg',
                  color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,
                ),
          title: _currentIndex == 3
              ? Text(
                  AppLocalizations.of(context)!
                      .translateNested('bottomBar', 'consultation'),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                )
              : Container(),
          selectedIcon:
              SvgPicture.asset('assets/images/bottom_navbar/medical2.svg'),
        ),
        BottomBarItem(
          icon: _currentIndex == 4
              ? SvgPicture.asset('assets/images/bottom_navbar/charity2.svg')
              : SvgPicture.asset(
                  'assets/images/bottom_navbar/charity1.svg',
                  color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,
                ),
          title: _currentIndex == 4
              ? Text(
                  AppLocalizations.of(context)!
                      .translateNested('bottomBar', 'charity'),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                )
              : Container(),
          selectedIcon:
              SvgPicture.asset('assets/images/bottom_navbar/charity2.svg'),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index != _currentIndex) {
          _onItemTapped(index);
        }
      },
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
}
