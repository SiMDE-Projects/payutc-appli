import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/ui/style/color.dart';

class AppTheme {
  static final ThemeData _default = ThemeData(
    scaffoldBackgroundColor: AppColors.scaffold,
    primarySwatch: AppColors.orange,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    ),
  );
  static final ThemeData _light = _default.copyWith(
      scaffoldBackgroundColor: AppColors.scaffold,
      appBarTheme: _default.appBarTheme
          .copyWith(iconTheme: const IconThemeData(color: Colors.black)));

  static SystemUiOverlayStyle combineOverlay(SystemUiOverlayStyle other) =>
      _default.appBarTheme.systemOverlayStyle!.copyWith(
        statusBarBrightness: other.statusBarBrightness,
        systemStatusBarContrastEnforced:
            other.systemNavigationBarContrastEnforced,
        systemNavigationBarIconBrightness:
            other.systemNavigationBarIconBrightness,
        statusBarIconBrightness: other.statusBarIconBrightness,
        systemNavigationBarContrastEnforced:
            other.systemNavigationBarContrastEnforced,
      );

  static ThemeData get current => getTheme(AppService.instance.brightness);

  static ThemeData getTheme(Brightness brightness) {
    return _light;
  }
}
