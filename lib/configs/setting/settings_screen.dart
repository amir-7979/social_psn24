import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isSwitched = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
       mainAxisSize: MainAxisSize.max,
        children: [
          Switch(
            value: _isSwitched,
            onChanged: (bool value) {
              setState(() {
                _isSwitched = value;
              });
            },
          ),
        ],
      ),
    );

  }
}