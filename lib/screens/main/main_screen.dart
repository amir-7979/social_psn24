import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../configs/custom_navigator_observer.dart';
import '../../configs/custom_page_route.dart';
import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/setting_bloc.dart';
import '../../configs/setting/themes.dart';
import '../../configs/utilities.dart';
import '../home/home_screen.dart';
import '../widgets/appbar/appbar_widget.dart';
import '../widgets/bottombar_widget.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/dialogs/my_confirm_dialog.dart';
import '../widgets/guest_drawer_widget.dart';
import '../widgets/user_drawer_widget.dart';
import 'widgets/screen_builder.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  bool isAddButtonClicked = false;
  DateTime? _lastPressedTime;
  bool _isSnackBarVisible = false; // Add this flag

  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(1);
  late CustomNavigatorObserver _navigatorObserver;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _navigatorObserver = CustomNavigatorObserver(_currentIndexNotifier);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleFABPressed() {
    if (!BlocProvider.of<SettingBloc>(context)
        .state
        .isUserLoggedIn)
      return;
    if (isAddButtonClicked) {
      _animationController.reverse().then((_) {
        setState(() {
          isAddButtonClicked = false;
        });
      });
    } else {
      setState(() {
        isAddButtonClicked = true;
      });
      _animationController.forward();
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    DateTime currentTime = DateTime.now();

    // Double back press to exit
    if (_lastPressedTime != null &&
        currentTime.difference(_lastPressedTime!) < Duration(seconds: 2)) {
      exit(0);
    }
    final isAtHome = !(navigatorKey.currentState?.canPop() ?? true);
    if (isAtHome) {
      _lastPressedTime = currentTime;
      if (!_isSnackBarVisible) {
        _isSnackBarVisible = true;

        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            content: AppLocalizations.of(context)!
                .translateNested('dialog', 'pressToExit'),
            backgroundColor: Colors.black,
          ).build(context),
        ).closed.then((_) {
          _isSnackBarVisible = false;
        });
      }
      return false;
    } else {
      navigatorKey.currentState?.pop();
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: SocialAppBar(navigatorObserver: _navigatorObserver),
      drawer: context.read<SettingBloc>().state.isUserLoggedIn
          ? UserDrawer(context, navigatorKey)
          : GuestDrawer(context, navigatorKey),
      body: Stack(
        children: [
          WillPopScope(
            onWillPop: () => _onWillPop(context),
            child: Navigator(
              key: navigatorKey,
              initialRoute: AppRoutes.home,
              observers: [_navigatorObserver],
              onGenerateRoute: (RouteSettings settings) {
                return CustomPageRoute(
                  builder: routes[settings.name] ?? (context) => HomeScreen(),
                  settings: settings,
                );
              },
            ),
          ),
          if (isAddButtonClicked) _buildBlurScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: MyFloatingActionButton(
        isAddButtonClicked,
        () {
          _handleFABPressed();
        },
      ),
      bottomNavigationBar: MyStylishBottomBar(
        navigatorKey,
        _currentIndexNotifier,
        _navigatorObserver,
      ),
    );
  }

  Widget _buildBlurScreen() {

    return InkWell(
      onTap: _handleFABPressed,
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withOpacity(0.5)
            : Colors.white.withOpacity(0.5),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 30),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        _buildAnimatedColumn(
                          -1,
                          AppLocalizations.of(context)!
                              .translateNested('bottomBar', 'content'),

                          FontAwesomeIcons.thinCloudArrowUp,

                          () {
                            if (!BlocProvider.of<SettingBloc>(context)
                                .state
                                .isUserLoggedIn) {
                              navigatorKey.currentState!
                                  .pushNamed(AppRoutes.login);
                            } else {
                              if (BlocProvider.of<SettingBloc>(context)
                                  .state
                                  .profile != null && BlocProvider.of<SettingBloc>(context)
                                  .state
                                  .profile!
                                  .permissions!
                                  .any((permission) {
                                return RegExp(r'create .* post')
                                    .hasMatch(permission);
                              })) {
                                navigatorKey.currentState!
                                    .pushNamed(AppRoutes.createMedia);
                              }
                              _handleFABPressed();
                            }
                          },
                            color: BlocProvider.of<SettingBloc>(context)
                                .state
                                .profile != null && BlocProvider.of<SettingBloc>(context)
                                .state
                                .profile!
                                .permissions!
                                .any((permission) {
                              return RegExp(r'create .* post')
                                  .hasMatch(permission);
                            }) ? Theme.of(context).colorScheme.tertiary : darkBaseColor
                        ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 55),
                        child: _buildAnimatedColumn(
                          0,
                          AppLocalizations.of(context)!
                              .translateNested('bottomBar', 'consultation'),
                          FontAwesomeIcons.thinComment,
                                () {
                              if (!BlocProvider.of<SettingBloc>(context)
                                  .state
                                  .isUserLoggedIn) {
                                navigatorKey.currentState!
                                    .pushNamed(AppRoutes.login);
                              } else {
                                if (BlocProvider.of<SettingBloc>(context)
                                    .state
                                    .profile != null && BlocProvider.of<SettingBloc>(context)
                                    .state
                                    .profile!
                                    .permissions!
                                    .any((permission) {
                                  return RegExp(r'create .* ')
                                      .hasMatch(permission);
                                })) {
                                  navigatorKey.currentState!
                                      .pushNamed(AppRoutes.createConsult);
                                }
                                _handleFABPressed();
                              }
                            },
                            color: BlocProvider.of<SettingBloc>(context)
                                .state
                                .profile != null && BlocProvider.of<SettingBloc>(context)
                                .state
                                .profile!
                                .permissions!
                                .any((permission) {
                              return RegExp(r'create .* ')
                                  .hasMatch(permission);
                            }) ? Theme.of(context).colorScheme.tertiary : darkBaseColor
                        ),
                      ),
                      _buildAnimatedColumn(
                        1,
                        AppLocalizations.of(context)!
                            .translateNested('bottomBar', 'charity'),
                        FontAwesomeIcons.thinHandsHolding,
                        _handleFABPressed,
                        color: darkBaseColor
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedColumn(
      double angle, String text, IconData icon, VoidCallback onPressed, {Color? color}) {
    final double distance = 20.0;
    final double x = distance * angle * (1 - _animation.value);
    final double y = distance * (1 - _animation.value);

    return Transform.translate(
      offset: Offset(x, y),
      child: Opacity(
        opacity: _animation.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
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
                onPressed: onPressed,
                child: FaIcon(size: 22, icon, color: whiteColor),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: color?? Theme.of(context).colorScheme.tertiary,
                  shape: CircleBorder(),
                  padding: EdgeInsets.zero,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyFloatingActionButton extends StatelessWidget {
  final bool isAddButtonClicked;
  final Function changeAddButtonState;

  MyFloatingActionButton(this.isAddButtonClicked, this.changeAddButtonState);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
        return isKeyboardOpen
            ? Container()
            : FloatingActionButton(
                onPressed: () => changeAddButtonState(),
                child: FaIcon(
                  size: 22,
                  isAddButtonClicked
                      ? FontAwesomeIcons.thinXmark
                      : FontAwesomeIcons.thinPlus,
                  color: whiteColor,
                ),
                backgroundColor: isAddButtonClicked
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).primaryColor,
                shape: CircleBorder(),
              );
      },
    );
  }
}
