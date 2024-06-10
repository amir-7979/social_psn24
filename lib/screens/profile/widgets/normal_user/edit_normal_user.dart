import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/profile/profile_bloc.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/setting_bloc.dart';
import '../../../../configs/setting/themes.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/profile_pucture/profile_picture.dart';
import '../../../widgets/white_circular_progress_indicator.dart';
import '../shimmer/shimmer_edit_normal_user.dart';

class EditNormalUser extends StatefulWidget {
  final Function refreshIndex;

  EditNormalUser(this.refreshIndex);

  @override
  State<EditNormalUser> createState() => _EditNormalUserState();
}

class _EditNormalUserState extends State<EditNormalUser> {
  final _formKey = GlobalKey<FormState>();
  bool isExpert = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _history = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _idFocusNode = FocusNode();
  final _historyFocusNode = FocusNode();
  final _bioFocusNode = FocusNode();
  String? photoUrl = null;
  Widget lastWidget = ShimmerEditNormalUser();

  void _newPickedImage(String? value) {
    if (value != null) {
      photoUrl = value;
    }
  }

  @override
  void initState() {
    super.initState();
    isExpert = BlocProvider.of<SettingBloc>(context).state.seeExpertPost ?? false;
    context.read<ProfileBloc>().add(FetchProfileForEditScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is EditProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(content: state.message).build(context),
          );
        } else if (state is EditProfileInfoLoaded) {
          widget.refreshIndex(0);
        }
      },
      builder: (context, state) {
        if (state is NewProfileInfoLoading) {
          lastWidget = const ShimmerEditNormalUser();
        } else if (state is NewProfileInfoLoaded) {
          photoUrl = state.profile.photo;
          _nameController.text = state.profile.name ??
              AppLocalizations.of(context)!.translateNested('params', 'name');
          _lastNameController.text = state.profile.family ??
              AppLocalizations.of(context)!.translateNested('params', 'family');
          _idController.text = state.profile.username ??
              AppLocalizations.of(context)!
                  .translateNested('params', 'username');
          _history.text = state.profile.experience ?? '';
          _bio.text = state.profile.biography ?? '';
          lastWidget = buildListView(context);
        } else if (state is NewProfileError) {
          lastWidget = Padding(
            padding: const EdgeInsetsDirectional.only(top: 16),
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsetsDirectional.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Center(
                child: Text(
                  'خطا در دریافت اطلاعات',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ),
          );
        }
        return lastWidget; // return an empty container if lastWidget is null
      },
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
                              // Set text direction to ltr

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
                                // Add this line

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
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                if (isExpert) {
                                  FocusScope.of(context)
                                      .requestFocus(_historyFocusNode);
                                } else {
                                  FocusScope.of(context).unfocus();
                                }
                              }),
                        ),
                        if (isExpert)
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _history,
                              keyboardType: TextInputType.name,
                              focusNode: _historyFocusNode,
                              decoration: InputDecoration(
                                label: Text(
                                  AppLocalizations.of(context)!.translateNested(
                                      'profileScreen', 'experience'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: _historyFocusNode.hasFocus
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
                                if (value!.isEmpty || value.length < 30) {
                                  return null;
                                }
                                return AppLocalizations.of(context)!
                                    .translateNested('error', 'length_exceed');
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_bioFocusNode);
                              },
                            ),
                          ),
                        if (isExpert)
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(bottom: 16.0),
                            child: TextFormField(
                              controller: _bio,
                              focusNode: _bioFocusNode,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                label: Text(
                                  AppLocalizations.of(context)!
                                      .translateNested('params', 'biography'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: _bioFocusNode.hasFocus
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
                                if (value!.isEmpty || value.length < 300) {
                                  return null;
                                }
                                return AppLocalizations.of(context)!
                                    .translateNested('error', 'length_exceed');
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<ProfileBloc, ProfileState>(
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
                            widget.refreshIndex(0);
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
                            child: BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                return state is EditProfileInfoLoading
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
      context.read<ProfileBloc>().add(EditProfile(
            name: _nameController.text,
            family: _lastNameController.text,
            photoUrl: photoUrl,
            experience: isExpert ? _history.text : null,
            biography: isExpert ? _bio.text : null,
            username: _idController.text,
          ));
    }
  }
}
