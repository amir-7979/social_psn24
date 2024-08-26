import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_psn/screens/create_post/widgets/my_form.dart';

import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/themes.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/new_page_progress_indicator.dart';
import '../widgets/white_circular_progress_indicator.dart';
import 'create_post_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => CreatePostBloc(),
  child: Builder(
    builder: (context) {
      return Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.background,
              ),
              child:BlocConsumer<CreatePostBloc, CreatePostState>(
                listener: (context, state) {
                  if (state is PostCreationFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(content: state.message).build(context),
                    );
                  } else if (state is MediaUploadFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(content: state.message).build(context),
                    );
                  } else if (state is MediaDeleteFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(content: state.message).build(context),
                    );
                  }else if (state is MediaOrderChangeFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(content: state.message).build(context),
                    );
                  }else if (state is SubmittingCreateFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(content: state.message).build(context),
                    );
                  }else if (state is SubmittingCreateSucceed) {
                    Navigator.of(context).pop();
                  }
                },
                buildWhen: (previous, current) {
                  if (current is CreatingNewPost || current is PostCreationSucceed || current is PostCreationFailed) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  return state is PostCreationSucceed ? MyForm(newPost: state.post,) : state is CreatingNewPost ? NewPageProgressIndicator() : /*Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translateNested("error", "loadingPageError"),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )*/
                  MyForm();
                },
              ),

            ),
          ),
        );
    }
  ),
);
  }
}
