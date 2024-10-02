import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';

import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/themes.dart';
import '../../repos/models/profile.dart';
import '../main/widgets/screen_builder.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/dialogs/my_alert_dialog.dart';
import '../widgets/profile_pucture/profile_picture.dart';
import '../widgets/white_circular_progress_indicator.dart';
import 'edit_profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  Profile profile = Profile();
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

  @override
  void initState() {
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    profile = ModalRoute.of(context)?.settings.arguments as Profile;
    _nameController.text = profile.name ?? '';
    _lastNameController.text = profile.family ?? '';
    _idController.text = profile.username ?? '';
    photoUrl = profile.photo ?? '';
  }

  void _newPickedImage(String? value) {
    if (value != null) {
      photoUrl = value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      child: BlocProvider(
        create: (context) => EditProfileBloc(),
        child: Builder(builder: (context) {
          return BlocConsumer<EditProfileBloc, EditProfileState>(
            listener: (context, state) {
              if (state is EditProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar(content: state.message).build(context));
              } else if (state is EditProfileSuccess) {
                BlocProvider.of<SettingBloc>(context)
                    .add(FetchUserProfileWithPermissionsEvent());
                Navigator.pushReplacementNamed(context, AppRoutes.myProfile);
              }
            },
            builder: (context, state) {
              return buildListView(context);
            },
          );
        }),
      ),
    );
  }

  Widget buildListView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
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
                            .translateNested("profileScreen", 'editUserInfo'),
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                } else if (value.length > 30) {
                                  return AppLocalizations.of(context)!
                                      .translateNested(
                                          'error', 'length_exceed');
                                } else if (!RegExp(r'^[a-zA-Z0-9-_.]+$')
                                    .hasMatch(value)) {
                                  return AppLocalizations.of(context)!
                                      .translateNested(
                                          'error', 'english_username');
                                } else if (value.length < 5) {
                                  return AppLocalizations.of(context)!
                                      .translateNested(
                                          'error', 'minimum_username_length');
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {}),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<EditProfileBloc, EditProfileState>(
                      builder: (context, state) {
                    if (state is EditProfileError) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 16),
                        child: Text(
                          state.message,
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
                            BuildContext editProfileContext = context;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MyAlertDialog(
                                  title: AppLocalizations.of(context)!
                                      .translateNested(
                                          'dialog', 'deleteMediaTitle'),
                                  description: AppLocalizations.of(context)!
                                      .translateNested(
                                          'dialog', 'deleteMediaDescription'),
                                  cancelText: AppLocalizations.of(context)!
                                      .translateNested('dialog', 'no'),
                                  confirmText: AppLocalizations.of(context)!
                                      .translateNested('dialog', 'yes'),
                                  returnText: AppLocalizations.of(context)!
                                      .translateNested('profileScreen', 'return'),
                                  onReturn: () {
                                    Navigator.pop(context);
                                  },
                                  onCancel: () {
                                    Navigator.pop(context);
                                    Navigator.pop(editProfileContext);
                                  },
                                  onConfirm: () {
                                    editUserFunction(context);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Color(0x3300A6ED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!
                                .translateNested('profileScreen', 'return'),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                          ),
                        ),
                      )),
                      const SizedBox(width: 16),
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
                                BlocBuilder<EditProfileBloc, EditProfileState>(
                              builder: (context, state) {
                                return state is EditProfileLoading
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
        ],
      ),
    );
  }

  void editUserFunction(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<EditProfileBloc>().add(SubmitEditProfileEvent(
            name: _nameController.text,
            family: _lastNameController.text,
            username: _idController.text,
            photoUrl: photoUrl,
          ));
    }
  }
}
