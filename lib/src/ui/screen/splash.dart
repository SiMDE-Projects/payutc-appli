import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:payutc/compil.dart';
import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/ui/component/ui_utils.dart';
import 'package:payutc/src/ui/screen/home.dart';
import 'package:payutc/src/ui/style/color.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppColors.scaffoldDark,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/img/payutc.svg",
              color: Colors.white,
              width: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Pay'UTC",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            const SizedBox(
              height: 10,
            ),
            if (error) ...[
              Text(
                Translate.of(context).splashError,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange.withOpacity(0.3)),
                onPressed: () {
                  _load();
                },
                child: Text(Translate.of(context).ressayer),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.scaffoldDark,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                child: Text(Translate.of(context).splashConnect),
              )
            ] else
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    Translate.of(context).splashLoading,
                    textStyle: const TextStyle(color: Colors.white),
                    speed: const Duration(milliseconds: 100),
                    cursor: '💰',
                  ),
                ],
                pause: const Duration(milliseconds: 2000),
                repeatForever: true,
              ),
          ],
        ),
      ),
    );
  }

  void _load() async {
    bool isLogged = error = false;
    if (mounted) setState(() {});
    try {
      isLogged = await AppService.instance.initApp();
    } catch (e, st) {
      Sentry.captureException(e, stackTrace: st);
      logger.e(e, e, st);
      isLogged = false;
      error = true;
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translate.of(context).splashError),
          ),
        );
      }
      return;
    }
    logger.i("User logged : $isLogged");
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    if (isLogged) {
      logger.i("User logged as ${AppService.instance.user.username}");
      Sentry.configureScope(
        (p0) => p0.setContexts(
          "user",
          {"username": AppService.instance.user.username},
        ),
      );
    }
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => !isLogged ? const LoginPage() : const HomePage()));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController(),
      password = TextEditingController();
  bool isCas = true;

  bool loading = false;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  isCas = !isCas;
                });
              },
              child: SvgPicture.asset(
                "assets/img/payutc.svg",
                width: 30,
                color: isCas ? Colors.black : AppColors.orange,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Stack(
                children: [
                  AutofillGroup(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Translate.of(context).connectToPayutc,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          Translate.of(context).connectToPayutcSentence,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: isCas
                              ? null
                              : const Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("Connexion avec l'email"),
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: username,
                          validator: (_) => _!.isEmpty
                              ? Translate.of(context).fieldNeeded
                              : null,
                          autofillHints: [
                            if (!isCas) AutofillHints.email,
                            AutofillHints.username
                          ],
                          decoration: InputDecoration(
                            hintText: isCas
                                ? Translate.of(context).userName
                                : "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (_) => _!.isEmpty
                              ? Translate.of(context).fieldNeeded
                              : null,
                          obscureText: true,
                          controller: password,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            hintText: Translate.of(context).password,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            _connect(context);
                          },
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        if (!isCas)
                          const Text(
                            "Attention, connexion HORS CAS UTC",
                            textAlign: TextAlign.center,
                          ),
                        ElevatedButton(
                          onPressed: loading ? null : () => _connect(context),
                          child: Text(Translate.of(context).connect),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text.rich(
                          TextSpan(
                            text: Translate.of(context).connect_mention_legs,
                            children: [
                              TextSpan(
                                  text:
                                      " ${Translate.of(context).mentionsLgales}",
                                  style: const TextStyle(
                                    color: AppColors.orange,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _mentionsLeg)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _mentionsLeg() {
    showWebView(
      context,
      "assets/therms/cgu.html",
      Translate.of(context).mentionsLgales,
    );
  }

  void _connect(BuildContext context) async {
    if (!Form.of(context)!.validate()) return;
    setState(() {
      loading = true;
    });
    try {
      bool b = await AppService.instance
          .connectUser(username.text, password.text, isCas);
      if (b && mounted) {
        if (Platform.isAndroid) TextInput.finishAutofillContext();
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
        return;
      }
      throw 'error';
    } catch (e, st) {
      if (e is String) {
        switch (e) {
          case 'cas/bad-credentials':
            if (!isCas) {
              AppService.instance.storageService.clear();
            }
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(Translate.of(context).badPassword)));
            return;
        }
      } else {
        Sentry.captureException(e, stackTrace: st);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translate.of(context).splashError),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }
}
