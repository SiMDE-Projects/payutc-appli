// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:payutc/src/api/cas.dart';
import 'package:payutc/src/api/nemopay.dart';

void main() {
  test('Test nemopay api', () async {
    NemoPayApi nemopay = NemoPayApi();
    CasApi cas = CasApi();
    await nemopay.getAppProperties();
    //user connect
    String ticketGrantingTicket =
        await cas.connectUser("jumeltom", "uc5nYT@A!EhDDdR");
    String ticket = await cas.reConnectUser(ticketGrantingTicket);
    String username = await nemopay.connectCas(ticket);
    final wallet = await nemopay.getUserWallet(username);
  });
}
