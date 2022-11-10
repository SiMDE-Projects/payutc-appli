import 'package:flutter/foundation.dart';

import 'package:payutc/compil.dart';
import 'package:payutc/src/models/transfert.dart';
import 'package:payutc/src/models/wallet.dart';
import 'package:payutc/src/services/app.dart';

class WalletService extends ChangeNotifier {
  late final AppService context;

  WalletService([AppService? context])
      : context = context ?? AppService.instance;

  Wallet? data;

  Future<Wallet> load() async {
    if (context.isConnected) {
      return data ?? await forceLoad();
    }
    throw "Context error";
  }

  Future<Wallet> forceLoad() {
    if (context.isConnected) {
      return context.nemoPayApi
          .getUserWallet(context.userName!)
          .then((value) => data = value)
          .catchError((error, stackTrace) {
        logger.e("load wallet :", error, stackTrace);
      });
    }
    throw "Context error";
  }

  Future<bool> makeTransfert(Transfert transfert) {
    return context.nemoPayApi.makeTransfert(transfert);
  }
}
