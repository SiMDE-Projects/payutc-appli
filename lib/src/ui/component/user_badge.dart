import 'package:flutter/material.dart';

import 'package:payutc/src/models/user.dart';
import 'package:payutc/src/ui/style/color.dart';

class UserBadge extends StatelessWidget {
  final User user;
  final double? radius;
  final double? textSize;
  final bool? darkMode;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const UserBadge(
      {super.key,
      required this.user,
      this.radius,
      this.textSize,
      this.darkMode,
      this.foregroundColor,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 30.0,
      backgroundColor:
          backgroundColor ?? ((darkMode ?? false) ? AppColors.black : null),
      foregroundColor: foregroundColor ??
          ((darkMode ?? false) ? Colors.white : AppColors.black),
      child: Text(
        user.maj,
        style: TextStyle(
          fontSize: textSize ?? 18.0,
        ),
      ),
    );
  }
}
