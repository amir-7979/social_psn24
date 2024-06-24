import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/configs/setting/themes.dart';
import 'package:social_psn/screens/create_media/create_media_bloc.dart';
import 'package:social_psn/screens/main/widgets/guest_drawer_widget.dart';
import 'package:social_psn/screens/main/widgets/user_drawer_widget.dart';
import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/setting_bloc.dart';
import 'main_bloc.dart';
import 'widgets/appbar_widget.dart';
import 'widgets/body_widget.dart';
import 'widgets/bottombar_widget.dart';

class MainScreen extends StatefulWidget {

  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isAddButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(BlocProvider.of<SettingBloc>(context)),
      child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            drawer: context.read<SettingBloc>().state.isUserLoggedIn ? UserDrawer(context) : GuestDrawer(context),
            appBar: buildAppBar(context),
            body: Stack(
              children: [
                buildBody(state.index),
                if (_isAddButtonClicked)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isAddButtonClicked = false;
                      });
                    },
                    child: Container(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(bottom: 30),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.translateNested('bottomBar', 'content'),
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                        color: Theme.of(context).colorScheme.shadow,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      height: 55,
                                      width: 55,
                                      child: ElevatedButton(
                                        onPressed: () {context.read<MainBloc>().add(CreateMedia());
                                        setState(() {
                                          _isAddButtonClicked = false;
                                        });},
                                        child: FaIcon(
                                            size: 22,
                                            FontAwesomeIcons.thinCloudArrowUp,
                                            color: whiteColor),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 55),
                                  child:  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.translateNested('bottomBar', 'consultation'),
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          color: Theme.of(context).colorScheme.shadow,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        height: 55,
                                        width: 55,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: FaIcon(
                                              size: 22,
                                              FontAwesomeIcons.thinComment,
                                              color: whiteColor),
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.translateNested('bottomBar', 'charity'),
                                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                        color: Theme.of(context).colorScheme.shadow,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      height: 55,
                                      width: 55,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: FaIcon(
                                            size: 22,
                                            FontAwesomeIcons.thinHandsHolding,
                                            color: whiteColor),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Theme.of(context).colorScheme.tertiary,
                                          shape: CircleBorder(),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            bottomNavigationBar: buildStylishBottomBar(state, context),
            floatingActionButton: LayoutBuilder(
              builder: (context, constraints) {
                bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
                return isKeyboardOpen
                    ? Container() // Return an empty container when keyboard is open
                    : _isAddButtonClicked
                    ? SizedBox(
                      height: 55,
                      width: 55,
                      child: FloatingActionButton(
                                        onPressed: () {
                      setState(() {
                        _isAddButtonClicked = false;
                      });
                                        },
                                        child: FaIcon(
                        size: 22,
                        FontAwesomeIcons.thinXmark,
                        color: whiteColor
                                        ),
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        shape: CircleBorder(),
                                      ),
                    )
                    : FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isAddButtonClicked = true;
                    });
                  },
                  child:  FaIcon(
                      size: 22,
                      FontAwesomeIcons.thinPlus,
                      color: whiteColor
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
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
