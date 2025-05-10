import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import '../../../repos/repositories/dio/profile_repository.dart';

part 'profile_picture_event.dart';
part 'profile_picture_state.dart';

class ProfilePictureBloc extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  final ProfileRepository _profileRepository = ProfileRepository();
  ProfilePictureBloc() : super(ProfilePictureInitial()) {
    on<UploadProfilePicture>(_handlePhotoUploadEvent);
    on<RemoveProfilePhotoEvent>(_onRemoveProfilePhotoEvent);

  }

  Future<void> _handlePhotoUploadEvent(UploadProfilePicture event, Emitter<ProfilePictureState> emit) async {
    emit(ProfilePictureLoading());
    try {
      if (event.file == null) {
        print('file is null');
        emit(ProfilePictureFailure(null));
        return;
      }
      final result = await _profileRepository.uploadProfilePhoto(event.file!.path);
        emit(ProfilePictureSuccess(result.data!['data']['photo'].toString()));
    } catch (e) {
      print('error: $e.toString()');
      emit(ProfilePictureFailure(e.toString()));
    }
  }


  Future<void> _onRemoveProfilePhotoEvent(RemoveProfilePhotoEvent event, Emitter<ProfilePictureState> emit) async {
    emit(ProfilePictureLoading());
    try {
      Response result = await _profileRepository.removeProfilePhoto();
      if (result.data == null) {
        print('error: ${result.data.toString()}');
        emit(ProfilePictureFailure('خطا در حذف عکس پروفایل'));
        return;
      }
      emit(ProfilePictureRemove());
    } catch (exception) {
      if(exception is DioException && exception.response != null) {
        print('error: ${exception.response!.data['data'][0].toString()}');
        emit(ProfilePictureFailure(exception.response!.data['data'][0].toString()));
        return;
      }
      print('error: $exception');
      emit(ProfilePictureFailure('خطا در حذف عکس پروفایل'));
    }
  }

}


