import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/ui/style/color.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({Key? key}) : super(key: key);

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  ScreenBrightness brightnessController = ScreenBrightness();

  @override
  void initState() {
    brightnessController.setScreenBrightness(1);
    super.initState();
  }

  @override
  void dispose() {
    brightnessController.resetScreenBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          Translate.of(context).receive,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: AppColors.scaffoldDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 260.0,
                  maxHeight: 260.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(8.0),
                child: QrImage(
                  data: AppService.instance.generateShareLink(),
                  embeddedImage: const AssetImage("assets/img/logo.jpg"),
                  foregroundColor: AppColors.black,
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  Translate.of(context).receiveMoneyScanSentence,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Text(
              //   "OU",
              //   style: TextStyle(color: Colors.white70),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // ElevatedButton(
              //   onPressed: () async {
              //     brightnessController.resetScreenBrightness();
              //     await Share.shareWithResult("Mon profil payutc :)\n" +
              //         AppService.instance.generateShareLink());
              //     brightnessController.setScreenBrightness(1);
              //   },
              //   child: Text("Envoyer mon profil"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<double> computeMaxQRSize(context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final screenWidthInPixels =
        MediaQuery.of(context).size.width * devicePixelRatio;
    final screenHeightInPixels =
        MediaQuery.of(context).size.height * devicePixelRatio;
    final maxQRWidth = 2 * devicePixelRatio;
    final maxQRHeight = 2 * devicePixelRatio;
    return [maxQRWidth, maxQRHeight];
  }
}
