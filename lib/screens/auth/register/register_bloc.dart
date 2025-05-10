import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:meta/meta.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/repositories/dio/profile_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final ProfileRepository _profileRepository = ProfileRepository();
  final SettingBloc settingBloc;
  String? photoUrl;

  RegisterBloc(this.settingBloc) : super(RegisterInitial()) {
    on<EditUserEvent>(_handleRegisterEvent);
    on<PhotoUploadEvent>(_handlePhotoUploadEvent);
  }

  Future<void> _handleRegisterEvent(EditUserEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      Response response = await _profileRepository.editProfile(firstName: event.name, lastName: event.family, username: event.username, photo: photoUrl);
      if (response.data == null) {
        emit(RegisterFinished('خطا در ثبت نام'));
      }
      settingBloc.add(FetchUserProfileWithPermissionsEvent());
      photoUrl = null;
      emit(RegisterFinished('ورود با موفقیت انجام شد'));
    } catch (exception) {
      if (exception is DioException) {
        emit(RegisterFailure(exception.response?.data['data'][0].toString() ?? 'خطا در ثبت نام'));
      } else {
        emit(RegisterFailure('خطا در ثبت نام'));
      }
    }
  }

  Future<void> _handlePhotoUploadEvent(PhotoUploadEvent event, Emitter<RegisterState> emit) async {
    photoUrl = event.file??null;
  }
}
