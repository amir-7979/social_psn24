import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../configs/setting/setting_bloc.dart';
import '../home/home_screen.dart';
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
  bool _isAddButtonClicked = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: context.read<SettingBloc>().state.isUserLoggedIn
          ? UserDrawer(context)
          : GuestDrawer(context),
      appBar: buildAppBar(context),
      body: Navigator(
        key: _navigatorKey,
        initialRoute: AppRoutes.home,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: routes[settings.name] ?? (context) => HomeScreen(), settings: settings);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
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
                            color: Colors.white),
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
                      child: FaIcon(
                          size: 22,
                          FontAwesomeIcons.thinPlus,
                          color: Colors.white),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: CircleBorder(),
                    );
        },
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          return MyStylishBottomBar(_navigatorKey);
        }
      ),
    );
  }
}