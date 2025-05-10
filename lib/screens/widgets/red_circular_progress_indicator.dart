import 'package:flutter/material.dart';

class RedCircularProgressIndicator extends StatelessWidget {
  const RedCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      width: 22,
      child: const CircularProgressIndicator(
        color: Colors.red,
        strokeWidth: 2,
      ),
    );
  }
}
