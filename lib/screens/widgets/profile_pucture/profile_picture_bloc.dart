import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../repos/repositories/dio/dio_profile_repository.dart';

part 'profile_picture_event.dart';
part 'profile_picture_state.dart';

class ProfilePictureBloc extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  final ProfileRepository _profileRepository = ProfileRepository();
  ProfilePictureBloc() : super(ProfilePictureInitial()) {
    on<UploadProfilePicture>(_handlePhotoUploadEvent);
  }

  Future<void> _handlePhotoUploadEvent(UploadProfilePicture event, Emitter<ProfilePictureState> emit) async {
    emit(ProfilePictureLoading());
    try {
      if (event.file == null) {
        emit(ProfilePictureFailure(null));
        return;
      }
      final result = await _profileRepository.uploadProfilePhoto(event.file!.path);
        print('result: ${result.data.toString()}');
        emit(ProfilePictureSuccess('https://media.psn24.ir/${result.data!['uploadProfileImage']}'));
    } catch (e) {
      emit(ProfilePictureFailure(e.toString()));
    }
  }
}

Future<http.MultipartFile> multipartFileFrom(File file) async {
  List<int> fileBytes = await file.readAsBytes();
  String filename = file.path.split('/').last;
  String? mimeType = lookupMimeType(file.path);
  final multipartFile = http.MultipartFile.fromBytes(
    'profilePicture', // field name
    fileBytes, // file bytes
    filename: filename, // file name
    );
  return multipartFile;
}