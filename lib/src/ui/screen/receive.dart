import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/services/app.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';

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
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white)),
                padding: const EdgeInsets.all(15),
                child: QrImage(
                  data: AppService.instance.generateShareLink(),
                  embeddedImage: const AssetImage("assets/img/logo.jpg"),
                  foregroundColor: Colors.white,
                ),
              ),
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
}
