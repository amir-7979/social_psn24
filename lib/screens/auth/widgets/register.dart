import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../auth_bloc.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _idFocusNode = FocusNode();
  bool _isChecked = false;
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idController = TextEditingController();

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
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16),
        Center(
          child: Text(
            AppLocalizations.of(context)!.translateNested("auth", "register"),
            style: iranYekanTheme.displayLarge!.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 16.0),
          child: Center(
            child: Container(
              height: 180,
              width: 180,
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    CircleAvatar(
                      radius: 200,
                      backgroundImage: _pickedImage != null
                          ? Image.file(_pickedImage!).image
                          : AssetImage('assets/images/profile/profile.png'),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: cameraBackgroundColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.background,
                          width: 3,
                        ),
                      ),
                      child: IconButton(
                        icon: SvgPicture.asset(
                            'assets/images/profile/camera.svg'),
                        onPressed: () async {
                          await _pickImage();
                          BlocProvider.of<AuthBloc>(context).add(PhotoUploadEvent(_pickedImage!));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
            child: Text(
              AppLocalizations.of(context)!
                  .translateNested("auth", "insertInformation"),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).hoverColor,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        ),
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
                          .translateNested("params", "name"),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: _nameFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).hintColor,
                          ),
                    ),
                    enabledBorder: borderStyle,
                    errorBorder: errorBorderStyle,
                    border: borderStyle,
                    focusedErrorBorder: errorBorderStyle,
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                    FocusScope.of(context).requestFocus(_lastNameFocusNode);
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
                          .translateNested("params", "family"),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: _lastNameFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).hintColor,
                          ),
                    ),
                    enabledBorder: borderStyle,
                    errorBorder: errorBorderStyle,
                    border: borderStyle,
                    focusedErrorBorder: errorBorderStyle,
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
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
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                child: TextFormField(
                  controller: _idController,
                  focusNode: _idFocusNode,
                  decoration: InputDecoration(
                    label: Text(
                      AppLocalizations.of(context)!
                          .translateNested("params", "username"),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: _idFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).hintColor,
                          ),
                    ),
                    enabledBorder: borderStyle,
                    errorBorder: errorBorderStyle,
                    border: borderStyle,
                    focusedErrorBorder: errorBorderStyle,
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translateNested('error', 'notEmpty');
                    } else if (value.length > 30) {
                      return AppLocalizations.of(context)!
                          .translateNested('error', 'length_exceed');
                    } else if (!RegExp(r'^[a-zA-Z0-9-_.]+$').hasMatch(value)) {
                      return AppLocalizations.of(context)!
                          .translateNested('error', 'english_username');
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10, start: 2),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: _isChecked
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: _isChecked
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).hintColor,
                        width: 1,
                      ),
                      //i want square
                      shape: BoxShape.rectangle,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      )),
                  child: _isChecked
                      ? const Icon(
                          Icons.check,
                          size: 18.0,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: Text.rich(
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).hoverColor,
                      fontWeight: FontWeight.w400,
                    ),
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!
                          .translateNested('auth', 'terms1'),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => print('Link clicked'),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!
                          .translateNested('auth', 'terms2'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is AuthFailure) {
            return Text(
              state.error,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w400,
                  ),
            );
          } else {
            return Container();
          }
        }),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 16.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() && _isChecked) {
                    _formKey.currentState!.save();
                    if (state is! AuthLoading) {
                      BlocProvider.of<AuthBloc>(context).add(
                        EditUserEvent(
                            _nameController.text,
                            _lastNameController.text,
                            _idController.text,
                            1,
                            _pickedImage?.path),
                      );
                    }
                  }
                },
                child: state is AuthLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
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
              );
            },
          ),
        ),
      ],
    );
  }
}
