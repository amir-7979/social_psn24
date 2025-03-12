import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../repos/repositories/dio/dio_profile_repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileRepository profileRepository = ProfileRepository();

  EditProfileBloc() : super(EditProfileInitial()) {
    on<SubmitEditProfileEvent>(_onSubmitEditProfileEvent);
  }

  Future<void> _onSubmitEditProfileEvent(SubmitEditProfileEvent event,
      Emitter<EditProfileState> emit) async {
    emit(EditProfileLoading());
    try {
      Response result = await profileRepository.editProfile(
          firstName: event.name,
          lastName: event.family,
          username: event.username);
      if (result.data == null) {
        emit(EditProfileError('خطا در ثبت تغیرات'));
        return;
      }
      emit(EditProfileSuccess());
    } catch (exception) {
      if (exception is DioException && exception.response != null) {
        emit(EditProfileError(exception.response!.data['data'][0].toString()));
        return;
      }
      emit(EditProfileError('خطا در ثبت تغیرات'));
    }
  }
}
