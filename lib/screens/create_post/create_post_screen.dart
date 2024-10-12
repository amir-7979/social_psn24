import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/create_post/widgets/main_form.dart';

import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/post.dart';
import '../main/widgets/screen_builder.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/new_page_progress_indicator.dart';
import 'create_post_bloc.dart';

class CreatePostScreen extends StatefulWidget {
  CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? postId;
  didChangeDependencies() {
    super.didChangeDependencies();
    postId = ModalRoute.of(context)!.settings.arguments as String?;
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //get arguments from route
      create: (context) => CreatePostBloc(postId: postId),
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsetsDirectional.all(14),
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
              child: BlocConsumer<CreatePostBloc, CreatePostState>(
                listener: (context, state) {
                  if (state is PostCreationFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(content: state.message).build(context),
                    );
                  } else if (state is MediaOrderChangeFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(content: state.message).build(context),
                    );
                  } else if (state is SubmittingFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(content: state.message).build(context),
                    );
                  } else if (state is SubmittingCreateSucceed) {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                  }
                },
                buildWhen: (previous, current) {
                  if (current is CreatingNewPost ||
                      current is PostCreationSucceed ||
                      current is PostCreationFailed) {
                    return true;
                  }
                  return false;
                },
                builder: (context, state) {
                  return state is PostCreationSucceed
                      ? MainForm(newPost: state.post)
                      : state is CreatingNewPost
                          ? NewPageProgressIndicator()
                          : MainForm();

                  /*Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translateNested("error", "loadingPageError"),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );*/
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
