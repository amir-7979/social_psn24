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
  Widget? _lastWidget = Login();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(BlocProvider.of<SettingBloc>(context)),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFinished) {
              context.read<MainBloc>().add(MainUpdate(1));
            }
          },
          builder: (context, state) {
            Widget? currentWidget = authWidget(state);
            if (currentWidget != null && currentWidget != _lastWidget) {
              _lastWidget = currentWidget;
            }
            return Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: _lastWidget,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget? authWidget(AuthState state) {
    if (state is AuthLoginState) {
      return Login();
    } else if (state is AuthVerifyState) {
      return Verify(phoneNumber: state.phoneNumber);
    } else if (state is AuthRegisterState) {
      return Register();
    }
  }
}
