import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget {
  final int? profileId;
  CommentWidget({this.profileId, Key? key}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
