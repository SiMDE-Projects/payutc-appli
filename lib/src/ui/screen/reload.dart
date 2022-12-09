// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/env.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/ui/screen/select_amount.dart';
import 'package:payutc/src/ui/style/color.dart';

class PaymentFlowPage extends StatefulWidget {
  final double amount;

  const PaymentFlowPage({Key? key, required this.amount}) : super(key: key);
  static int _max = -1;

  static Future<bool> paymentFlow(BuildContext context) async {
    if (_max == -1) {
      _max = await AppService.instance.nemoPayApi.getMaxAmount();
    }
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => SelectAmount(
          onAmountSelected: (context, amount) async {
            bool? res = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (ctx) => PaymentFlowPage(amount: amount),
              ),
            );
            if (res == true) {
              Navigator.pop(context, true);
            }
          },
          validator: (_) {
            return _ >= 10 && _ < (_max / 100);
          },
          motif: Translate.of(context).reloadAmount,
        ),
      ),
    ).then((value) => value ?? false);
  }

  @override
  State<PaymentFlowPage> createState() => _PaymentFlowPageState();
}

class _PaymentFlowPageState extends State<PaymentFlowPage> {
  String? _url, _error;

  @override
  void initState() {
    AppService.instance.nemoPayApi
        .requestTransfertUrl(widget.amount)
        .then((value) => setState(() {
              _url = value;
              if (mounted) {
                setState(() {});
              }
            }))
        .catchError((e) {
      _error = "Une erreur est survenue";
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? res = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(Translate.of(context).quitterLaPage),
            actions: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black54),
                onPressed: () => Navigator.pop(context, true),
                child: Text(Translate.of(context).yes),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(Translate.of(context).no),
              ),
            ],
          ),
        );
        return res ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: [
            if (_url != null)
              IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: const Text("Ouvrir dans le navigateur"),
                      content: const Text(
                        "Tu n'arrive pas à accéder à la page ou au "
                        "paiement ? Tu peux essayer d'ouvrir la page dans "
                        "un navigateur. (Il faudra ensuite revenir sur l'application)",
                        style: TextStyle(fontSize: 12),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Annuler"),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.black54),
                          onPressed: () {
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                            launchUrlString(_url!,
                                mode: LaunchMode.externalApplication);
                          },
                          child: const Text("Passer par le navigateur"),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
        backgroundColor: Colors.black,
        body: FutureBuilder<String?>(
            future: Future.value(_url),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: SizedBox.expand(
                      child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: snapshot.data!,
                    onPageStarted: (navigation) {
                      Uri url = Uri.parse(navigation);
                      Uri callback = Uri.parse(payUrlCallback);
                      if (url.host == callback.host) {
                        if (url.path == callback.path) {
                          Navigator.pop(context, true);
                        }
                      }
                    },
                  )),
                );
              }
              if (_error != null) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "$_error",
                      style: const TextStyle(color: AppColors.red),
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
