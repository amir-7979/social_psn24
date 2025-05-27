import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:social_psn/repos/models/consultation_model/consultation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';

import '../../main/widgets/screen_builder.dart';
import '../../widgets/dialogs/my_confirm_dialog.dart';
import '../../widgets/profile_cached_network_image.dart';
import '../my_consultation_bloc.dart';
import '../shimmer/consult_shimmer.dart';

class ConsultationItem extends StatelessWidget {
  final Consultation consultation;

  ConsultationItem(this.consultation);

  Future<void> openMap(double latitude, double longitude) async {
    if (kIsWeb) {
      final url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      await launchUrl(url);
      return;
    }

    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'action_view',
        data: 'geo:$latitude,$longitude?q=$latitude,$longitude',
      );
      await intent.launch(); // This shows a chooser of all compatible apps
    } else if (Platform.isIOS) {
      final appleMapsUrl = Uri.parse('maps://?q=$latitude,$longitude');
      if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl);
      } else {
        final googleMapsUrl = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      }
    } else {
      throw 'Unsupported platform';
    }
  }

  Color getStatusColor(BuildContext context) {
    switch (consultation.status) {
      case 'approved':
        return Theme.of(context).primaryColor;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Theme.of(context).primaryColor;
      default:
        return Colors.grey;
    }
  }

  int getType(Consultation consultation) {
    //use switch case instead of if else
    switch (consultation.consultationType?.name) {
      case "in_person":
        return 1;
      case "text":
        return 2;
      case "voice":
        return 3;
      case "video":
        return 4;
      default:
        return 1;
    }
  }

  @override
  build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.surface),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 12, end: 12, top: 8, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 55),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        FaIcon(
                                            FontAwesomeIcons.lightGraduationCap,
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
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsetsDirectional.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer),
                                      child: Row(
                                        children: [
                                          FaIcon(
                                              (consultation.consultationType
                                                          ?.name ==
                                                      "in_person")
                                                  ? FontAwesomeIcons
                                                      .lightUserTie
                                                  : (consultation
                                                              .consultationType
                                                              ?.name ==
                                                          "text")
                                                      ? FontAwesomeIcons
                                                          .lightComment
                                                      : FontAwesomeIcons
                                                          .lightComment,
                                              size: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground),
                                          SizedBox(width: 4),
                                          Text(
                                            "مشاوره ${consultation.consultationType?.description ?? ""} ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translateNested(
                                            "consultation", "time"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  Text(
                                    '${consultation.date?.jalaliDate!.replaceAll("-", "/") ?? ""} - ${consultation.date?.time?.time ?? ""}',
                                    textDirection: TextDirection.ltr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (consultation.counselingCenter?.address !=
                                          null &&
                                      consultation.counselingCenter!.address!
                                          .isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translateNested("consultation",
                                                    'center_address'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                          ),
                                          Text(
                                            consultation.counselingCenter
                                                    ?.address ??
                                                "",
                                            textDirection: TextDirection.ltr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  /*if (consultation.total != null)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translateNested("consultation",
                                                    'myConsultation_cost'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${consultation.total.toString() ?? ""}",
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                              SizedBox(width: 2),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translateNested(
                                                        "consultation",
                                                        'toman'),
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),*/
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (consultation.status != "cancelled")
                              SizedBox(width: 8),
                            if (consultation.status != "cancelled")
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsetsDirectional.symmetric(
                                      horizontal: 8, vertical: 0),
                                  minimumSize: const Size(80, 30),
                                  shadowColor: Colors.transparent,
                                  backgroundColor:
                                      Theme.of(context).dividerColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed:(){},
                                child: Text(
                                  AppLocalizations.of(context)!.translateNested(
                                      "consultation", "editConsultation"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).shadowColor,
                                      ),
                                ),
                              ),
                            if (consultation.status != "cancelled")
                              Expanded(child: SizedBox()),
                            if (consultation.status != "cancelled") ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 8, vertical: 0),
                                minimumSize: const Size(80, 30),
                                shadowColor: Colors.transparent,
                                //foregroundColor: Theme.of(context).colorScheme.tertiary,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () async{
                                BuildContext profileContext = context;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MyConfirmDialog(
                                      title: AppLocalizations.of(context)!.translateNested(
                                          'consultation', 'cancelConsultation'), description: AppLocalizations.of(context)!.translateNested(
                                        'consultation', 'deleteConsultationDescription'), cancelText: AppLocalizations.of(context)!.translateNested(
                                        'dialog', 'cancel'),confirmText: AppLocalizations.of(context)!.translateNested(
                                        'dialog', 'delete'),
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                      onConfirm: () {
                                        BlocProvider.of<MyConsultationBloc>(profileContext)
                                            .add(DeleteMyConsultationEvent(consultation.id!));
                                        Navigator.pop(context);
                                        BlocProvider.of<MyConsultationBloc>(profileContext)
                                            .add(FetchMyConsultationEvent());



                                      },
                                    );
                                  },
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.translateNested(
                                    "consultation", "cancelConsultation"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              ),
                            ),
                            if (consultation.status != "cancelled")SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 8, vertical: 0),
                                minimumSize: const Size(80, 30),
                                shadowColor: Colors.transparent,
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () async {
                                if(getType(consultation) == 2){
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.chat,
                                    arguments: {
                                      "chatUuid": consultation.chatInfo!.uuid,
                                      "wsDomain": consultation.chatInfo!.wsDomain,
                                      "wsChannel": consultation.chatInfo!.wsChannel,
                                      "chatTitle": consultation.consultant?.name??'',
                                      "userId": consultation.consultant?.id,
                                      "avatarUrl": consultation.consultant?.infoUrl,
                                    },
                                  );
                                }else if (consultation.counselingCenter!.latitude !=
                                        null &&
                                    consultation.counselingCenter!.longitude !=
                                        null) {
                                  await openMap(
                                    double.parse(consultation
                                        .counselingCenter!.latitude!),
                                    double.parse(consultation
                                        .counselingCenter!.longitude!),
                                  );
                                }
                              },
                              child: Text(
                                getType(consultation) == 1
                                    ? AppLocalizations.of(context)!
                                        .translateNested(
                                            "consultation", "address")
                                    : getType(consultation) == 2
                                        ? AppLocalizations.of(context)!
                                            .translateNested("consultation",
                                                "start_conversation")
                                        : AppLocalizations.of(context)!
                                            .translateNested(
                                                "consultation", "address"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: whiteColor,
                                    ),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ],
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
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.profile,
                          arguments: consultation.consultant!.id);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.background,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.background),
                      ),
                      child: ClipOval(
                        child: (consultation.consultant?.infoUrl != null)
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: ProfileCacheImage(
                                  consultation.consultant?.infoUrl,
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
                                    consultation.consultant?.name ?? "",
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
                                const SizedBox(width: 2),
                                if (consultation.counselingCenter?.name != null)
                                  Flexible(
                                    child: Text(
                                      '(${consultation.counselingCenter?.name})',
                                      textDirection: TextDirection.ltr,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  size: 8, color: getStatusColor(context)),
                              const SizedBox(width: 2),
                              Text(
                                consultation.statusPersian ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: getStatusColor(context),
                                    ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
