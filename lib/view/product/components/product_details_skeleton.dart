import 'dart:math';

import 'package:flutter/material.dart';
import 'package:store_app/view/utils/constant_colors.dart';
import 'package:store_app/view/utils/constant_styles.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/responsive.dart';

class ProductDetailsSkeleton extends StatelessWidget {
  const ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: greyFive,
      highlightColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 300,
              margin: const EdgeInsets.symmetric(),
              width: double.infinity,
              color: Colors.red),
          // ProductDetailsImages(),
          gapH(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 15,
                  width: getScreenWidth(context) / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), color: greyFive),
                ),
                Container(
                  height: 15,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), color: greyFive),
                ),
              ],
            ),
          ),
          gapH(20),
          ...Iterable.generate(4).map(
            (e) => Container(
              height: 10,
              width: getScreenWidth(context) -
                  Random()
                      .nextInt(
                        100,
                      )
                      .toDouble(),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: greyFive),
            ),
          ),
          gapH(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              ...Iterable.generate(5).map(
                (e) => Container(
                  height: 39,
                  width: 39,
                  margin: const EdgeInsets.only(top: 7, right: 4, left: 17),
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.circular(10),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ]),
          ),
          gapH(20),
          ...Iterable.generate(4).map(
            (e) => Container(
              height: 10,
              width: Random()
                  .nextInt(
                    100,
                  )
                  .toDouble(),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: greyFive),
            ),
          ),
          // ProductDetailsCartButton(1, () {}),
        ],
      ),
    );
  }
}
