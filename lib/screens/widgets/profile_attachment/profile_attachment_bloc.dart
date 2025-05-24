import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import '../../../repos/repositories/dio/profile_repository.dart';

part 'profile_attachment_event.dart';
part 'profile_attachment_state.dart';

class ProfileAttachmentBloc extends Bloc<ProfileAttachmentEvent, ProfileAttachmentState> {
  final ProfileRepository _profileRepository = ProfileRepository();
  ProfileAttachmentBloc() : super(ProfileAttachmentInitial()) {
    on<UploadProfileAttachment>(_handlePhotoUploadEvent);
    on<RemoveProfileAttachmentEvent>(_onRemoveProfilePhotoEvent);

  }

  Future<void> _handlePhotoUploadEvent(UploadProfileAttachment event, Emitter<ProfileAttachmentState> emit) async {
    emit(ProfileAttachmentLoading());
    try {
      if (event.file == null) {
        print('file is null');
        emit(ProfileAttachmentFailure(null));
        return;
      }
      FormData formData = FormData.fromMap({
        event.name:
        await MultipartFile.fromFile(event.file!.path, filename: event.fileName),
      });
      final result = await _profileRepository.uploadProfileAttachment(formData);
      print(result.data['data'].toString());
        emit(ProfileAttachmentSuccess(result.data!['data']['photo'].toString()));
    } catch (e) {
      print('error: $e.toString()');
      emit(ProfileAttachmentFailure(e.toString()));
    }
  }


  Future<void> _onRemoveProfilePhotoEvent(RemoveProfileAttachmentEvent event, Emitter<ProfileAttachmentState> emit) async {
    emit(ProfileAttachmentLoading());
    try {
      Response result = await _profileRepository.removeProfilePhoto();
      if (result.data == null) {
        print('error: ${result.data.toString()}');
        emit(ProfileAttachmentFailure('خطا در حذف عکس پروفایل'));
        return;
      }
      emit(ProfileAttachmentRemove());
    } catch (exception) {
      if(exception is DioException && exception.response != null) {
        print('error: ${exception.response!.data['data'][0].toString()}');
        emit(ProfileAttachmentFailure(exception.response!.data['data'][0].toString()));
        return;
      }
      print('error: $exception');
      emit(ProfileAttachmentFailure('خطا در حذف عکس پروفایل'));
    }
  }

}


