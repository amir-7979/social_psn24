import 'package:flutter/material.dart';

class WhiteCircularProgressIndicator extends StatelessWidget {
  const WhiteCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      width: 22,
      child: const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}
