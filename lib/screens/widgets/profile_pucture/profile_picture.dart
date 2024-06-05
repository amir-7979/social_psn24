import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../profile_cached_network_image.dart';
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
      ],
      cropStyle: CropStyle.circle,
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
        ),
        IOSUiSettings(
          title: '',
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
      final croppedFile = await _cropImage(File(pickedImage.path), context);
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
      child: SizedBox(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.transparent,
              child: pickedImage != null
                  ? Image.asset(pickedImage!.path)
                  : widget.photoUrl != null
                      ? ProfileCacheImage(widget.photoUrl!)
                      : Image.asset('assets/images/profile/profile2.svg',),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Container(
                padding: EdgeInsetsDirectional.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: cameraBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cameraBackgroundColor,
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
                            ),

                          ),
                        );
                      } else if (state is ProfilePictureSuccess) {
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
                              icon: SvgPicture.asset(
                                  'assets/images/profile/camera.svg'),
                              onPressed: () async {
                                await _pickImage(context);
                              },
                            );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
