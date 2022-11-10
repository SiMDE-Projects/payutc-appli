import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:payutc/src/api/nemopay.dart';
import 'package:payutc/src/models/nemopay_app_properties.dart';
import 'package:payutc/src/models/wallet.dart';

import 'api_test.mocks.dart';

@GenerateMocks([NemoPayApi])
@GenerateNiceMocks([MockSpec<NemoPayAppProperties>(),MockSpec<Wallet>()])

void main() {
  //test NemoPayApi mock
  group("NemoPayApi", () {
    test('Test getAppProperties', () async {
      final mock = MockNemoPayApi();
      when(mock.getAppProperties())
          .thenAnswer((_) async => MockNemoPayAppProperties());
      final resp = await mock.getAppProperties();
      expect(resp, isA<NemoPayAppProperties>());
    });
    //test all others methods
    test('Test connectCas', () async {
      final mock = MockNemoPayApi();
      when(mock.connectCas("ticket"))
          .thenAnswer((_) async => "username");
      final resp = await mock.connectCas("ticket");
      expect(resp, "username");
    });
    test('Test getUserWallet', () async {
      final mock = MockNemoPayApi();
      when(mock.getUserWallet("username"))
          .thenAnswer((_) async => MockWallet());
      final resp = await mock.getUserWallet("username");
      expect(resp, isA<MockWallet>());
    });
  });
}
//flutter build_runner
