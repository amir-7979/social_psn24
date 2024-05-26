import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../repos/repositories/profile_repository.dart';
import '../../services/graphql_service.dart';

part 'cropper_event.dart';
part 'cropper_state.dart';

class CropperBloc extends Bloc<CropperEvent, CropperState> {
  final GraphQLClient graphQLService = GraphQLService.instance.client;

  CropperBloc() : super(CropperInitial()) {
    on<PhotoUploadEvent>((event, emit) async {
      emit(PhotoUploading());
      /*try {
        final MutationOptions options = await uploadProfileImage(event.file);
        final QueryResult result = await graphQLService.mutate(options);
        print(result.data.toString());
        emit(PhotoUploadCompleted(result.data.toString()));
      } catch (e) {
        print(e.toString());
        emit(PhotoUploadFailed(e.toString()));
      }*/
    });
  }
}