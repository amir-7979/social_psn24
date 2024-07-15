
import 'package:flutter/material.dart';

class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
    builder: builder,
    settings: settings,
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
  );

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.name == '/') {
      return child;
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
