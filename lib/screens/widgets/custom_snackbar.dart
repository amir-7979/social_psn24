import 'package:flutter/material.dart';
import 'package:social_psn/configs/setting/themes.dart';

import '../../configs/localization/app_localizations.dart';

class CustomSnackBar {
  final String content;
  final Color? backgroundColor;
  final Function? function;

  CustomSnackBar({required this.content, this.backgroundColor, this.function});

  SnackBar build(BuildContext context) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      content: Text(
        content,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w400, color: whiteColor),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),

      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.error, // Use error color if backgroundColor is null
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.translateNested('auth', 'close'),
        textColor: whiteColor,
        onPressed: () {
          if (function != null) {
            function!();
          }else{
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
      ),
    );
  }
}