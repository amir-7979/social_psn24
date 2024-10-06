import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/admin_setting.dart';
import '../../../repos/models/media.dart';
import '../create_post_bloc.dart';
import '../utilities.dart';
import 'media_item/media_item.dart';
import 'media_item/media_item_bloc.dart';

class PostContent extends StatefulWidget {
  String postId;
  List<Media> postMedias;
  AdminSettings adminSettings;

  PostContent({required this.postId, required this.postMedias, required this.adminSettings});

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  late CreatePostBloc createPostBloc;
  ValueNotifier<bool> advanceSwitchController = ValueNotifier<bool>(false);
  final picker = ImagePicker();
  File? cropPath;
  List<MediaItem> mediaItems = [];
  List<String> permissions = [];

  didChangeDependencies() {
    super.didChangeDependencies();
    permissions =
        BlocProvider.of<SettingBloc>(context).state.profile!.permissions ?? [];
    createPostBloc = BlocProvider.of<CreatePostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ((advanceSwitchController.value == false &&
                permissions.contains("create general post with media")) ||
            (advanceSwitchController.value == true &&
                permissions.contains("create expert post with media")))
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translateNested("createMedia", "type"),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).hoverColor,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  AdvancedSwitch(
                    controller: advanceSwitchController,
                    thumb: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 0, 2),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Theme.of(context).hintColor,
                    height: 25,
                    width: 90,
                    borderRadius: BorderRadius.circular(20),
                    enabled: true,
                    activeChild: Text(
                      AppLocalizations.of(context)!
                          .translateNested("createMedia", "general"),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: whiteColor,
                          ),
                    ),
                    inactiveChild: Text(
                      AppLocalizations.of(context)!
                          .translateNested("createMedia", "expert"),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: whiteColor,
                          ),
                    ),
                    onChanged: (val) {
                     createPostBloc.add(ResetCategoryEvent());
                      setState(() {});
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 4),
                child: Text(
                  advanceSwitchController.value == true
                      ? widget.adminSettings.getPrivateAllowedFormats()
                      : widget.adminSettings.getPublicAllowedFormats(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.end,
                  maxLines: 5,
                ),
              ),
              InkWell(
                onTap: () async {
                  File? file = await pickMedia(context, !advanceSwitchController.value);
                  MediaItemBloc mediaItemBloc = MediaItemBloc(createPostBloc: createPostBloc);
                  mediaItemBloc.add(UploadMediaItemEvent(file!));
                  mediaItems.add(MediaItem(mediaItemBloc: mediaItemBloc,
                    postMedia: Media(id: 'placeholder'),
                    index: mediaItems.length + 1,
                    file: file,
                  ));
                  setState(() {
                  });
                },
                child: SizedBox(
                  width: double.infinity,
                  child: DottedBorder(
                    color: Theme.of(context).colorScheme.surface,
                    strokeWidth: 1,
                    dashPattern: [8, 4],
                    padding: EdgeInsets.all(8),
                    borderType: BorderType.RRect,
                    radius: Radius.circular(16),
                    child: _buildContent(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8),
                child: Text(
                  _buildMediaInfoText(context, advanceSwitchController.value,
                      widget.adminSettings),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).hintColor,
                        fontWeight: FontWeight.w400,
                      ),
                  textAlign: TextAlign.end,
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 16),
            ],
          )
        : Container();
  }

  Widget _buildContent(BuildContext context) {
    return widget.postMedias.isEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/post/upload.png',
                  height: 100, width: 100),
              SizedBox(height: 20),
              Center(
                child: Text(
                  AppLocalizations.of(context)!
                      .translateNested("createMedia", "upload"),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
            ],
          )
        : _buildReorderableWrap(context);
  }

  Widget _buildReorderableWrap(BuildContext context) {
    return ReorderableWrap(
      needsLongPressDraggable: false,
      spacing: 8,
      runSpacing: 8,
      onReorder: (int oldIndex, int newIndex) {
        final item = widget.postMedias.removeAt(oldIndex);
        widget.postMedias.insert(newIndex, item);
        setState(() {});
        createPostBloc.add(ChangeMediaOrderEvent(
            widget.postMedias.map((e) => e.id!).toList(), widget.postId));
      },
      children: List.generate(widget.postMedias.length, (index) => MediaItem(createPostBloc: createPostBloc,postMedia: widget.postMedias[index], index: index + 1)),
    );
  }

  String _buildMediaInfoText(
      BuildContext context, bool isPrivate, AdminSettings adminSettings) {
    final imageLimit = isPrivate
        ? adminSettings.maxSizeForPicPrivateMB
        : adminSettings.maxSizeForPicMB;
    final videoLimit = isPrivate
        ? adminSettings.maxSizeForVideoPrivateMB
        : adminSettings.maxSizeForVideoMB;
    final voiceLimit = isPrivate
        ? adminSettings.maxSizeForVoicePrivateMB
        : adminSettings.maxSizeForVoiceMB;

    final imageCount = 5;
    final videoCount = 5;
    final voiceCount = 5;

    final imageSelected = 1;
    final videoSelected = 0;
    final voiceSelected = 0;

    return 'image: $imageCount / $imageSelected (${imageLimit}MB), '
        'video: $videoCount / $videoSelected (${videoLimit}MB), '
        'voice: $voiceCount / $voiceSelected (${voiceLimit}MB)';
  }
}
