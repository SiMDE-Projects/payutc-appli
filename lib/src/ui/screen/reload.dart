// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/env.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/ui/screen/select_amount.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  WebViewController? _controller;

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
        ),
        backgroundColor: Colors.black,
        body: FutureBuilder<String>(
            future: AppService.instance.nemoPayApi
                .requestTransfertUrl(widget.amount),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: SizedBox.expand(
                      child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: snapshot.data!,
                    onWebViewCreated: (controller) => _controller = controller,
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
              if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const SizedBox();
            }),
      ),
    );
  }
}
