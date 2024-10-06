
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'package:social_psn/repos/models/admin_setting.dart';
import 'package:social_psn/repos/models/post.dart';
import 'package:social_psn/repos/repositories/graphql/create_post_repository.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/tag.dart';
import '../../widgets/white_circular_progress_indicator.dart';
import '../create_post_bloc.dart';


import 'post_content.dart';
import 'post_form.dart'; // Add this import

class MainForm extends StatefulWidget {
  final Post? newPost;

  MainForm({this.newPost, Key? key}) : super(key: key);

  @override
  State<MainForm> createState() => _MainFormState();
}

class _MainFormState extends State<MainForm> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController longTextController = TextEditingController();
  AdminSettings? adminSettings;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.newPost != null) {
        titleController.text = widget.newPost!.name ?? '';
        Tag? tag = BlocProvider.of<SettingBloc>(context).state.tagsList?.firstWhere(
              (element) => element.id == widget.newPost?.tagId,
          orElse: () => Tag(id: null, title: ''), // Default value instead of null
        );
        categoryController.text = tag?.title ?? '';
        longTextController.text = widget.newPost!.description ?? '';
      }
    });
    adminSettings = BlocProvider.of<CreatePostBloc>(context).adminSettings;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          AppLocalizations.of(context)!
              .translateNested("createMedia", 'createMedia'),
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        SizedBox(height: 8),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0),
                Theme.of(context).primaryColor.withOpacity(1),
              ],
              stops: const [0.0, 1.0],
            ),
          ),
        ),
        SizedBox(height: 16),
        PostForm(
          titleController,
          categoryController,
          longTextController,
        ),
        const SizedBox(height: 16),
        if(adminSettings != null)
          PostContent(postId: widget.newPost!.id,postMedias: widget.newPost?.medias??[], adminSettings: adminSettings!),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  backgroundColor: Color(0x3300A6ED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translateNested('profileScreen', 'return'),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
              ),
            )),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<CreatePostBloc>(context).add(
                      SubmitNewPostEvent(
                          title: titleController.text,
                          category: context.read<SettingBloc>().state.tags!.firstWhere(
                            (element) => element.title == categoryController.text,
                            orElse: () => context.read<SettingBloc>().state.tagsList.first,
                          ).id??'',
                          longText: longTextController.text),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: BlocBuilder<CreatePostBloc, CreatePostState>(
                    builder: (context, state) {
                      return state is SubmittingPostLoading
                          ? WhiteCircularProgressIndicator()
                          : Text(
                              AppLocalizations.of(context)!
                                  .translateNested('profileScreen', 'save'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: whiteColor,
                                  ),
                            );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
