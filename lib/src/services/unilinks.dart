// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:uni_links/uni_links.dart';

import 'package:payutc/src/ui/screen/transfert_select_amount.dart';
import '../models/user.dart';

class UniLinks {
  static void handleLink(BuildContext context) async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri == null) return;
      switch (initialUri.pathSegments.first) {
        case 'transfert':
          User user = handleTransfertUri(initialUri);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => SelectTransfertAmountScreen(target: user)));
          break;
      }
    } on FormatException catch (_) {}
  }

  static handleTransfertUri(Uri uri) {
    if (uri.host != "share.payutc.fr") throw "";
    if (uri.pathSegments.first != "transfert") throw "";
    String data = String.fromCharCodes(base64Decode(uri.pathSegments.last));
    return User.fromJson(jsonDecode(data));
  }
}
