// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:payutc/compil.dart';
import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/models/transfert.dart';
import 'package:payutc/src/models/user.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/services/random_sentence.dart';
import 'package:payutc/src/services/search_user_manager.dart';
import 'package:payutc/src/ui/screen/select_amount.dart';
import '../style/color.dart';

class SelectTransfertAmountScreen extends StatefulWidget {
  final User target;

  const SelectTransfertAmountScreen({Key? key, required this.target})
      : super(key: key);

  @override
  State<SelectTransfertAmountScreen> createState() =>
      _SelectTransfertAmountScreenState();
}

class _SelectTransfertAmountScreenState
    extends State<SelectTransfertAmountScreen> {
  double amount = 0;
  final TextEditingController message = TextEditingController();
  bool loading = false;
  late RandomSentences randomSentences;
  RandomSentences? randomSentencesPay;

  String _randomPay = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      randomSentences =
          RandomSentences("transfert.json", Localizations.localeOf(context));
      randomSentencesPay = RandomSentences(
          "transfert_pay.json", Localizations.localeOf(context));
      randomSentences.init();
      await randomSentencesPay!.init();
      setState(() {
        _randomPay = randomSentencesPay!.item;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text("Envoyer"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      CircleAvatar(
                        radius: 60,
                        child: Text(
                          widget.target.maj,
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.target.name,
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SleekCircularSlider(
                        initialValue: amount,
                        appearance: CircularSliderAppearance(
                          size: 200,
                          customColors: CustomSliderColors(
                            dotColor: AppColors.orange,
                            trackColor: Colors.black26,
                            progressBarColor: Colors.black,
                            shadowColor: AppColors.black,
                            shadowStep: 2,
                            shadowMaxOpacity: 0.1,
                          ),
                        ),
                        onChange: (double value) {
                          amount = _compilValue(value);
                        },
                        innerWidget: (value) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (ctx) => SelectAmount(
                                    onAmountSelected: (context, am) {
                                      Navigator.pop(context);
                                      amount = min(
                                          (AppService.instance.userAmount), am);
                                      setState(() {});
                                    },
                                    motif: Translate.of(context)
                                        .transfert_montant_select_amount),
                              ),
                            );
                          },
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${(amount).toStringAsFixed(2)}€",
                                  style: const TextStyle(fontSize: 25),
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  "Changer",
                                  style: TextStyle(
                                      fontSize: 13, color: AppColors.orange),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Stack(
                            children: [
                              TextFormField(
                                controller: message,
                                maxLines: 5,
                                maxLength: 250,
                                decoration: InputDecoration(
                                  hintText: Translate.of(context)
                                      .helpMessageTransfert,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: const EdgeInsets.all(15),
                                ),
                              ),
                              Positioned(
                                right: 9.5,
                                bottom: 25,
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 35,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.casino,
                                            color: Colors.grey,
                                            size: 28,
                                          ),
                                          onPressed: () {
                                            message.text = randomSentences.item;
                                            message.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset: message
                                                            .text.length));
                                          },
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 35,
                                      //   child: IconButton(
                                      //     icon: const Icon(
                                      //       Icons.chat,
                                      //       color: Colors.grey,
                                      //       size: 28,
                                      //     ),
                                      //     onPressed: () async {
                                      //       String? selectSentence =
                                      //           await _showSelector();
                                      //       if (selectSentence != null) {
                                      //         message.text = selectSentence;
                                      //         message.selection =
                                      //             TextSelection.fromPosition(
                                      //                 TextPosition(
                                      //                     offset: message
                                      //                         .text.length));
                                      //       }
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () async {
                          double amountDb =
                              double.parse(amount.toStringAsFixed(2)) * 100;
                          if (amountDb == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    Translate.of(context).nothingToTransfert)));
                            return;
                          }
                          bool didAuth = true;
                          try {
                            final LocalAuthentication auth =
                                LocalAuthentication();
                            if (!await auth.isDeviceSupported()) {
                              throw 'no-check-possible';
                            }
                            if (!await auth.canCheckBiometrics) {
                              throw 'no-check-possible';
                            }
                            if (mounted) {
                              didAuth = await auth.authenticate(
                                localizedReason:
                                    Translate.of(context).authReasonTransfert,
                                authMessages: [
                                  const AndroidAuthMessages(
                                    signInTitle: "Transfert payUTC",
                                  ),
                                  const IOSAuthMessages(
                                    cancelButton: "Annuler",
                                    goToSettingsButton: "Paramètres",
                                    goToSettingsDescription:
                                        "Veuillez vous authentifier pour continuer",
                                    lockOut: "Veuillez vous authentifier",
                                  ),
                                ],
                              );
                            }
                          } catch (e, st) {
                            logger.e('error Auth transfert', e, st);
                          }
                          if (!didAuth) {
                            return;
                          }
                          try {
                            setState(() {
                              loading = true;
                            });
                            SearchUserManagerService.historyManager
                                .add(widget.target);
                            final t = Transfert.makeTransfert(
                                widget.target, amountDb / 100, message.text);
                            bool res =
                                await AppService.instance.makeTransfert(t);
                            if (!res) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        Translate.of(context).transfert_error),
                                  ),
                                );
                                setState(() {
                                  loading = false;
                                });
                              }
                              return;
                            }
                          } catch (e, st) {
                            logger.e("Transfert error", e, st);
                            Sentry.captureException(e, stackTrace: st);
                          }
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Envoyé !"),
                              ),
                            );
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text(_randomPay),
                      ),
                      const Text(
                        "📢 Vous êtes toujours/totalement responsable de vos messages !",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _compilValue(double value) =>
      ((value / 100) * (AppService.instance.userAmount));

  Future<String?> _showSelector() async {
    return showModalBottomSheet<String>(
      isScrollControlled: true,
      context: context,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        snapSizes: const [0.3, 0.5, 0.85],
        snap: true,
        expand: false,
        builder: (_, controller) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0)
                .subtract(const EdgeInsets.only(bottom: 15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Selectionnez un message",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ListView(
                      controller: controller,
                      children: [
                        for (String item in randomSentences.items)
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, item);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                item,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
