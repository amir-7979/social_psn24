import 'package:flutter/material.dart';

import '../screens/main/widgets/screen_builder.dart';
import 'utilities.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final ValueNotifier<int> currentIndexNotifier;
  String currentRoute = AppRoutes.home;

  CustomNavigatorObserver(this.currentIndexNotifier);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('didPush');
    print(route.settings.name);

    if (route.settings.name != previousRoute?.settings.name) {
      _updateCurrentIndex(route.settings.name);
    }

    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('didPop');
    super.didPop(route, previousRoute);
    _updateCurrentIndex(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('didReplace');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _updateCurrentIndex(newRoute?.settings.name);
  }

  void _updateCurrentIndex(String? routeName) {
    if (routeName == null) return;
    currentRoute = routeName;

    switch (routeName) {
      case AppRoutes.profile:
      case AppRoutes.myProfile:
      case AppRoutes.editProfile:
        currentIndexNotifier.value = 0;
        break;
      case AppRoutes.home:
      case AppRoutes.postDetailed:
        currentIndexNotifier.value = 1;
        break;
      case AppRoutes.interest:
      case AppRoutes.cooperate:
      case AppRoutes.createMedia:
      case AppRoutes.login:
      case AppRoutes.verify:
      case AppRoutes.register:
        currentIndexNotifier.value = 2;
        break;
      case AppRoutes.consultation:
        currentIndexNotifier.value = 3;
        break;
      case AppRoutes.charity:
        currentIndexNotifier.value = 4;
        break;
      default:
        currentIndexNotifier.value = 1;
        break;
    }
  }
}
