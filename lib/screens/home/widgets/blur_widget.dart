import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../main/widgets/screen_builder.dart';

class BlurWidget extends StatefulWidget {
  bool isAddButtonClicked = false;
  final GlobalKey<NavigatorState> navigatorKey;
  Function(bool) changeAddButtonState;

  BlurWidget(this.isAddButtonClicked, this.navigatorKey, this.changeAddButtonState);


  @override
  State<BlurWidget> createState() => _BlurWidgetState();
}

class _BlurWidgetState extends State<BlurWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeWidget() {
    _controller.reverse().then((_) {
      widget.changeAddButtonState(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _closeWidget,
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
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnimatedColumn(
                        -1,
                        AppLocalizations.of(context)!.translateNested('bottomBar', 'content'),
                        FontAwesomeIcons.thinCloudArrowUp,
                            () {
                          _closeWidget();
                          widget.navigatorKey.currentState!.pushNamed(AppRoutes.createMedia);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 55),
                        child: _buildAnimatedColumn(
                          0,
                          AppLocalizations.of(context)!.translateNested('bottomBar', 'consultation'),
                          FontAwesomeIcons.thinComment,
                          _closeWidget,
                        ),
                      ),
                      _buildAnimatedColumn(
                        1,
                        AppLocalizations.of(context)!.translateNested('bottomBar', 'charity'),
                        FontAwesomeIcons.thinHandsHolding,
                        _closeWidget,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedColumn(double angle, String text, IconData icon, VoidCallback onPressed) {
    final double distance = 20.0;
    final double x = distance * angle * (1 - _animation.value);
    final double y = distance * (1 - _animation.value);

    return Transform.translate(
      offset: Offset(x, y),
      child: Opacity(
        opacity: _animation.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
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
                onPressed: onPressed,
                child: FaIcon(size: 22, icon, color: whiteColor),
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
    );
  }
}