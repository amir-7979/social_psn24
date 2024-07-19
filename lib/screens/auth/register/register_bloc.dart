import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/repositories/auth_repository.dart';
import '../../../services/core_graphql_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
  final SettingBloc settingBloc;
  String? photoUrl;

  RegisterBloc(this.settingBloc) : super(RegisterInitial()) {
    on<EditUserEvent>(_handleRegisterEvent);
    on<PhotoUploadEvent>(_handlePhotoUploadEvent);
  }

  Future<void> _handleRegisterEvent(EditUserEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final QueryResult result = await coreGraphQLService.mutate(
          getEditUserOptions(event.name, event.family, event.username, photoUrl, event.showActivity));
      if (result.hasException) {
        if (result.exception!.graphqlErrors.isNotEmpty &&
            result.exception!.graphqlErrors.first.extensions!['validation']
            ['name'] !=
                null) {
          emit(RegisterFailure(result.exception!.graphqlErrors[0]
              .extensions!['validation']['name'][0]));
        } else {
          print(result.exception.toString());
          emit(RegisterFailure('خطا'));
        }
      } else {
        settingBloc.add(FetchUserProfileWithPermissionsEvent());
        photoUrl = null;
        emit(RegisterFinished('ورود با موفقیت انجام شد'));
      }
    } catch (exception) {
      emit(RegisterFailure('خطا'));
    }
  }

  Future<void> _handlePhotoUploadEvent(PhotoUploadEvent event, Emitter<RegisterState> emit) async {
    photoUrl = event.file??null;
  }
}
