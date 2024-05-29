import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_psn/screens/profile/profile_bloc.dart';
import 'package:social_psn/screens/profile/widgets/shimmer/shimmer_edit_expert_user.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/setting_bloc.dart';
import '../../../../configs/setting/themes.dart';
import '../../../widgets/profile_pucture/profile_picture.dart';

class EditExpertUser extends StatefulWidget {
  final Function refreshIndex;
  bool isFetchProfileFirstTime = true;
  EditExpertUser(this.refreshIndex);
  @override
  State<EditExpertUser> createState() => _EditExpertUserState();
}

class _EditExpertUserState extends State<EditExpertUser> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _history = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _field = TextEditingController();
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNodes = [];
  final _nameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _usernameFocusNode = FocusNode();
  final _historyFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _bioFocusNode = FocusNode();
  final _fieldFocusNode = FocusNode();
  String? photoUrl;
  final ScrollController _scrollController = ScrollController();

  void _newPickedImage(String? value) {
    BlocProvider.of<ProfileBloc>(context).add(PhotoUploadEvent(value));

  }

  void _addTextField() {
    _controllers.add(TextEditingController());
    _focusNodes.add(FocusNode());
    setState(() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 36,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeTextField(int index) {
    _controllers.removeAt(index);
    _focusNodes.removeAt(index);
    setState(() {});
  }

  @override
  void initState() {
    context.read<ProfileBloc>().add(EditProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInfoLoading) {
          return const ShimmerEditExpertUser();
        } else if (state is ProfileInfoLoaded) {
          photoUrl = state.profile.photo;
          _nameController.text = state.profile.name ?? '';
          _lastNameController.text = state.profile.family ?? '';
          _usernameController.text = state.profile.username ?? '';
          _history.text = state.profile.experience ?? '';
          _address.text = state.profile.address ?? '';
          _bio.text = state.profile.biography ?? '';
          _field.text = state.profile.field ?? '';
          _controllers = state.profile.offices!.map((e) => TextEditingController(text: e)).toList();
          _focusNodes = state.profile.offices!.map((e) => FocusNode()).toList();
          return buildListView(context);
        } else if(state is ProfileError){
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
        }else{
          return buildListView(context);

        }
      },
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
    controller: _scrollController,
    children: [
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Container(
                height: 150,
                width: 150,
                child: Center(
                  child: ProfilePicture(photoUrl, _newPickedImage)
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
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
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
              key: _formKey1,
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
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
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
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
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
                            .requestFocus(_usernameFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
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
                            color: _lastNameFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        enabledBorder: borderStyle,
                        errorBorder: errorBorderStyle,
                        border: borderStyle,
                        focusedErrorBorder: errorBorderStyle,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
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
                            .requestFocus(_historyFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _history,
                      keyboardType: TextInputType.name,
                      focusNode: _historyFocusNode,
                      decoration: InputDecoration(
                        label: Text(
                          AppLocalizations.of(context)!
                              .translateNested('profileScreen', 'experience'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                            fontWeight: FontWeight.w400,
                            color: _historyFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        enabledBorder: borderStyle,
                        errorBorder: errorBorderStyle,
                        border: borderStyle,
                        focusedErrorBorder: errorBorderStyle,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
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
                            .requestFocus(_addressFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _address,
                      focusNode: _addressFocusNode,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: Text(
                          AppLocalizations.of(context)!
                              .translateNested('profileScreen', 'address'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                            fontWeight: FontWeight.w400,
                            color: _addressFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        enabledBorder: borderStyle,
                        errorBorder: errorBorderStyle,
                        border: borderStyle,
                        focusedErrorBorder: errorBorderStyle,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            16, 0, 16, 0),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 100) {
                          return null;
                        }
                        return AppLocalizations.of(context)!
                            .translateNested('error', 'length_exceed');
                      },
                      onFieldSubmitted: (value) {
                        print('_address.text');
                        print(_address.text);
                        FocusScope.of(context).requestFocus(_bioFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 16.0),
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
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        enabledBorder: borderStyle,
                        errorBorder: errorBorderStyle,
                        border: borderStyle,
                        focusedErrorBorder: errorBorderStyle,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            16, 0, 16, 0),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 300) {
                          return null;
                        }
                        return AppLocalizations.of(context)!
                            .translateNested('error', 'length_exceed');
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_fieldFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                    child: TextFormField(
                      controller: _field,
                      focusNode: _fieldFocusNode,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: Text(
                          AppLocalizations.of(context)!
                              .translateNested('profileScreen', 'field'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                            fontWeight: FontWeight.w400,
                            color: _bioFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        enabledBorder: borderStyle,
                        errorBorder: errorBorderStyle,
                        border: borderStyle,
                        focusedErrorBorder: errorBorderStyle,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            16, 0, 16, 0),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 50) {
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .translateNested("params", 'offices'),
                      style:
                      Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // i need a plus icon with text 'افزودن' in primary color
                    GestureDetector(
                      onTap: _addTextField,
                      child: Row(
                        children: [
                          Icon(
                            Icons.add, // This is the plus icon
                            color: Theme.of(context).primaryColor,
                          ),
                          Text(
                            AppLocalizations.of(context)!
                                .translateNested("profileScreen", 'add'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
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
              key: _formKey2,
              child: Column(
                children: _controllers.asMap().entries.map((entry) {
                  int idx = entry.key;
                  TextEditingController controller = entry.value;
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: TextFormField(
                              controller: controller,
                              focusNode: _focusNodes[idx],
                              decoration: InputDecoration(
                                label: Text(
                                  AppLocalizations.of(context)!
                                      .translateNested(
                                      'profileScreen', 'officeName'),
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
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => _removeTextField(idx),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).colorScheme.error,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                'assets/images/profile/xmark.svg',
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
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
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
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
                              .translateNested('profileScreen', 'save'),
                          style: Theme
                              .of(context)
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
    ],
  );
  }


  void editUserFunction(BuildContext context) {
    if (_formKey1.currentState!.validate() &&
        _formKey1.currentState!.validate()) {
      List<String> offices =
          _controllers.map((controller) => controller.text).toList();

      context.read<ProfileBloc>().add(
            EditProfile(
              name: _nameController.text,
              family: _lastNameController.text,
              biography: _bio.text,
              experience: _history.text,
              address: _address.text,
              field: _field.text,
              office: offices,
              username: _usernameController.text,
            ),
          );
    }
  }
}
