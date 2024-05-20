import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/screens/auth/auth_screen.dart';
import 'package:social_psn/screens/main/widgets/guest_drawer_widget.dart';
import 'package:social_psn/screens/main/widgets/user_drawer_widget.dart';
import 'main_bloc.dart';
import 'widgets/appbar_widget.dart';
import 'widgets/body_widget.dart';
import 'widgets/bottombar_widget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocProvider<MainBloc>(
        create: (context) => MainBloc(),
        child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
          bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              drawer: GuestDrawer(),
              appBar: buildAppBar(context),
              body: AuthScreen(),
              /*body: buildBody(state.index),*/
              floatingActionButton: isKeyboardOpen
                  ? Container() // Return an empty container when keyboard is open
                  : FloatingActionButton(
                      onPressed: () {},
                      child: SvgPicture.asset('assets/images/bottom_navbar/plus.svg'),
                      shape: CircleBorder(),
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
              bottomNavigationBar: buildStylishBottomBar(state, context),
            ),
          );
        }),
      ),
    );
  }
}