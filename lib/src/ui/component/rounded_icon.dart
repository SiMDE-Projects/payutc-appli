import 'package:flutter/material.dart';

class RoundedIcon extends StatelessWidget {
  final Widget icon;

  const RoundedIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFDBDBDB),
        ),
      ),
      child: AspectRatio(aspectRatio: 1, child: icon),
    );
  }
}
