import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/home/widgets/blur_widget.dart';

import '../../configs/custom_navigator_observer.dart';
import '../../configs/custom_page_route.dart';
import '../../configs/setting/setting_bloc.dart';
import '../home/home_screen.dart';
import '../home/widgets/floating_action_button.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/bottombar_widget.dart';
import '../widgets/guest_drawer_widget.dart';
import '../widgets/user_drawer_widget.dart';
import 'widgets/screen_builder.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isAddButtonClicked = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(1);
  late CustomNavigatorObserver _navigatorObserver;
  void changeAddButtonState(bool state) {
    setState(() {
      isAddButtonClicked = state;
    });
  }
  @override
  void initState() {
    super.initState();
    _navigatorObserver = CustomNavigatorObserver(_currentIndexNotifier);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      drawer: context.read<SettingBloc>().state.isUserLoggedIn
          ? UserDrawer(context, _navigatorKey)
          : GuestDrawer(context, _navigatorKey),
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          Navigator(
            key: _navigatorKey,
            initialRoute: AppRoutes.home,
            observers: [_navigatorObserver],
            onGenerateRoute: (RouteSettings settings) {
              return CustomPageRoute(
                builder: routes[settings.name] ?? (context) => HomeScreen(),
                settings: settings,
              );
            },
          ),
          if (isAddButtonClicked) BlurWidget(isAddButtonClicked, _navigatorKey, changeAddButtonState)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton:
          MyFloatingActionButton(isAddButtonClicked, changeAddButtonState),
      bottomNavigationBar:
      MyStylishBottomBar(_navigatorKey, _currentIndexNotifier, _navigatorObserver),
    );
  }
}
