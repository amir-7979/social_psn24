import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/auth/register/register_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../configs/setting/themes.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/profile_pucture/profile_picture.dart';
import '../../widgets/white_circular_progress_indicator.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _idFocusNode = FocusNode();
  String? photoUrl = null;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _idController.dispose();
    _nameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _idFocusNode.dispose();
    super.dispose();
  }

  void _newPickedImage(String? value) {
    if (value != null) {
      photoUrl = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(BlocProvider.of<SettingBloc>(context)),
      child: Builder(builder: (context) {
        return buildListView(context);
      },),
    );
  }

  Widget buildListView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Expanded(
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.background,
          ),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  height: 155,
                  width: 155,
                  child: Center(
                    child: ProfilePicture(photoUrl, _newPickedImage),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!
                        .translateNested("auth", 'register'),
                    style:
                    Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0),
                          Theme.of(context).primaryColor.withOpacity(1),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).hoverColor,
                        ),
                        focusNode: _nameFocusNode,
                        decoration: InputDecoration(
                          label: Text(
                            AppLocalizations.of(context)!
                                .translateNested('params', 'name'),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                              fontWeight: FontWeight.w400,
                              color: _nameFocusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                  .colorScheme
                                  .surface,
                            ),
                          ),
                          enabledBorder: borderStyle,
                          errorBorder: errorBorderStyle,
                          border: borderStyle,
                          focusedErrorBorder: errorBorderStyle,
                          contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!
                                .translateNested('error', 'notEmpty');
                          } else if (!RegExp(r'^[\u0600-\u06FF\s]+$')
                              .hasMatch(value)) {
                            return AppLocalizations.of(context)!
                                .translateNested('error', 'persian_name');
                          } else if (value.length > 30) {
                            return AppLocalizations.of(context)!
                                .translateNested('error', 'length_exceed');
                          }
                          return null;
                        },
                        onTap: () {
                          setState(() {
                          });
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_lastNameFocusNode);
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _lastNameController,
                        focusNode: _lastNameFocusNode,
                        keyboardType: TextInputType.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).hoverColor,
                        ),
                        decoration: InputDecoration(
                          label: Text(
                            AppLocalizations.of(context)!
                                .translateNested('params', 'family'),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                              fontWeight: FontWeight.w400,
                              color: _lastNameFocusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                  .colorScheme
                                  .surface,
                            ),
                          ),
                          enabledBorder: borderStyle,
                          errorBorder: errorBorderStyle,
                          border: borderStyle,
                          focusedErrorBorder: errorBorderStyle,
                          contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(
                              16, 0, 16, 0),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!
                                .translateNested('error', 'notEmpty');
                          } else if (!RegExp(r'^[\u0600-\u06FF\s]+$')
                              .hasMatch(value)) {
                            return AppLocalizations.of(context)!
                                .translateNested(
                                'error', 'persian_lastname');
                          } else if (value.length > 40) {
                            return AppLocalizations.of(context)!
                                .translateNested('error', 'length_exceed');
                          }
                          return null;
                        },
                        onTap: () {
                          setState(() {
                          });
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_idFocusNode);
                        },
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.only(bottom: 16.0),
                      child: TextFormField(
                          controller: _idController,
                          focusNode: _idFocusNode,
                          textDirection: TextDirection.ltr,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).hoverColor,
                          ),
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            suffix: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 4),
                              child: Text(
                                '@',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .shadow,
                                ),
                              ),
                            ),
                            label: Text(
                              AppLocalizations.of(context)!
                                  .translateNested('params', 'username'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                fontWeight: FontWeight.w400,
                                color: _idFocusNode.hasFocus
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                    .colorScheme
                                    .surface,
                              ),
                            ),
                            enabledBorder: borderStyle,
                            errorBorder: errorBorderStyle,
                            border: borderStyle,
                            focusedErrorBorder: errorBorderStyle,
                            contentPadding:
                            const EdgeInsetsDirectional.fromSTEB(
                                16, 0, 16, 0),
                          ),
                          onTapOutside: (value) {
                            _idFocusNode.unfocus();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .translateNested('error', 'notEmpty');
                            } else if (value.length > 30) {
                              return AppLocalizations.of(context)!
                                  .translateNested('error', 'length_exceed');
                            } else if (!RegExp(r'^[a-zA-Z0-9-_.]+$').hasMatch(value)) {
                              return AppLocalizations.of(context)!
                                  .translateNested('error', 'english_username');
                            } else if (value.length < 5) {
                              return AppLocalizations.of(context)!
                                  .translateNested('error', 'minimum_username_length');
                            }
                            return null;
                          },

                          onTap: () {
                            setState(() {
                              print(_idController.text);
                            });
                          },
                          onFieldSubmitted: (value) {
                            _idFocusNode.unfocus();

                          }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    if (state is RegisterFailure) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 16),
                        child: Text(
                          state.error,
                          style:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          editUserFunction(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                        BlocConsumer<RegisterBloc, RegisterState>(
                          listener: (context, state) {
                            if (state is RegisterFinished) {
                              Navigator.pushReplacementNamed(context, AppRoutes.home);
                            }
                          },
                          builder: (context, state) {
                            return state is RegisterLoading
                                ? WhiteCircularProgressIndicator()
                                : Text(
                              AppLocalizations.of(context)!
                                  .translateNested(
                                  'profileScreen', 'save'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                fontWeight: FontWeight.w400,
                                color: whiteColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void editUserFunction(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(EditUserEvent(
        name: _nameController.text,
        family: _lastNameController.text,
        username: _idController.text,
      ));
    }
  }
}
