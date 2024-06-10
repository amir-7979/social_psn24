import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';

import '../../configs/localization/app_localizations.dart';
import '../main/main_bloc.dart';
import 'auth_bloc.dart';
import 'widgets/login.dart';
import 'widgets/register.dart';
import 'widgets/verify.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _currentIndex = 0;

  void _changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(BlocProvider.of<SettingBloc>(context)),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Container(
          height: double.infinity,
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.background,
          ),
          child: Stack(
            children: [
              Visibility(
                visible: _currentIndex == 0,
                child: Login(_changeIndex),
                maintainState: false,
              ),
              Visibility(
                visible: _currentIndex == 1,
                child: Verify(_changeIndex), // You might need to pass the phoneNumber here
                maintainState: false,
              ),
              Visibility(
                visible: _currentIndex == 2,
                child: Register(_changeIndex),
                maintainState: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
