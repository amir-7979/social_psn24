import 'package:flutter/material.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../configs/utilities.dart';

class MyAlertDialog extends StatelessWidget {
  final String? title, description, confirmText, cancelText, returnText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onReturn;



  const MyAlertDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.cancelText,
    required this.returnText,
    required this.onConfirm,
    required this.onCancel,
    required this.onReturn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: 200,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 10),
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    child: Text(
                      title??'',
                      textDirection: detectDirection(title),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Directionality(
              textDirection: isAppLanguageFarsi(context)
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0),
                      Theme.of(context).primaryColor.withOpacity(1),
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 33),
              child: Text(
                description??'',
                textDirection: detectDirection(description),
                style:
                Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: onReturn, child: Text(
                  returnText??'',
                  textDirection: detectDirection(description),
                  style:
                  Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w400,
                  ),
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 90,
                      child: ElevatedButton(
                        child: Text(
                          cancelText??'',
                          style:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          //foregroundColor: Theme.of(context).colorScheme.tertiary,
                          backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: onCancel,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 40,
                      width: 90,
                      child: ElevatedButton(
                        child: Text(
                          confirmText??'',
                          style:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: whiteColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          //foregroundColor: Theme.of(context).colorScheme.tertiary,
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: onConfirm,
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
