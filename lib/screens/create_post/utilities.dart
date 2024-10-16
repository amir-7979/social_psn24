import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:social_psn/repos/models/create_media.dart';
import 'package:social_psn/screens/create_post/create_post_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/admin_setting.dart';
import '../widgets/custom_snackbar.dart';

Future<File?> cropImage(String imagePath, BuildContext context) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imagePath,
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
  return croppedFile != null ? File(croppedFile.path) : null;
}

Future<CreateMedia?> pickMedia(BuildContext context, bool mySwitch) async {
  final settings = BlocProvider.of<CreatePostBloc>(context).adminSettings;
  if (settings == null) return null;
  final photoList = mySwitch ? settings.allowedFormatsForPic : settings.allowedFormatsForPrivatePic;
  final videoList = mySwitch ? settings.allowedFormatsForVideo : settings.allowedFormatsForPrivateVideo;
  final audioList = mySwitch ? settings.allowedFormatsForVoice : settings.allowedFormatsForPrivateVoice;
  final pickedFiles = await FilePicker.platform.pickFiles(allowMultiple: false);
  if (pickedFiles == null) return null;
  for (var pickedFile in pickedFiles.files) {
    final file = File(pickedFile.path!);
    final fileName = pickedFile.name;
    final pickedFileType = pickedFile.extension?.toLowerCase();
    final fileSize = file.lengthSync();
    String? fileType;
    Uint8List? thumbnail;
    Map<String, dynamic> validationResult;

    if (photoList!.contains(pickedFileType)) {
      validationResult = await _validatePhoto(file, pickedFileType, fileSize, settings, mySwitch);
      fileType = 'image';
    } else if (videoList!.contains(pickedFileType)) {
      validationResult = await _validateVideo(file, pickedFileType, fileSize, settings, mySwitch);
      fileType = 'video';
      thumbnail = await generateThumbnail(file.path);
    } else if (audioList!.contains(pickedFileType)) {
      validationResult = await _validateAudio(file, pickedFileType, fileSize, settings, mySwitch);
      fileType = 'audio';
    } else {
      validationResult = {'isValid': false, 'message': 'فرمت فایل انتخاب شده مجاز نیست'};
    }

    if (validationResult['isValid']) {
    return CreateMedia.file(file: file, type: fileType??'', size: fileSize.toString(), thumbnail: thumbnail, name: fileName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(content: validationResult['message']).build(context));
    }
  }
  return null;
}

Future<Map<String, dynamic>> _validatePhoto(File file, String? fileType, int fileSize, AdminSettings settings, bool mySwitch) async {
  final maxSize = mySwitch ? settings.maxSizeForPicMB : settings.maxSizeForPicPrivateMB;

  if (fileSize > (maxSize! * 1024 * 1024)) {
    return {'isValid': false, 'message': 'Image is too large. Maximum size is $maxSize MB.'};
  }
  return {'isValid': true, 'message': ''};
}

Future<Map<String, dynamic>> _validateVideo(File file, String? fileType, int fileSize, AdminSettings settings, bool mySwitch) async {
  final maxSize = mySwitch ? settings.maxSizeForVideoMB : settings.maxSizeForVideoPrivateMB;
  final maxTime = mySwitch ? settings.maxTimeForVideoSec : settings.maxTimeForVideoPrivateSec;

  if (fileSize > (maxSize! * 1024 * 1024)) {
    return {'isValid': false, 'message': 'Video is too large. Maximum size is $maxSize MB.'};
  }

  final duration = await _getVideoDuration(file.path);
  if (duration.inSeconds > maxTime!) {
    return {'isValid': false, 'message': 'Video duration is too long. Maximum duration is $maxTime seconds.'};
  }

  return {'isValid': true, 'message': ''};
}

Future<Map<String, dynamic>> _validateAudio(File file, String? fileType, int fileSize, AdminSettings settings, bool mySwitch) async {
  final maxSize = mySwitch ? settings.maxSizeForVoiceMB : settings.maxSizeForVoicePrivateMB;
  final maxTime = mySwitch ? settings.maxTimeForVoiceSec : settings.maxTimeForVoicePrivateSec;

  if (fileSize > (maxSize! * 1024 * 1024)) {
    return {'isValid': false, 'message': 'Audio is too large. Maximum size is $maxSize MB.'};
  }

  final duration = await _getAudioDuration(file.path);
  if (duration.inSeconds > maxTime!) {
    return {'isValid': false, 'message': 'Audio duration is too long. Maximum duration is $maxTime seconds.'};
  }

  return {'isValid': true, 'message': ''};
}

Future<Duration> _getVideoDuration(String videoPath) async {
  final controller = VideoPlayerController.file(File(videoPath));
  await controller.initialize();
  final duration = controller.value.duration;
  await controller.dispose();
  return duration;
}

Future<Duration> _getAudioDuration(String audioPath) async {
  final player = AudioPlayer();
  final duration = await player.setFilePath(audioPath);
  await player.dispose();
  return duration ?? Duration.zero;
}

Future<Uint8List?> generateThumbnail(String videoPath) async {
  final uint8List = await VideoThumbnail.thumbnailData(
    video: videoPath,
    imageFormat: ImageFormat.JPEG,
    maxHeight: 550,
    maxWidth: 550,
    quality: 100,
  );

  return uint8List;
}

