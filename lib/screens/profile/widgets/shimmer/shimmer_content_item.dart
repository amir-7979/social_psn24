import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widgets/shimmer.dart';

class ShimmerContentItem extends StatelessWidget {
  const ShimmerContentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: shimmerContainer(context),
    );
  }
}