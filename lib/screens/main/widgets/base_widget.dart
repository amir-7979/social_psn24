import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/auth/auth_screen.dart';
import 'package:social_psn/screens/cooperation/cooperation_screen.dart';
import 'package:social_psn/screens/interest/interest_screen.dart';

import '../main_bloc.dart';

class BaseWidget extends StatelessWidget {
  Widget? _lastWidget;

  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        Widget? currentWidget = baseBuilder(state);
        if (currentWidget != null) {
          _lastWidget = currentWidget;
        }
        return Container(
          child: _lastWidget,
        );
      },
    );
  }

  Widget? baseBuilder(MainState state) {
    if (state is CooperatingState) {
      return CooperationScreen();
    }else if (state is AuthenticationState) {
      return AuthScreen();
    }else if(state is InterestState){
      return InterestScreen();
    } else {
      return Container();
    }
  }
}
