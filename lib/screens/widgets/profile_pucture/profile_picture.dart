import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../configs/localization/app_localizations.dart';
import 'profile_picture_bloc.dart';

class ProfilePicture extends StatefulWidget {
  final String? photoUrl;
  Function onImagePicked;

  ProfilePicture(this.photoUrl, this.onImagePicked);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? pickedImage;
  File? croppedFile;

  Future<File?> _cropImage(File imageFile, context) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Theme.of(context).primaryColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    if (croppedFile != null) {
      return File(croppedFile.path);
    }

    return null;
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      print(pickedImage.path);
      croppedFile = await _cropImage(File(pickedImage.path), context);
      if (croppedFile != null) {
        BlocProvider.of<ProfilePictureBloc>(context)
            .add(UploadProfilePicture(croppedFile));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => ProfilePictureBloc(),
  child: Stack(
      alignment: Alignment.bottomLeft,
      children: [
        CircleAvatar(
          radius: 200,
          backgroundImage: pickedImage != null
              ? Image.file(pickedImage!).image
              : widget.photoUrl != null
                  ? Image.network(widget.photoUrl!).image
                  : const AssetImage('assets/images/profile/profile.png'),
        ),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.background,
              width: 3,
            ),
          ),
          child: BlocConsumer<ProfilePictureBloc, ProfilePictureState>(
            listener: (context, state) {
              if (state is ProfilePictureFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!
                          .translateNested('error', 'profileUploadException'),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }else if (state is ProfilePictureSuccess) {
                setState(() {
                  if (croppedFile != null)
                  pickedImage = File(croppedFile!.path);
                });
                widget.onImagePicked(state.imageUrl);
              }
            },
            builder: (context, state) {
              return state is ProfilePictureLoading
                  ? Padding(
                      padding: const EdgeInsetsDirectional.all(8.0),
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 2,
                      ),
                    )
                  : IconButton(
                      icon:
                          SvgPicture.asset('assets/images/profile/camera.svg'),
                      onPressed: () async {
                        await _pickImage(context);
                      },
                    );
            },
          ),
        ),
      ],
    ),
);
  }
}
