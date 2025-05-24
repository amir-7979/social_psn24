import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_psn/screens/widgets/shimmer.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../profile_cached_network_image.dart';
import 'profile_attachment_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';



class ProfileAttachment extends StatefulWidget {
  String name;
  String? photoUrl;
  Function onImagePicked;

  ProfileAttachment(this.name, this.photoUrl, this.onImagePicked);

  @override
  State<ProfileAttachment> createState() => _ProfileAttachmentState();
}

class _ProfileAttachmentState extends State<ProfileAttachment> {
  File? lastPickedImage;
  File? cropPath;
  final picker = ImagePicker();
  bool firstTime = false;

  Future<File?> _cropImage(String imageAddress, context) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageAddress,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
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
        BlocProvider.of<ProfileAttachmentBloc>(context)
            .add(UploadProfileAttachment(widget.name, pickedXFile.name, croppedFile));
      }
    }
  }

  Future<void> _pickImageFromCamera(BuildContext parentContext) async {
    final pickedXFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedXFile != null) {
      final croppedFile = await _cropImage(pickedXFile.path, parentContext);
      if (croppedFile != null) {
        cropPath = croppedFile;
        // Use the parent's context that contains the ProfileAttachmentBloc
        BlocProvider.of<ProfileAttachmentBloc>(parentContext)
            .add(UploadProfileAttachment(widget.name, pickedXFile.name, croppedFile));
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    // Check current status
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    // Request permission
    var result = await Permission.storage.request();
    if (result.isGranted) {
      return true;
    } else if (result.isPermanentlyDenied) {
      // Open app settings so the user can manually grant permission
      await openAppSettings();
      return false;
    }

    // If not granted
    return false;
  }

  Future<bool> _requestMediaPermission() async {
    // For Android 13+ (API level 33/34), use READ_MEDIA_IMAGES instead of storage.
    if (Platform.isAndroid) {
      // Check if the new permission is granted.
      var status = await Permission.photos.status; // On Android 13+, this maps to READ_MEDIA_IMAGES.
      if (status.isGranted) {
        return true;
      }
      var result = await Permission.photos.request();
      if (result.isGranted) {
        return true;
      } else if (result.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      return false;
    } else {
      // For other platforms (or if you're still using storage permission on older Android versions)
      var status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      }
      var result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else if (result.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }
      return false;
    }
  }

  /// Downloads and saves the profile Attachment if a valid URL is provided.
  Future<void> _saveProfileAttachment() async {
    // Only proceed if we have a valid image URL
    if (widget.photoUrl == null) {
      print("No image URL available to download");
      return;
    }

    // Request media permission.
    bool hasPermission = await _requestMediaPermission();
    if (!hasPermission) {
      print("Required media permission not granted");
      return;
    }

    try {
      // Download the image from the URL
      final response = await http.get(Uri.parse(widget.photoUrl!));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Determine the directory based on the platform
        Directory? directory;
        if (Platform.isAndroid) {
          // Using Downloads folder on Android
          directory = Directory("/storage/emulated/0/Download");
        } else if (Platform.isIOS) {
          // Use application documents directory on iOS
          directory = await getApplicationDocumentsDirectory();
        }

        if (directory == null) {
          print("Failed to get storage directory");
          return;
        }

        // Create a unique file name and save the file
        String fileName = "profile_Attachment_${DateTime.now().millisecondsSinceEpoch}.png";
        String filePath = '${directory.path}/$fileName';
        File file = File(filePath);
        await file.writeAsBytes(bytes);
        print("Image saved to $filePath");

        // For Android: Trigger the media scanner so the image appears in the gallery
        if (Platform.isAndroid) {
          const platform = MethodChannel('com.example.myapp/media_scanner');
          try {
            await platform.invokeMethod('scanFile', {"path": filePath});
          } on PlatformException catch (e) {
            print("Error scanning file: $e");
          }
        }
      } else {
        print("Error downloading image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _showOptionsBottomSheet(BuildContext context) async {
    final parentContext = context;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _pickImage(parentContext);
                    Navigator.pop(context);

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.photo_library,
                            color: Theme.of(parentContext).colorScheme.onBackground),
                        SizedBox(width: 16),
                        Text(
                          AppLocalizations.of(context)!
                              .translateNested(
                              'profileScreen', 'fromGallery'),
                          style: TextStyle(
                              color: Theme.of(parentContext).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pickImageFromCamera(parentContext); // Pass parent's context here
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt,
                            color: Theme.of(parentContext).colorScheme.onBackground),
                        SizedBox(width: 16),
                        Text(
                          AppLocalizations.of(context)!
                              .translateNested(
                              'profileScreen', 'fromCamera'),
                          style: TextStyle(
                              color: Theme.of(parentContext).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.photoUrl != null)
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _saveProfileAttachment();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(Icons.save_alt,
                              color: Theme.of(parentContext).colorScheme.onBackground),
                          SizedBox(width: 16),
                          Text(
                            AppLocalizations.of(context)!
                                .translateNested(
                                'profileScreen', 'saveAttachment'),
                            style: TextStyle(
                                color: Theme.of(parentContext).colorScheme.onBackground),
                          ),
                        ],
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _removeProfileAttachment();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.delete,
                            color: Theme.of(parentContext).colorScheme.onBackground),
                        SizedBox(width: 16),
                        Text(
                          AppLocalizations.of(context)!
                              .translateNested(
                              'profileScreen', 'removeAttachment'),
                          style: TextStyle(
                              color: Theme.of(parentContext).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeProfileAttachment() {
    context.read<ProfileAttachmentBloc>().add(RemoveProfileAttachmentEvent());
    setState(() {
      lastPickedImage = null;
      widget.photoUrl = null;
      cropPath = null;
    });

  }


  @override
  void initState() {
    firstTime = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => ProfileAttachmentBloc(),
  child: GestureDetector(
      onTap: () => _showOptionsBottomSheet(context),
      child: SizedBox(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            ClipOval(
              child: BlocBuilder<ProfileAttachmentBloc, ProfileAttachmentState>(
  builder: (context, state) {
    return SizedBox.fromSize(
                  size: Size.fromRadius(75),
                 child: (state is ProfileAttachmentLoading)? shimmerCircular(context, size: 75) : (state is ProfileAttachmentSuccess)?
                     
                  ProfileCacheImage(state.imageUrl): (state is ProfileAttachmentRemove)? Image.asset(
                    'assets/images/profile/profile.png',
                    fit: BoxFit.cover,
                  ): (widget.photoUrl != null)? ProfileCacheImage(widget.photoUrl!): Image.asset(
                    'assets/images/profile/profile.png',
                    fit: BoxFit.cover,
                  ),
                 /* child: firstTime && widget.photoUrl != null
                      ? ProfileCacheImage(widget.photoUrl!)
                      : lastPickedImage != null
                      ? Image.file(lastPickedImage!, fit: BoxFit.cover)
                      : Image.asset(
                    'assets/images/profile/profile.png',
                    fit: BoxFit.cover,
                  ),*/
                );
  },
),
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
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: cameraBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: cameraBackgroundColor,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
);
  }

  @override
  void dispose() {
    lastPickedImage = null;
    firstTime = false;
    super.dispose();
  }
}
