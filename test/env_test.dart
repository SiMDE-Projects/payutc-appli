// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:payutc/src/env.dart';

void main() {
  group("Env", () {
    test('Test env public values', () async {
      //check public urls
      expect(nemoPayUrl, 'https://api.nemopay.net/');
      print("Valid nemoPayUrl");
      expect(payUrlCallback, 'https://assos.utc.fr/pay_app_callback');
      print("Valid payUrlCallback");
      expect(casUrl, 'https://cas.utc.fr/cas/');
      print("Valid casUrl");
      expect(nemoPayAppId, "80405");
      print("Valid nemoPayAppId");
    });
    //verify env private fields are not empty and "valid"
    test('Test env private fields', () async {
      expect(nemoPayKey, isNotEmpty);
      expect(gingerKey, isNotEmpty);
      //sentry is url
      expect(sentryDsn, isNotEmpty);
      expect(sentryDsn, startsWith('https://'));
    });
  });
}

void print(message) {
  stdout.writeln(message);
}
