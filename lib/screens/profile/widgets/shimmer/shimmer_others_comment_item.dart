import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../../../widgets/shimmer.dart';

class ShimmerOthersCommentItem extends StatelessWidget {
  const ShimmerOthersCommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        shimmerCircular(context,
           size: 50),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              shimmerContainer(context,
                  width: 50, height: 10, radius: 16),
              SizedBox(height: 10),
              shimmerContainer(context,
                  width: 150, height: 10, radius: 16),
              SizedBox(height: 45),
            ],
          ),
        ),
      ],
    );
  }
}
