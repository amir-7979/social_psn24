import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../configs/custom_navigator_observer.dart';
import '../../configs/localization/app_localizations.dart';
import '../main/widgets/screen_builder.dart';
import '../main/main_screen.dart'; // Import the main screen to get access to the navigator observer.

class MyStylishBottomBar extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ValueNotifier<int> currentIndexNotifier;
  final CustomNavigatorObserver navigatorObserver;

  const MyStylishBottomBar(this.navigatorKey, this.currentIndexNotifier, this.navigatorObserver);

  @override
  State<MyStylishBottomBar> createState() => _MyStylishBottomBarState();
}

class _MyStylishBottomBarState extends State<MyStylishBottomBar> {
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    widget.currentIndexNotifier.addListener(_updateIndex);
  }

  @override
  void dispose() {
    widget.currentIndexNotifier.removeListener(_updateIndex);
    super.dispose();
  }

  void _updateIndex() {
    setState(() {
      _currentIndex = widget.currentIndexNotifier.value;
    });
  }

  void _navigateToScreen(int index) {
    String targetRoute;
    switch (index) {
      case 0:
        targetRoute = AppRoutes.myProfile;
        break;
      case 1:
        targetRoute = AppRoutes.home;
        break;
      case 3:
        targetRoute = AppRoutes.consultation;
        break;
      case 4:
        targetRoute = AppRoutes.charity;
        break;
      default:
        targetRoute = AppRoutes.home;
    }

    // Get the current route from the navigator observer.
    String currentRoute = widget.navigatorObserver.currentRoute;

    if (currentRoute != targetRoute) {
      widget.navigatorKey.currentState!.pushReplacementNamed(targetRoute);
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
            AppLocalizations.of(context)!.translateNested('bottomBar', 'profile'),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          )
              : Container(),
          selectedIcon: SvgPicture.asset('assets/images/bottom_navbar/profile2.svg'),
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
          icon: _currentIndex == 3
              ? SvgPicture.asset('assets/images/bottom_navbar/medical2.svg')
              : SvgPicture.asset(
            'assets/images/bottom_navbar/medical1.svg',
            color: Theme.of(context).bottomAppBarTheme.surfaceTintColor,
          ),
          title: _currentIndex == 3
              ? Text(
            AppLocalizations.of(context)!.translateNested('bottomBar', 'consultation'),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          )
              : Container(),
          selectedIcon: SvgPicture.asset('assets/images/bottom_navbar/medical2.svg'),
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
            AppLocalizations.of(context)!.translateNested('bottomBar', 'charity'),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          )
              : Container(),
          selectedIcon: SvgPicture.asset('assets/images/bottom_navbar/charity2.svg'),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        widget.currentIndexNotifier.value = index;
        _navigateToScreen(index);
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
