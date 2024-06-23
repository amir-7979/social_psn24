import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/screens/main/widgets/guest_drawer_widget.dart';
import 'package:social_psn/screens/main/widgets/user_drawer_widget.dart';
import '../../configs/setting/setting_bloc.dart';
import 'main_bloc.dart';
import 'widgets/appbar_widget.dart';
import 'widgets/body_widget.dart';
import 'widgets/bottombar_widget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(BlocProvider.of<SettingBloc>(context)),
      child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
        bool isLoggedIn = context.read<SettingBloc>().state.isUserLoggedIn; // Check if user is logged in
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            drawer: isLoggedIn ? UserDrawer(context) : GuestDrawer(context),
            appBar: buildAppBar(context),
            body: buildBody(state.index),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            bottomNavigationBar: buildStylishBottomBar(state, context),
            floatingActionButton: LayoutBuilder(
              builder: (context, constraints) {
                bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
                return isKeyboardOpen
                    ? Container() // Return an empty container when keyboard is open
                    : FloatingActionButton(
                  onPressed: () {},
                  child: SvgPicture.asset('assets/images/bottom_navbar/plus.svg'),
                  shape: CircleBorder(),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
