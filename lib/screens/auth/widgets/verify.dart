import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../auth_bloc.dart';

class Verify extends StatefulWidget {
  String? phoneNumber;

  Verify({this.phoneNumber});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.translateNested("auth", "verify"),
            style: iranYekanTheme.displayLarge!.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 16.0),
            child: SizedBox(
              height: 270,
              width: 270,
              child: Center(
                  child: SvgPicture.asset(
                'assets/images/profile/logo.svg',
                color: Theme.of(context).primaryColor,
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Text(
                  AppLocalizations.of(context)!.translateNestedWithVariable(
                      'auth',
                      'insertCode',
                      {'mobileNumber': widget.phoneNumber ?? ''}),
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).hoverColor,
                          ),
                );
              },
            ),
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthResetPin) {
                  setState(() {_codeController.clear();});
                }
              },
              builder: (context, state) {

                return PinCodeTextField(
                  length: 5,
                  controller: _codeController,
                  obscureText: false,
                  animationType: AnimationType.scale,
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).colorScheme.shadow,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 47,
                    activeFillColor:
                        Theme.of(context).colorScheme.background,
                    inactiveFillColor:
                        Theme.of(context).colorScheme.background,
                    selectedFillColor:
                        Theme.of(context).colorScheme.background,
                    activeColor: Theme.of(context).hintColor,
                    inactiveColor: Theme.of(context).hintColor,
                    selectedColor: Theme.of(context).primaryColor,
                    errorBorderColor: Theme.of(context).colorScheme.error,
                  ),
                  animationDuration: const Duration(milliseconds: 200),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (v) {
                    if (state is! AuthLoading) {
                      BlocProvider.of<AuthBloc>(context)
                          .add(VerifyTokenEvent(v));
                    }
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
            child: TimerWidget(widget.phoneNumber.toString()),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(GotoLoginEvent());
            },
            child: Text(
              AppLocalizations.of(context)!
                  .translateNested("auth", "changePhoneNumber"),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          )
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  String phone;

  TimerWidget(this.phone);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _secondsRemaining = 120; // Start with 120 seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          // Add any additional logic you need when the timer reaches 0
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _secondsRemaining == 0 && state is! AuthLoading
              ? () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(LogInEvent(widget.phone));
                }
              : () {},
          child: state is AuthLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
              : SizedBox(
                  child: Text(
                    _secondsRemaining == 0
                        ? AppLocalizations.of(context)!
                            .translateNested('auth', 'sendAgain')
                        : AppLocalizations.of(context)!
                            .translateNestedWithVariable('auth', 'sendAgain2',
                                {'second': _secondsRemaining.toString()}),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: whiteColor,
                        ),
                  ),
                ),
        );
      },
    );
  }
}
