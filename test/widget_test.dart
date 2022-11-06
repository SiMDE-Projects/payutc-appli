// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:payutc/main.dart';
import 'package:payutc/src/api/cas.dart';
import 'package:payutc/src/api/nemopay.dart';
import 'package:payutc/src/env.dart';
import 'package:payutc/src/models/Wallet.dart';

void main() {
  test('Test nemopay api', () async {
    NemoPayApi nemopay = NemoPayApi();
    CasApi cas = CasApi();
    await nemopay.getAppProperties();
    //user connect
    String TGT = await cas.connectUser("jumeltom", "uc5nYT@A!EhDDdR");
    String ticket = await cas.reConnectUser(TGT);
    String username = await nemopay.connectCas(ticket);
    print("Wallet");
    final wallet = await nemopay.getUserWallet(username);
    print(wallet.balances.credit!);
  });
}
