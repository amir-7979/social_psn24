import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:social_psn/screens/auth/login/login_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/white_circular_progress_indicator.dart';

class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Container(
          height: double.infinity,
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.background,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!
                        .translateNested("auth", "login"),
                    style: iranYekanTheme.displayLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 16.0),
                    child: Container(
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
                    child: Text(
                      AppLocalizations.of(context)!
                          .translateNested("auth", "insertMobile"),
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context).hoverColor,
                              ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        String? errorMessage;
                        if (state is LoginFailure) {
                          errorMessage = state.error;
                        }
                        return TextFormField(
                          focusNode: _focusNode,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!
                                .translateNested("auth", "phoneNumber"),
                            labelStyle: TextStyle(
                              color: _focusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).hintColor,
                              fontWeight: FontWeight.w400,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontFamily,
                            ),
                            errorText: errorMessage,
                            errorStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w400,
                                ),
                            enabledBorder: borderStyle,
                            focusedBorder: selectedBorderStyle,
                            border: borderStyle,
                            errorBorder: errorBorderStyle,
                            focusedErrorBorder: errorBorderStyle,
                            contentPadding:
                                const EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                          ),
                          validator: (value) {
                            if (value!.isNotEmpty &&
                                value.length == 11 &&
                                value.startsWith('09') &&
                                value.isPhone()) {
                              return null;
                            }
                            return AppLocalizations.of(context)!
                                .translateNested('error', 'phone_start_0');
                          },
                          onFieldSubmitted: (value) {
                            loginFunction(context);
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(vertical: 16.0),
                    child: BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        print('state : ${state}');
                        if (state is LoginSuccess) {
                          print('state : ${state.loginId}');
                          Navigator.of(context).pushNamed(AppRoutes.verify, arguments: {
                            'phone': state.phone,
                            'loginId': state.loginId,
                          });
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (state is! LoginLoading) loginFunction(context);
                            },
                            child: (state is LoginLoading)
                                ? WhiteCircularProgressIndicator()
                                : Text(
                                    AppLocalizations.of(context)!
                                        .translateNested('auth', 'submit'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: whiteColor,
                                        ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginFunction(BuildContext context) {
    print('loginFunction');
    if (_formKey.currentState!.validate()) {
      final phoneNumber = _phoneController.text;
      BlocProvider.of<LoginBloc>(context).add(LogInEvent(phoneNumber));
    }
  }
}
