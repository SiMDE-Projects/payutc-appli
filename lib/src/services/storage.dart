import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payutc/src/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService();

  static SharedPreferences? _preferences;

  Locale get locale => Locale(this["locale"] ?? "fr");

  Future<bool> get haveAccount =>
      const FlutterSecureStorage().containsKey(key: "user_data");

  set locale(Locale locale) =>
      _preferences?.setString("locale", locale.languageCode);

  Future<void> user(UserData userData) => const FlutterSecureStorage()
      .write(key: "user_data", value: userData.pack());

  Future<UserData?> get userData async {
    return (const FlutterSecureStorage().read(key: "user_data").then(
      (value) {
        if (value == null) return null;
        return UserData.unpack(value);
      },
    ));
  }

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  dynamic operator [](String key) {
    return _preferences!.get(key);
  }

  void setValue(String key, String value) =>
      _preferences!.setString(key, value);

  String? get ticket => _preferences!.getString("ticket_cas");

  bool get haveToken => _preferences!.containsKey("ticket_cas");

  set ticket(String? value) {
    if (value == null) {
      _preferences!.remove("ticket_cas");
      return;
    }
    _preferences!.setString("ticket_cas", value);
  }

  Future<void> clear() async {
    await _preferences!.clear();
    await const FlutterSecureStorage().deleteAll();
  }
}
