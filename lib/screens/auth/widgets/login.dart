import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:regexpattern/regexpattern.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../widgets/white_circular_progress_indicator.dart';
import '../auth_bloc.dart';

class Login extends StatefulWidget {
  final Function changeIndex;
  Login(this.changeIndex);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              AppLocalizations.of(context)!.translateNested("auth", "login"),
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
              padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
              child: Text(
                AppLocalizations.of(context)!.translateNested("auth", "insertMobile"),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).hoverColor,
                    ),
              ),
            ),
            Form(
              key: _formKey,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  String? errorMessage;
                  if (state is AuthFailure) {
                    errorMessage = state
                        .error; // Assuming the AuthFailure state has a 'message' property
                  }
                  return TextFormField(
                    focusNode: _focusNode,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textAlignVertical: TextAlignVertical.center,

                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.translateNested("auth", "phoneNumber"),
                      labelStyle: TextStyle(
                        color: _focusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).hintColor,
                        fontWeight: FontWeight.w400,
                        fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                        fontFamily: Theme.of(context).textTheme.titleLarge!.fontFamily,
                      ),
                      errorText: errorMessage,
                      errorStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w400,
                          ),
                      enabledBorder: borderStyle,
                      focusedBorder: selectedBorderStyle,
                      border: borderStyle,
                      errorBorder: errorBorderStyle,
                      focusedErrorBorder: errorBorderStyle,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
              padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthVerifyState) {
                    widget.changeIndex(1);
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
                        if (state is! AuthLoading) loginFunction(context);
                      },
                      child: (state is AuthLoading)
                          ? WhiteCircularProgressIndicator()
                          : Text(
                              AppLocalizations.of(context)!.translateNested('auth', 'submit'),
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
    );
  }

  void loginFunction(BuildContext context) {
    print('loginFunction');
    if (_formKey.currentState!.validate()) {
      final phoneNumber = _phoneController.text;
      BlocProvider.of<AuthBloc>(context).add(LogInEvent(phoneNumber));
    }
  }
}
