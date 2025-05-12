import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:social_psn/repos/models/consultation_model/consultation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/profile_cached_network_image.dart';
import '../shimmer/consult_shimmer.dart';

class ConsultationItem extends StatefulWidget {
  final Consultation consultation;

  ConsultationItem(this.consultation);

  @override
  State<ConsultationItem> createState() => _ConsultationItemState();
}

class _ConsultationItemState extends State<ConsultationItem>
    with TickerProviderStateMixin {
  bool _isInfoExpanded = false;

  late AnimationController _infoController;

  late Animation<double> _infoAnimation;

  @override
  void initState() {
    super.initState();

    _infoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _infoAnimation = CurvedAnimation(
      parent: _infoController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _infoController.dispose();
    super.dispose();
  }

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
    switch (widget.consultation.status) {
      case 'approved':
        return Theme.of(context).primaryColor;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'processing':
        return Theme.of(context).colorScheme.tertiary;
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
  Widget build(BuildContext context) {
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
                      border: Border.all(color: Theme.of(context).colorScheme.surface),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Padding(
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
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context).hintColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsetsDirectional.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer),
                                      child: Row(
                                        children: [
                                          FaIcon(
                                              (widget.consultation.consultationType
                                                          ?.name ==
                                                      "in_person")
                                                  ? FontAwesomeIcons.lightUserTie
                                                  : (widget
                                                              .consultation
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
                                            "مشاوره ${widget.consultation.consultationType?.description ?? ""} ",
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translateNested("consultation", "time"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  Text(
                                    '${widget.consultation.date?.jalaliDate ?? ""} - ${widget.consultation.date?.time?.time ?? ""}',
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
                              AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: _isInfoExpanded
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (widget.consultation.counselingCenter
                                                      ?.address !=
                                                  null &&
                                              widget.consultation.counselingCenter!
                                                  .address!.isNotEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional.only(
                                                      top: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)!
                                                        .translateNested(
                                                            "consultation",
                                                            'center_address'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Theme.of(context)
                                                              .hintColor,
                                                        ),
                                                  ),
                                                  Text(
                                                    widget
                                                            .consultation
                                                            .counselingCenter
                                                            ?.address ??
                                                        "",
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
                                            ),
                                          if (widget.consultation.total != null)
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional.only(
                                                      top: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)!
                                                        .translateNested(
                                                            "consultation",
                                                            'myConsultation_cost'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Theme.of(context)
                                                              .hintColor,
                                                        ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${widget.consultation.total.toString() ?? ""}",
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onBackground,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                      SizedBox(width: 2),
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .translateNested(
                                                                "consultation",
                                                                'toman'),
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onBackground,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Theme.of(context).primaryColor.withOpacity(0.2),
                                Theme.of(context).colorScheme.background.withOpacity(0.0),

                              ],
                            ),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: 40,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _isInfoExpanded = !_isInfoExpanded;
                                        if (_isInfoExpanded) {
                                          _infoController.forward();
                                        } else {
                                          _infoController.reverse();
                                        }
                                      });
                                    },
                                    iconAlignment: IconAlignment.end,
                                    icon: RotationTransition(
                                      turns: _infoAnimation,
                                      child: _isInfoExpanded
                                          ? Icon(Icons.expand_less,
                                          color: Theme.of(context).primaryColor)
                                          : Icon(Icons.expand_more,
                                          color: Theme.of(context).primaryColor),
                                    ),
                                    style: ButtonStyle(
                                      overlayColor:
                                      WidgetStateProperty.all(Colors.transparent),
                                    ),
                                    label: Text(
                                      AppLocalizations.of(context)!
                                          .translateNested("postScreen", "show_more"),
                                      style: iranYekanTheme.titleLarge!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).primaryColor),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
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
                                    if (widget.consultation.counselingCenter!.latitude != null &&
                                        widget.consultation.counselingCenter!.longitude != null) {
                                      await openMap(
                                        double.parse(widget.consultation.counselingCenter!.latitude!),
                                        double.parse(widget.consultation.counselingCenter!.longitude!),
                                      );
                                    }
                                  },
                                  child: Text(
<<<<<<< HEAD
                                    AppLocalizations.of(context)!
=======
                                    //use getType function to get the type of consultation
                                    getType(widget.consultation) == 1
                                        ? AppLocalizations.of(context)!
                                            .translateNested("consultation", "address")
                                        : getType(widget.consultation) == 2 ? AppLocalizations.of(context)!
                                            .translateNested("consultation", "start_conversation")
                                   :  AppLocalizations.of(context)!
>>>>>>> 0458aa0 (complete 2 screens for chose consultant and consulting center.)
                                        .translateNested("consultation", "address"),
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
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
                    onTap:(){
        Navigator.of(context).pushNamed(AppRoutes.profile,
        arguments: widget.consultation.consultant!.id);
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
                            (widget.consultation.consultant?.infoUrl !=
                                    null)
                                ? FittedBox(
                                    fit: BoxFit.cover,
                                    child: ProfileCacheImage(
                                      widget.consultation.consultant?.infoUrl,
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
                                    widget.consultation.consultant?.name ?? "",
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
<<<<<<< HEAD
                                Flexible(
=======
                                if(widget.consultation.counselingCenter?.name != null) Flexible(
>>>>>>> 0458aa0 (complete 2 screens for chose consultant and consulting center.)
                                  child: Text(
                                    '(${widget.consultation.counselingCenter?.name})',
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
                                widget.consultation.statusPersian ?? "",
                                style:
                                    Theme.of(context).textTheme.bodyLarge!.copyWith(
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
