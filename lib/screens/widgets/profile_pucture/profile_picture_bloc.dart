import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

import '../../../repos/repositories/profile_repository.dart';
import '../../../services/core_graphql_service.dart';
import '../../../services/graphql_service.dart';

part 'profile_picture_event.dart';
part 'profile_picture_state.dart';

class ProfilePictureBloc extends Bloc<ProfilePictureEvent, ProfilePictureState> {
  final GraphQLClient graphQLService = GraphQLService.instance.client;
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
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
      final result = await coreGraphQLService.mutate(await uploadProfileImage(event.file!));
      if (result.hasException) {
        print('error : ${result.exception!.graphqlErrors}');
        emit(ProfilePictureFailure('Error uploading image'));
      } else {
        print('result: ${result.data.toString()}');
        emit(ProfilePictureSuccess('https://media.psn24.ir/${result.data!['uploadProfileImage']}'));
      }
    } catch (e) {
      emit(ProfilePictureFailure(e.toString()));
    }
  }
}