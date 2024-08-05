import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/post_media.dart';
import '../../widgets/white_circular_progress_indicator.dart';
import '../create_post_bloc.dart';
import 'media_item.dart';


class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  List<PostMedia> postMedias = [];
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _longTextController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _longTextFocusNode = FocusNode();
  String? _selectedCategory;
  final advanceSwitchController = ValueNotifier<bool>(false);
  List<String> _categories = ['Category 1', 'Category 2', 'Category 3'];
  final int _maxLength = 200; // Set your max length here
  File? lastPickedImage;
  File? cropPath;
  final picker = ImagePicker();
  bool firstTime = false;
  @override
  void initState() {
    super.initState();
    _longTextController.addListener(_updateCounter);
  }

  @override
  void dispose() {
    _longTextController.removeListener(_updateCounter);
    super.dispose();
  }

  void _updateCounter() {
    setState(() {});
  }

  Future<File?> _cropImage(String imageAddress, context) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageAddress,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0), // Use aspectRatio instead of aspectRatioPresets

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Theme.of(context).primaryColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: true,
          cropGridColor: Colors.transparent,
          cropFrameColor: Theme.of(context).colorScheme.tertiary,
          cropStyle: CropStyle.rectangle,
        ),
        IOSUiSettings(
          title: '',
          cropStyle: CropStyle.rectangle,
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }

    return null;
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedXFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedXFile != null) {
      final croppedFile = await _cropImage(pickedXFile.path, context);
      if (croppedFile != null) {
        cropPath = croppedFile;
        BlocProvider.of<CreatePostBloc>(context)
            .add(UploadMediaEvent(croppedFile));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          AppLocalizations.of(context)!
              .translateNested("createMedia", 'createMedia'),
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 8),
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
        SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                keyboardType: TextInputType.name,
                focusNode: _titleFocusNode,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                decoration: InputDecoration(
                  label: Text(
                    AppLocalizations.of(context)!
                        .translateNested("params", "name"),
                    style:
                    Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: _titleFocusNode.hasFocus
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
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  _categoryFocusNode.requestFocus();
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                focusNode: _categoryFocusNode,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                decoration: InputDecoration(
                  label: Text(
                    AppLocalizations.of(context)!
                        .translateNested("createMedia", "category"),
                    style:
                    Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: _titleFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).hintColor,
                    ),
                  ),
                  enabledBorder: borderStyle,
                  errorBorder: errorBorderStyle,
                  border: borderStyle,
                  focusedErrorBorder: errorBorderStyle,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /* if (_categoryController.text.isNotEmpty) // Add second delete icon when there is text in the TextFormField
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.onBackground),
                                    onPressed: () {
                                      _categoryController.clear();
                                    },
                                  ),
                                PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  iconColor: Theme.of(context).colorScheme.onBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Theme.of(context).colorScheme.background,
                                  itemBuilder: (context) => _categories.map((String category) {
                                    return PopupMenuItem<String>(
                                      value: category,
                                      child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            category,
                                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context).colorScheme.shadow,
                                            ),
                                          )),
                                    );
                                  }).toList(),
                                  onSelected: (String? newValue) {
                                    setState(() {
                                      _selectedCategory = newValue;
                                      _categoryController.text = newValue!;
                                    });
                                  },
                                ),*/
                    ],
                  ),
                ),
                /*onEditingComplete: () {
                            setState(() {});
                          },*/

                onChanged: (value) {
                  setState(() {});
                },
                onFieldSubmitted: (value) {
                  _longTextFocusNode.requestFocus();
                },
              ),
              SizedBox(height: 16),
              Container(
                height: 130.0,
                child: TextFormField(
                  focusNode: _longTextFocusNode,
                  controller: _longTextController,
                  maxLines: 50,
                  // expands: true,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  maxLength: _maxLength,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translateNested("createMedia", "text"),
                    labelStyle:
                    Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: _longTextFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).hintColor,
                    ),
                    alignLabelWithHint: true,
                    constraints: BoxConstraints(
                      minHeight: 130.0,
                    ),
                    enabledBorder: borderStyle,
                    errorBorder: errorBorderStyle,
                    border: borderStyle,
                    focusedErrorBorder: errorBorderStyle,
                  ),
                  buildCounter: (context,
                      {required currentLength,
                        required maxLength,
                        required bool isFocused}) {
                    return Text(
                      '$_maxLength/$currentLength',
                      style:
                      Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: _longTextFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).hintColor,
                      ),
                      //from setting state see that language is persian or english
                    );
                  },
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .translateNested("createMedia", "type"),
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).hoverColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            AdvancedSwitch(
              controller: advanceSwitchController,
              thumb: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 0, 2),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                  ),
                ),
              ),
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Theme.of(context).hintColor,
              height: 25,
              width: 90,
              inactiveChild: Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: Text(
                  AppLocalizations.of(context)!
                      .translateNested("createMedia", "expert"),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: whiteColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              activeChild: Padding(
                padding: const EdgeInsetsDirectional.only(start: 10),
                child: Text(
                  AppLocalizations.of(context)!
                      .translateNested("createMedia", "general"),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.shadow,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              onChanged: (value) {
                //todo add later
              },
            ),
          ],
        ),
        SizedBox(height: 16),
        InkWell(
          onTap: () {
            _pickImage(context);
          },
          child: DottedBorder(
            color: Theme.of(context).colorScheme.surface,
            strokeWidth: 1,
            dashPattern: [8, 4],
            borderType: BorderType.RRect,
            radius: Radius.circular(16),
            padding: EdgeInsets.all(16),
            child: BlocListener<CreatePostBloc, CreatePostState>(
              listener: (context, state) {
                if (state is MediaDeleted) {
                  postMedias.removeWhere((element) => element.id == state.mediaId);
                  setState(() {

                  });
                }else if (state is MediaUploaded) {
                  print('media uploaded');
                  postMedias.add(state.postMedia);
                  setState(() {

                  });
                }
              },
              child: Container(
                height: 170,
                child: (postMedias.isEmpty) ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //load upload.png
                    Image.asset('assets/images/post/upload.png', height: 100, width: 100),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .translateNested("createMedia", "upload"),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ) : ListView(
                  children: [
                    for (var media in postMedias)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: MediaItem(media),
                      ),
                  ],
                ),
              ),
),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                    //todo upload media
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: BlocBuilder<CreatePostBloc, CreatePostState>(
                    builder: (context, state) {
                      return state is SubmittingPostLoading
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
    );
  }
}
