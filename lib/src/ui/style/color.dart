import 'package:flutter/material.dart';

class AppColors {
  static const Color scaffold = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Color(0xffB82010);
  static const MaterialColor orange = MaterialColor(_orangeValue, <int, Color>{
    50: Color(0xFFFEF3E4),
    100: Color(0xFFFDE2BB),
    200: Color(0xFFFCCF8E),
    300: Color(0xFFFBBC60),
    400: Color(0xFFFAAD3E),
    500: Color(_orangeValue),
    600: Color(0xFFF89719),
    700: Color(0xFFF78D14),
    800: Color(0xFFF68311),
    900: Color(0xFFF57209),
  });
  static const int _orangeValue = 0xFFF99F1C;

  static const Color scaffold_dark = Color(0xFF424242);
}
