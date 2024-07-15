import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:social_psn/screens/auth/login/login_bloc.dart';
import 'package:social_psn/screens/auth/verify/verify_bloc.dart';
import 'package:social_psn/screens/widgets/custom_snackbar.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../configs/setting/themes.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/white_circular_progress_indicator.dart';

class Verify extends StatefulWidget {
  String phone;
  String LoginId;

  Verify({ required this.phone, required this.LoginId});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
  providers: [
    BlocProvider<VerifyBloc>(
      create: (context) => VerifyBloc(BlocProvider.of<SettingBloc>(context)),
),
    BlocProvider(
      create: (context) => LoginBloc(),
    ),
  ],
  child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Container(
          height: double.infinity,
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.background,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!
                      .translateNested("auth", "verify"),
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
                  padding:
                      const EdgeInsetsDirectional.symmetric(vertical: 16.0),
                  child: BlocBuilder<VerifyBloc, VerifyState>(
                    builder: (context, state) {
                      return Text(
                        AppLocalizations.of(context)!
                            .translateNestedWithVariable('auth', 'insertCode',
                                {'mobileNumber': widget.phone ?? ''}),
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
                  child: BlocConsumer<VerifyBloc, VerifyState>(
                    listener: (context, state) {
                      if (state is VerifyFailure) {
                        setState(() {
                          _codeController.clear();
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            content: state.error,
                          ).build(context),
                        );
                      } else if (state is VerifySuccess) {
                        Navigator.of(context).pushReplacementNamed(AppRoutes.register);
                      } else if (state is VerifyFinished) {
                        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                      }else if(state is ResendSuccess){
                        widget.LoginId = state.loginId;
                      }else if(state is ResendFailure){
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(
                            content: state.error,
                          ).build(context),
                        );
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
                        textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 50,
                          fieldWidth: 47,
                          activeFillColor: Theme.of(context).colorScheme.background,
                          inactiveFillColor: Theme.of(context).colorScheme.background,
                          selectedFillColor: Theme.of(context).colorScheme.background,
                          activeColor: Theme.of(context).hintColor,
                          inactiveColor: Theme.of(context).hintColor,
                          selectedColor: Theme.of(context).primaryColor,
                          errorBorderColor: state is VerifyFailure
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.background,
                        ),
                        animationDuration: const Duration(milliseconds: 200),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        onCompleted: (v) {
                          if (state is! VerifyLoading) {
                            BlocProvider.of<VerifyBloc>(context).add(VerifyTokenEvent(loginId: widget.LoginId, code: v));
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
                  padding:
                      const EdgeInsetsDirectional.symmetric(vertical: 16.0),
                  child: TimerWidget(widget.phone.toString()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
          ),
        ),
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
    _secondsRemaining = 120;
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
    return BlocBuilder<VerifyBloc, VerifyState>(
      builder: (context, verifyState) {
        return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: _secondsRemaining == 0 && verifyState is! VerifyLoading
          ? () {
        BlocProvider.of<VerifyBloc>(context).add(ResendCode(phone: widget.phone));
        _startTimer();
        setState(() {
        });
      }
          : (){},
      child: verifyState is VerifyLoading
          ? WhiteCircularProgressIndicator()
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
