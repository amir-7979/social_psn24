import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/themes.dart';

class CharityScreen extends StatelessWidget {
  const CharityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              child: SvgPicture.asset(
                'assets/images/bottom_navbar/coming_soon.svg',
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.translate('comingSoon'),
              style:Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
