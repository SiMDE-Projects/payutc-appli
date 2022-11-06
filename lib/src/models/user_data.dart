import 'dart:convert';

class UserData {
  late final String user, secret;
  late final bool isCas;

  UserData.create(this.user, this.secret, this.isCas);

  UserData.unpack(String data) {
    data = String.fromCharCodes(base64Decode(data));
    final splt = data.split(':');
    user = splt.first;
    isCas = splt[1] == "true";
    secret = splt.last;
  }

  String pack() {
    return base64Encode("$user:$isCas:$secret".codeUnits);
  }
}
