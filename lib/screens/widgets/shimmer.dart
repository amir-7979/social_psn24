import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../configs/setting/themes.dart';

Widget shimmerContainer(BuildContext context, {double? width, double? height, double? radius}) {
  Color baseColor = Theme.of(context).brightness == Brightness.dark
    ? darkBaseColor
    : lightBaseColor;
  Color highlightColor = Theme.of(context).brightness == Brightness.dark
    ? darkHighlightColor
    : lightHighlightColor;

  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 16),
        color: Colors.white,
      ),
    ),
  );
}

Shimmer shimmerCircular(BuildContext context, {double? size}) {
  Color baseColor = Theme.of(context).brightness == Brightness.dark
    ? darkBaseColor
    : lightBaseColor;
  Color highlightColor = Theme.of(context).brightness == Brightness.dark
    ? darkHighlightColor
    : lightHighlightColor;

  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    ),
  );
}