import 'package:flutter/material.dart';

class TextSkeleton extends StatelessWidget {
  final height;
  final width;
  const TextSkeleton({this.height, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.toDouble(),
      height: height?.toDouble(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black26,
      ),
    );
  }
}
