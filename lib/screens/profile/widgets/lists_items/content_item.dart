import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/configs/setting/themes.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/setting_bloc.dart';
import '../../../../configs/utilities.dart';
import '../../../../repos/models/content.dart';
import '../../../main/widgets/screen_builder.dart';
import '../../../widgets/dialogs/my_confirm_dialog.dart';
import '../../../widgets/selectImge.dart';
import '../../profile_bloc.dart';

class ContentItem extends StatelessWidget {
  final Content content;

  ContentItem(this.content);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(content.disabled == false)
        Navigator.of(context).pushNamed(AppRoutes.postDetailed, arguments: <String, dynamic>{
          'postId': content.id,
        },);
      },
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0, // to make it square
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ColorFiltered(
                colorFilter: content.disabled??false ? ColorFilter.mode(Colors.grey, BlendMode.saturation) : ColorFilter.mode(Colors.transparent, BlendMode.saturation),
                child: selectImage(content.medias ?? []),
              )
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0xB2000000)],),
            ),
            child: Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(7, 3, 7, 3),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Directionality(
                        textDirection: detectDirection(content.name),
                        child: Expanded(
                          child: Text(
                            content.name ?? '',
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ),
                      ), // white text
                    ],
                  ),
                )),
          ),
           if(content.disabled == true) Center(child: Container(
               child: SvgPicture.asset('assets/images/profile/disabled.svg'))),
          if(((ModalRoute.of(context)?.settings.name == AppRoutes.myProfile && (BlocProvider.of<SettingBloc>(context).state.profile!.permissions!.contains("delete own post")||BlocProvider.of<SettingBloc>(context).state.profile!.permissions!.contains("edit own post"))) || BlocProvider.of<SettingBloc>(context).state.profile!.permissions!.contains("edit all post")||BlocProvider.of<SettingBloc>(context).state.profile!.permissions!.contains("delete all post")))
            Align(
            alignment: AlignmentDirectional.topEnd,
            child: Container(
              child: SizedBox(
                height: 30,
                width: 30,
                child: PopupMenuButton<int>(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Theme.of(context).colorScheme.background,
                  surfaceTintColor: Theme.of(context).colorScheme.background,
                  shadowColor: Colors.transparent,
                  useRootNavigator: true,
                  icon: BlocBuilder<ProfileBloc, ProfileState>(

                    builder: (context, state) {
                      return Container(
                          height: 25,
                          width: 25,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            // semi-transparent background
                            shape: BoxShape.circle,
                          ),
                          child: (state is PostDeleting && state.id == content.id)
                              ? CircularProgressIndicator(color: whiteColor, strokeWidth: 2)
                              : SvgPicture.asset(
                                  'assets/images/profile/three_dots.svg',
                                  width: 6,
                                  height: 14,
                                  color: whiteColor));
                    },
                  ),
                  // white icon
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.createMedia, arguments: content.id);
                      },
                      value: 1,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/images/profile/edit.svg',
                              height: 20,
                              width: 20,
                              color: Theme.of(context).colorScheme.shadow),
                          SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!
                                .translateNested("profileScreen", "edit"),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.shadow,
                                ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        BuildContext profileContext = context;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MyConfirmDialog(
                              title: AppLocalizations.of(context)!.translateNested(
                                  'dialog', 'deleteMediaTitle'), description: AppLocalizations.of(context)!.translateNested(
                                'dialog', 'deleteMediaDescription'), cancelText: AppLocalizations.of(context)!.translateNested(
                                'dialog', 'cancel'),confirmText: AppLocalizations.of(context)!.translateNested(
                                'dialog', 'delete'),
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onConfirm: () {
                                BlocProvider.of<ProfileBloc>(profileContext)
                                    .add(DeletePostEvent(content.id ?? ''));
                                Navigator.pop(context);

                              },
                            );
                          },
                        );

                      },
                      value: 2,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/images/profile/trash-can.svg',
                              height: 20,
                              width: 20,
                              color: Theme.of(context).colorScheme.shadow),
                          SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!
                                .translateNested("profileScreen", "delete"),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.shadow,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
