import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/setting/themes.dart';

class MyFloatingActionButton extends StatelessWidget {
  final bool isAddButtonClicked;
  final VoidCallback changeAddButtonState;

  MyFloatingActionButton(this.isAddButtonClicked, this.changeAddButtonState);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
        return isKeyboardOpen
            ? Container() // Return an empty container when the keyboard is open
            : FloatingActionButton(
          onPressed: changeAddButtonState,
          child: FaIcon(
            size: 22,
            isAddButtonClicked ? FontAwesomeIcons.thinXmark : FontAwesomeIcons.thinPlus,
            color: whiteColor,
          ),
          backgroundColor: isAddButtonClicked
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).primaryColor,
          shape: CircleBorder(),
        );
      },
    );
  }
}
