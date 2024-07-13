import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';

class BlurWidget extends StatefulWidget {
  bool isAddButtonClicked = false;
  BlurWidget(this.isAddButtonClicked);


  @override
  State<BlurWidget> createState() => _BlurWidgetState();
}

class _BlurWidgetState extends State<BlurWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.isAddButtonClicked = false;
        });
      },
      child: Container(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withOpacity(0.5)
            : Colors.white.withOpacity(0.5),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translateNested('bottomBar', 'content'),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.shadow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 55,
                        width: 55,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: FaIcon(size: 22, FontAwesomeIcons.thinCloudArrowUp, color: whiteColor),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            shape: CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 55),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translateNested('bottomBar', 'consultation'),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.shadow,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 55,
                          width: 55,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: FaIcon(size: 22, FontAwesomeIcons.thinComment, color: whiteColor),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                              shape: CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translateNested('bottomBar', 'charity'),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.shadow,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 55,
                        width: 55,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: FaIcon(size: 22, FontAwesomeIcons.thinHandsHolding, color: whiteColor),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            shape: CircleBorder(),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
