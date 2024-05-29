import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/profile/profile_bloc.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/themes.dart';
import '../../../widgets/profile_pucture/profile_picture.dart';
import '../shimmer/shimmer_edit_normal_user.dart';

class EditNormalUser extends StatefulWidget {
  final Function refreshIndex;

  EditNormalUser(this.refreshIndex);

  @override
  State<EditNormalUser> createState() => _EditNormalUserState();
}

class _EditNormalUserState extends State<EditNormalUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _idFocusNode = FocusNode();
  String? photoUrl;

  void _newPickedImage(String? value) {
    BlocProvider.of<ProfileBloc>(context).add(PhotoUploadEvent(value));
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInfoLoading) {
          return const ShimmerEditNormalUser();
        } else if (state is ProfileInfoLoaded) {
          photoUrl = state.profile.photo;

          _nameController.text = state.profile.name ??
              AppLocalizations.of(context)!.translateNested('params', 'name');
          _lastNameController.text = state.profile.family ??
              AppLocalizations.of(context)!.translateNested('params', 'family');
          _idController.text = state.profile.username ??
              AppLocalizations.of(context)!
                  .translateNested('params', 'username');

          return buildListView(context);
        } else if (state is ProfileError) {
          return Padding(
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
        } else {
          return buildListView(context);
        }
      },
    );
  }

  Widget buildListView(BuildContext context) {
    return Column(
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
                    height: 150,
                    width: 150,
                    child: Center(
                      child: ProfilePicture(photoUrl, _newPickedImage),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!
                          .translateNested("profileScreen", 'UserInfo'),
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
                        padding: const EdgeInsetsDirectional.only(bottom: 16.0),
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
                                        : Theme.of(context).colorScheme.surface,
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
                        padding: const EdgeInsetsDirectional.only(bottom: 16.0),
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
                                        : Theme.of(context).colorScheme.surface,
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
                                  .translateNested('error', 'persian_lastname');
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
                        padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                        child: TextFormField(
                          controller: _idController,
                          focusNode: _idFocusNode,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
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
                                        : Theme.of(context).colorScheme.surface,
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
                            } else if (value.length > 30) {
                              return AppLocalizations.of(context)!
                                  .translateNested('error', 'length_exceed');
                            } else if (!RegExp(r'^[a-zA-Z0-9-_.]+$')
                                .hasMatch(value)) {
                              return AppLocalizations.of(context)!
                                  .translateNested('error', 'english_username');
                            }
                            return null;
                          },
                          onFieldSubmitted: (value) {
                            editUserFunction(context);
                            FocusScope.of(context).unfocus();
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
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                        child: ElevatedButton(
                      onPressed: () {
                        widget.refreshIndex(0);
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        //foregroundColor: Theme.of(context).colorScheme.tertiary,
                        backgroundColor: Color(0x3300A6ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translateNested('profileScreen', 'return'),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                    )),
                    const SizedBox(width: 16),
                    Expanded(
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
                        child: BlocConsumer<ProfileBloc, ProfileState>(
                          listener: (context, state) {
                            if (state is EditProfileInfoLoaded) {
                              widget.refreshIndex(0);
                            }
                          },
                          builder: (context, state) {
                            return state is EditProfileInfoLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
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
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void editUserFunction(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
            EditProfile(
              name: _nameController.text,
              family: _lastNameController.text,
              id: _idController.text,
            ),
          );
    }
  }
}
