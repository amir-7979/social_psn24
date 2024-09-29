import 'package:flutter/material.dart';

class ContentWidget extends StatefulWidget {
  final int? profileId;
   ContentWidget({this.profileId, Key? key}) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
