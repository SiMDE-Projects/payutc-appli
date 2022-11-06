import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payutc/src/api/cas.dart';
import 'package:payutc/src/api/ginger.dart';
import 'package:payutc/src/api/nemopay.dart';
import 'package:payutc/src/models/GingerUserInfos.dart';
import 'package:payutc/src/models/NemoPayAppProperties.dart';
import 'package:payutc/src/models/Wallet.dart';
import 'package:payutc/src/models/transfert.dart';
import 'package:payutc/src/models/user_data.dart';
import 'package:payutc/src/services/history.dart';
import 'package:payutc/src/services/storage.dart';
import 'package:payutc/src/services/wallet.dart';

import '../env.dart';

class AppService extends ChangeNotifier {
  static AppService? _instance;

  static AppService get instance {
    _instance ??= AppService();
    return _instance!;
  }

  late FlutterSecureStorage _secureStorage;
  late StorageService storageService;
  late HistoryService historyService;
  late CasApi _casApi;
  late NemoPayApi nemoPayApi;
  late WalletService walletService;

  AppService(
      {CasApi? casApi, NemoPayApi? nemoPayApi, StorageService? storageService})
      : _casApi = casApi ?? CasApi(),
        nemoPayApi = nemoPayApi ?? NemoPayApi(),
        storageService = storageService ?? StorageService() {
    historyService = HistoryService(this);
    walletService = WalletService(this);
    _secureStorage = const FlutterSecureStorage();
  }

  String? userName;

  bool get isConnected => storageService.haveToken && userName != null;

  Future<bool> get isFirstConnect =>
      storageService.haveAccount.then((value) => !value);

  late NemoPayAppProperties appProperties;

  Wallet? get userWallet => walletService.data;

  double get userAmount =>
      (historyService.history?.credit?.toDouble() ?? 0) / 100;

  Locale get currentLocale => storageService.locale;

  Brightness get brightness => Brightness.light;

  Owner get user => userWallet!.user;

  Future<bool> initApp() async {
    await storageService.init();
    if (await isFirstConnect) return false;
    UserData d = (await storageService.userData)!;
    userName = await (d.isCas ? _casConnect() : _classicConnect());
    appProperties = await nemoPayApi.getAppProperties();
    await walletService.forceLoad();
    await historyService.forceLoadHistory();
    return true;
  }

  void setLocale(Locale locale) {
    storageService.locale = locale;
    notifyListeners();
  }

  Future<bool> connectUser(String user, String password,
      [bool casConnect = true]) async {
    await storageService.init();
    if (casConnect) {
      storageService.ticket = await _casApi.connectUser(user, password);
    } else {
      storageService.ticket = await nemoPayApi.connectUser(user, password);
      print(storageService.ticket);
    }
    await storageService.user(UserData.create(user, password, casConnect));
    return initApp();
  }

  String translateMoney(num num) {
    return "${num.toDouble().toStringAsFixed(2)}${appProperties.config?.currencySymbol}";
  }

  void refreshContent() {
    historyService.forceLoadHistory();
    walletService.forceLoad();
  }

  String generateShareLink() {
    final user = {
      "email": userWallet!.user.email!,
      "name": _generateUserName(userWallet!.user),
      "id": userWallet!.user.id!,
    };
    return "payutc://share.payutc.fr/transfert/${base64Encode(jsonEncode(user).codeUnits)}";
  }

  Future<bool> makeTransfert(Transfert transfert) async {
    bool res = await walletService.makeTransfert(transfert);
    return res;
  }

  _generateUserName(Owner user) {
    return "${user.firstName} ${user.lastName!.toUpperCase()} (${user.username})";
  }

  Future<GingerUserInfos> getGingerInfos() {
    return Ginger.getUserInfos(userName!, gingerKey);
  }

  Future<bool> changeBadgeState(bool value) => nemoPayApi.setBadgeState(value);

  Future<String> _casConnect() async {
    String ticket = "";
    try {
      ticket = await _casApi.reConnectUser(storageService.ticket);
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        if (e.response!.statusCode == 404) {
          UserData? d = await storageService.userData;
          if (d == null) rethrow;
          bool e = await connectUser(d.user, d.secret, d.isCas);
          if (e) {
            return _casConnect();
          }
        }
      }
    }
    return await nemoPayApi.connectCas(ticket);
  }

  Future<String> _classicConnect() async {
    UserData user = (await storageService.userData)!;
    try {
      return await nemoPayApi.connectUser(user.user, user.secret);
    } catch (e) {
      throw 'cas/bad-credentials';
    }
  }
}
