import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:payut/compil.dart';
import 'package:payut/src/services/app.dart';
import 'package:payut/src/ui/screen/splash.dart';
import 'package:payut/src/ui/style/theme.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  logger.i("Starting app logger");
  await AppService.instance.storageService.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.black),
  );
  FlutterError.onError =
      (details) => logger.e(details.context, details.exception, details.stack);
  logger.i("App ready !");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppService.instance,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Pay\'ut',
          theme: AppTheme.getTheme(Brightness.light),
          home: const SplashPage(),
          localizationsDelegates: const [
            Translate.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: Translate.delegate.supportedLocales,
          locale: AppService.instance.currentLocale,
        );
      },
    );
  }
}
