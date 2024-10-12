import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart';
import 'package:social_psn/repos/models/create_media.dart';
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
  PostContent();

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  late CreatePostBloc createPostBloc;
  late AdminSettings adminSettings;
  ValueNotifier<bool> advanceSwitchController = ValueNotifier<bool>(false);
  final picker = ImagePicker();
  List<String> permissions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    createPostBloc = BlocProvider.of<CreatePostBloc>(context);
    adminSettings = createPostBloc.adminSettings!;
    permissions =
        BlocProvider.of<SettingBloc>(context).state.profile!.permissions ?? [];
  }

  void _addMediaItem(CreateMedia createMedia) {
    MediaItemBloc mediaItemBloc = MediaItemBloc(createPostBloc: createPostBloc);
    createPostBloc.mediaItems.add(MediaItem(
        mediaItemBloc: mediaItemBloc,
        createMedia: createMedia,
        index: createPostBloc.mediaItems.length + 1));
    mediaItemBloc.add(UploadMediaItemEvent(mediaFile: createMedia.file));
    createPostBloc.add(RebuildMediaListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        SizedBox(height: 16),
        (advanceSwitchController.value == false &&
                    permissions.contains("create general post with media")) ||
                (advanceSwitchController.value == true &&
                    permissions.contains("create expert post with media"))
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 4),
                    child: Text(
                      advanceSwitchController.value == true
                          ? adminSettings.getPrivateAllowedFormats()
                          : adminSettings.getPublicAllowedFormats(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.end,
                      maxLines: 5,
                    ),
                  ),
                  _buildUploadButton(),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 8),
                    child: Text(
                      _buildMediaInfoText(context,
                          advanceSwitchController.value, adminSettings),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.end,
                      maxLines: 5,
                    ),
                  ),
                ],
              )
            : SizedBox(),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.translateNested("createMedia", "type"),
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
            setState(() {

            });
          },
        ),
      ],
    );
  }

  Widget _buildUploadButton() {
    return InkWell(
      onTap: () async {
        CreateMedia? createMedia =
            await pickMedia(context, !advanceSwitchController.value);
        if (createMedia != null) {
          _addMediaItem(createMedia);
        }
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
          child: BlocBuilder<CreatePostBloc, CreatePostState>(
            buildWhen: (previous, current) => current is RebuildMediaListState,
            builder: (context, state) {
              return _buildContent(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return createPostBloc.newPost!.medias!.isEmpty
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
        : _buildMediaList();
  }

  Widget _buildMediaList() {
    return ReorderableWrap(
        needsLongPressDraggable: false,
        spacing: 8,
        runSpacing: 8,
        onReorder: (oldIndex, newIndex) {
          var item = createPostBloc.mediaItems.removeAt(oldIndex);
          createPostBloc.mediaItems.insert(newIndex, item);
          setState(() {
            var item = createPostBloc.mediaItems.removeAt(oldIndex);
            createPostBloc.mediaItems.insert(newIndex, item);
          });
        },
        children: createPostBloc.mediaItems.map((mediaItem) {
          return MediaItem(
              mediaItemBloc: mediaItem.mediaItemBloc,
              createMedia: mediaItem.createMedia,
              index: createPostBloc.mediaItems.indexOf(mediaItem) + 1);
        }).toList());
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

    final imageSelected = 0;
    final videoSelected = 0;
    final voiceSelected = 0;

    return 'image: $imageCount / $imageSelected (${imageLimit}MB), '
        'video: $videoCount / $videoSelected (${videoLimit}MB), '
        'voice: $voiceCount / $voiceSelected (${voiceLimit}MB)';
  }
}
