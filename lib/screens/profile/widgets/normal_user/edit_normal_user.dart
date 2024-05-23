import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_psn/screens/profile/profile_bloc.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/themes.dart';
import '../shimmer/shimmer_edit_normal_user.dart';

class EditNormalUser extends StatefulWidget {
  bool isFetchProfileFirstTime = true;

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
  File? _pickedImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _pickedImage = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if(widget.isFetchProfileFirstTime) {
      print('fetch profile');
      context.read<ProfileBloc>().add(FetchProfile());
      widget.isFetchProfileFirstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) {
        print('previous: $previous');
        print('current: $current');
        if (current is ProfileInfoLoaded && previous is ProfileInfoLoading) {
          return true;
        }
        return false;
      },
        builder: (context, state) {
          print('state: $state');
      if (state is ProfileInfoLoading || state is ProfileInitial) {
        return const ShimmerEditNormalUser();
      } else if (state is ProfileInfoLoaded) {
        _nameController.text = state.profile.name ?? AppLocalizations.of(context)!
            .translateNested('params', 'name');
        _lastNameController.text = state.profile.family ?? AppLocalizations.of(context)!
            .translateNested('params', 'family');
        _idController.text = state.profile.username ?? AppLocalizations.of(context)!
            .translateNested('params', 'username');

        return buildListView(context);
      }else{
        return Padding(
          padding: const EdgeInsetsDirectional.only(top: 16),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsetsDirectional.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme
                  .of(context)
                  .colorScheme
                  .background,
            ),
            child: Center(
              child: Text('خطا در دریافت اطلاعات', style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).primaryColor,
              ),),
            ),
          ),
        );
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
                color: Theme
                    .of(context)
                    .colorScheme
                    .background,
              ),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            CircleAvatar(
                              radius: 200,
                              backgroundImage: _pickedImage != null
                                  ? Image
                                  .file(_pickedImage!)
                                  .image
                                  : const AssetImage(
                                  'assets/images/profile/profile.png'),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: cameraBackgroundColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                  Theme
                                      .of(context)
                                      .colorScheme
                                      .background,
                                  width: 3,
                                ),
                              ),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                    'assets/images/profile/camera.svg'),
                                onPressed: _pickImage,
                              ),
                            ),
                          ],
                        ),
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
                        Theme
                            .of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme
                                  .of(context)
                                  .primaryColor
                                  .withOpacity(0),
                              Theme
                                  .of(context)
                                  .primaryColor
                                  .withOpacity(1),
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
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: _nameFocusNode.hasFocus
                                      ? Theme
                                      .of(context)
                                      .primaryColor
                                      : Theme
                                      .of(context)
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
                              if (value!.isNotEmpty) {
                                return null;
                              }
                              return AppLocalizations.of(context)!
                                  .translateNested('error', 'notEmpty');
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
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: _lastNameFocusNode.hasFocus
                                      ? Theme
                                      .of(context)
                                      .primaryColor
                                      : Theme
                                      .of(context)
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
                              if (value!.isNotEmpty) {
                                return null;
                              }
                              return AppLocalizations.of(context)!
                                  .translateNested('error', 'notEmpty');
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_idFocusNode);
                            },
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsetsDirectional.only(bottom: 16.0),
                          child: TextFormField(
                            controller: _idController,
                            focusNode: _idFocusNode,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              label: Text(
                                AppLocalizations.of(context)!
                                    .translateNested('params', 'username'),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: _idFocusNode.hasFocus
                                      ? Theme
                                      .of(context)
                                      .primaryColor
                                      : Theme
                                      .of(context)
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
                              if (value!.isNotEmpty) {
                                return null;
                              }
                              return AppLocalizations.of(context)!
                                  .translateNested('error', 'notEmpty');
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ProfileBloc>()
                                  .add(NavigateToInitialScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme
                                  .of(context)
                                  .colorScheme
                                  .tertiary
                                  .withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translateNested('profileScreen', 'return'),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .tertiary,
                              ),
                            ),
                          )),
                      const SizedBox(width: 16),
                      Expanded(
                        child: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                editUserFunction(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: state is EditProfileInfoLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                                  : Text(
                                AppLocalizations.of(context)!
                                    .translateNested('profileScreen', 'save'),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor,
                                ),
                              ),
                            );
                          },
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
          photo: _pickedImage?.path,
          // Add other fields here
        ),
      );
    }
  }
}
