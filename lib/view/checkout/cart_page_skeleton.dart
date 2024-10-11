import 'package:flutter/material.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:store_app/view/utils/text_skeleton.dart';
import 'package:shimmer/shimmer.dart';

class CartPageSkeleton extends StatelessWidget {
  const CartPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: Colors.black38,
      highlightColor: Colors.white,
      child: Column(
        children: [
          textRow(),
          gapH(15),
          textRow(),
          gapH(15),
          textRow(),
          gapH(15),
          textRow(),
          gapH(15),
          textRow(),
          gapH(15),
          textRow(),
          gapH(15),
        ],
      ),
    );
  }

  textRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextSkeleton(
          height: 16,
          width: 100,
        ),
        TextSkeleton(
          height: 16,
          width: 60,
        ),
      ],
    );
  }
}
