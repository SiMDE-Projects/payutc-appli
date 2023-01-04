import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:payutc/compil.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/ui/screen/splash.dart';
import 'package:payutc/src/ui/style/theme.dart';
import 'generated/l10n.dart';
import 'src/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppService.instance.storageService.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.black),
  );
  FlutterError.onError =
      (details) => logger.e(details.context, details.exception, details.stack);
  if (!kDebugMode) {
    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        options.tracesSampleRate = 0.5;
      },
      appRunner: () => runApp(const PayutcApp()),
    );
  } else {
    runApp(const PayutcApp());
  }
}

class PayutcApp extends StatelessWidget {
  const PayutcApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppService.instance,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Pay\'UTC',
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
