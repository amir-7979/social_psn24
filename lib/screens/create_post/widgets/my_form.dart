import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:searchfield/searchfield.dart';
import 'package:social_psn/repos/models/post.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../configs/utilities.dart';
import '../../../repos/models/media.dart';
import '../../widgets/white_circular_progress_indicator.dart';
import '../create_post_bloc.dart';
import 'media_item.dart';

import 'package:reorderables/reorderables.dart';

import 'post_content.dart';
import 'post_form.dart'; // Add this import

class MyForm extends StatefulWidget {
  final Post? newPost;

  MyForm({this.newPost, Key? key}) : super(key: key);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final ScrollController _scrollController = ScrollController();

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
        PostForm(),
        const SizedBox(height: 16),
        PostContent(
          postMedias: widget.newPost?.medias ?? <Media>[],
          onSwitchToggle: () {
          },
          scrollController: _scrollController,
        ),
        const SizedBox(height: 16),
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
                    //todo upload media
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
