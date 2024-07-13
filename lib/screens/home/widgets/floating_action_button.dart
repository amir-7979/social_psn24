import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../configs/setting/themes.dart';

class MyFloatingActionButton extends StatelessWidget {
  bool isAddButtonClicked;
  Function(bool) changeAddButtonState;
  MyFloatingActionButton(this.isAddButtonClicked, this.changeAddButtonState);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
        return isKeyboardOpen
            ? Container() // Return an empty container when keyboard is open
            : isAddButtonClicked
            ? SizedBox(
          height: 55,
          width: 55,
          child: FloatingActionButton(
            onPressed: () => changeAddButtonState(false),
            child: FaIcon(size: 22, FontAwesomeIcons.thinXmark, color: whiteColor),
            backgroundColor: Theme.of(context).colorScheme.error,
            shape: CircleBorder(),
          ),
        )
            : FloatingActionButton(
          onPressed: () => changeAddButtonState(true),
          child: FaIcon(size: 22, FontAwesomeIcons.thinPlus, color: whiteColor),
          backgroundColor: Theme.of(context).primaryColor,
          shape: CircleBorder(),
        );
      },
    );
  }
}
