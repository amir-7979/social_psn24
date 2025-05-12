import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../repos/models/consultation_model/counseling_center.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/profile_cached_network_image.dart';

class CenterItem extends StatelessWidget {
  final CounselingCenter center;
  const CenterItem(this.center, {super.key});



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
                                FaIcon(FontAwesomeIcons.lightLocationDot,
                                    size: 12,
                                    color: Theme.of(context).hintColor),
                                SizedBox(width: 2),
                                Text(
                                  center.address ?? "",
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
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 30,
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
                                    .translateNested("consultation", "details"),
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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                  border:
                  Border.all(color: Theme.of(context).colorScheme.surface),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                   SvgPicture.asset(
                      'assets/images/profile/placeholder.svg', fit: BoxFit.cover,),
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
                                center.name ?? "",
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
