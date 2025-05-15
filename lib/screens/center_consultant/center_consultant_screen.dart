import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/screens/center_consultant/widget/consultant_item.dart';
import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/themes.dart';
import '../../configs/utilities.dart';
import '../../repos/models/consultation_model/consultant.dart';


class CenterConsultantScreen extends StatelessWidget {
  final List<Consultant>? consultants;

  const CenterConsultantScreen({
    super.key,
    required this.consultants,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.translateNested("consultation", 'myConsultation'),
                style: iranYekanTheme.displayMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                padding: EdgeInsetsDirectional.zero,
                alignment: AlignmentDirectional.centerEnd,
                onPressed: (){
                  navigatorKey.currentState?.pop();
                },
                icon: FaIcon(
                    size: 20,
                    FontAwesomeIcons.lightArrowLeft,
                    color: Theme.of(context).colorScheme.surface),
              ),
            ],),
          SizedBox(height: 8),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor
                      .withOpacity(0),
                  Theme.of(context).primaryColor
                      .withOpacity(1),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: consultants!.length,
              itemBuilder: (context, index) {
                return ConsultantItem(consultants![index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
