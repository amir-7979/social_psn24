import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/shimmer.dart';

class ShimmerCommentItem extends StatelessWidget {
  const ShimmerCommentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          shimmerContainer(context,
              width: 50, height: 50, radius: 8),
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
      ),
    );
  }
}
