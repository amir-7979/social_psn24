import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/repos/models/consultation_model/consultation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/consultation_model/consultant.dart';
import '../../../repos/models/consultation_model/user.dart';

import '../../main/widgets/screen_builder.dart';
import '../../widgets/profile_cached_network_image.dart';

class ConsultantItem extends StatelessWidget{
  final Consultant consultant;

  ConsultantItem(this.consultant);

  @override
  build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 24),
              child: Container(

                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.surface),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 12, end: 12, top: 12, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.only(start: 55),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                FaIcon(FontAwesomeIcons.lightGraduationCap,
                                    size: 12,
                                    color: Theme.of(context).hintColor),
                                SizedBox(width: 2),
                                Text(
                                  AppLocalizations.of(context)!
                                      .translateNested(
                                      "consultation", 'consultant'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  consultant.score == 0 ? "0" : consultant.score.toString() ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: amberColor,
                                  ),
                                  ),
                                SizedBox(width: 2),

                                FaIcon(FontAwesomeIcons.solidStar,
                                    size: 12,
                                    color: Colors.amber),


                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: consultant.hasChat ?  Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.surface.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.solidComment,
                                    size: 12,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Container(
                                width: 22,
                                height: 22,
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: consultant.hasInPerson ?  Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.surface.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.solidUserTie,
                                    size: 12,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),

                              Container(
                                width: 22,
                                height: 22,
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: consultant.hasVideo ?  Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.surface.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.solidVideo,
                                    size: 11,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),

                              Container(
                                width: 22,
                                height: 22,
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.zero,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: consultant.hasAudio ?  Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.surface.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.solidPhone,
                                    size: 12,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 27,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 0),
                                minimumSize: const Size(60, 27),
                                shadowColor: Colors.transparent,
                                backgroundColor: Color(0x3300A6ED),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () async {


                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translateNested("consultation", "start_consultation"),
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap:(){
                  Navigator.of(context).pushNamed(AppRoutes.profile,
                      arguments: consultant.id);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.background,
                    border:
                    Border.all(color: Theme.of(context).colorScheme.surface),
                  ),
                  child: ClipOval(
                    child:
                    (consultant.infoUrl !=
                        null)
                        ? FittedBox(
                      fit: BoxFit.cover,
                      child: ProfileCacheImage(
                        consultant.infoUrl,
                      ),
                    )
                        : SvgPicture.asset(
                        'assets/images/profile/profile2.svg'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                consultant.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    //fontSize: 14,
                                    fontWeight: FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
