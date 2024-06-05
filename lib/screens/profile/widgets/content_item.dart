import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/configs/setting/themes.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../repos/models/content.dart';
import '../../../repos/models/media.dart';
import '../../main/main_bloc.dart';
import '../../widgets/cached_network_image.dart';
import '../../widgets/selectImge.dart';
import '../profile_bloc.dart';

class ContentItem extends StatelessWidget {
  final Content content;

  ContentItem(this.content);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // todo go to media screen
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
                  padding: const EdgeInsetsDirectional.fromSTEB(7, 3, 0, 3),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
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
                      ), // white text
                    ],
                  ),
                )),
          ),
           if(content.disabled == true) Center(child: Container(
               child: SvgPicture.asset('assets/images/profile/disabled.svg'))),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: PopupMenuButton<int>(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Theme.of(context).colorScheme.background,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              shadowColor: Colors.transparent,
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
                  onTap: () {},
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
                    BlocProvider.of<ProfileBloc>(context)
                        .add(DeletePost(content.id ?? ''));
                    BlocProvider.of<MainBloc>(context).add(MainUpdate(0));


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
              onSelected: (value) {
                if (value == 1) {
                  // Handle edit action
                } else if (value == 2) {
                  // Handle delete action
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
