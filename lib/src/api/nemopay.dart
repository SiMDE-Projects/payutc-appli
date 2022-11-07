import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:payutc/src/env.dart' as env;
import 'package:payutc/src/models/nemopay_app_properties.dart';
import 'package:payutc/src/models/payutc_history.dart';
import 'package:payutc/src/models/user.dart';
import 'package:payutc/src/models/wallet.dart';
import 'package:sentry_dio/sentry_dio.dart';

import '../env.dart';
import '../models/transfert.dart';

class NemoPayApi {
  late Dio client;
  late CookieJar jar;

  NemoPayApi() {
    client = Dio(BaseOptions(baseUrl: env.nemoPayUrl, queryParameters: {
      "system_id": env.nemoPayAppId,
      "app_key": env.nemoPayKey
    }));
    jar = CookieJar();
    client.interceptors.add(CookieManager(jar));
    client.addSentry(captureFailedRequests: true);
  }

  /// services/MYACCOUNT/
  Future<NemoPayAppProperties> getAppProperties() async {
    final resp = await client.post("services/MYACCOUNT/loginApp",
        data: {"key": env.nemoPayKey},
        options: Options(contentType: Headers.jsonContentType));
    return NemoPayAppProperties.fromJson(resp.data);
  }

  Future<String> connectCas(String casTicket) async {
    final resp = await client.post("services/MYACCOUNT/loginCas2",
        data: {"service": env.nemoPayUrl, "ticket": casTicket},
        options: Options(contentType: Headers.jsonContentType));
    return resp.data["username"];
  }

  /// resources/wallets?user__username=''
  Future<Wallet> getUserWallet(String user) async {
    final resp = await client.get(
      "resources/wallets",
      queryParameters: {
        "user__username": user,
        "ordering": "id",
      },
      options: Options(
        headers: {"nemopay-version": "latest"},
      ),
    );
    return Wallet.fromJson(resp.data[0]);
  }

  /// /services/MYACCOUNT/historique
  Future<PayUtcHistory> getUserHistory() async {
    final resp = await client.post("services/MYACCOUNT/historique", data: {});
    return PayUtcHistory.fromJson(resp.data);
  }

  Future<List<User>> searchForUser(String request) async {
    final resp = await client.post(
      "services/TRANSFER/userAutocomplete",
      data: {"queryString": request},
      options: Options(contentType: Headers.jsonContentType),
    );
    if (resp.data is List) {
      return (resp.data as List).map((e) => User.fromJson(e)).toList();
    }
    throw 'bad state';
  }

  Future<int> getMaxAmount() async {
    final resp = await client.post(
      "services/RELOAD/info",
      options: Options(contentType: Headers.jsonContentType),
    );
    return resp.data["max_reload"] ?? 0;
  }

  Future<bool> makeTransfert(Transfert transfert) async {
    final resp = await client.post(
      "services/TRANSFER/transfer",
      data: transfert.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    return resp.statusCode == 200;
  }

  Future<String> requestTransfertUrl(double amount) async {
    final resp = await client.post(
      "services/RELOAD/reload",
      data: {
        "amount": amount * 100,
        "callbackUrl": payUrlCallback,
        "mobile": 1
      },
      options: Options(contentType: Headers.jsonContentType),
    );
    return resp.data;
  }

  Future<bool> setBadgeState(bool value) async {
    final resp = await client.post(
      "services/MYACCOUNT/setSelfBlock",
      data: {"blocage": value},
      options: Options(contentType: Headers.jsonContentType),
    );
    return resp.data.toString() == "true";
  }

  Future<String> connectUser(String email, String pass) async {
    final resp = await client.post(
      "services/MYACCOUNT/login2",
      data: {"login": email, "password": pass},
      options: Options(contentType: Headers.jsonContentType),
    );
    return resp.data["username"];
  }
}
