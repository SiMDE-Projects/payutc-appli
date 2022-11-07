import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:payutc/src/models/user.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/services/storage.dart';

class SearchUserManagerService extends ChangeNotifier {
  final StorageService storageService;

  final String saveKey;

  SearchUserManagerService(this.storageService, this.saveKey) {
    users = _getUsers();
    notifyListeners();
  }

  static final SearchUserManagerService favManager =
      SearchUserManagerService(AppService.instance.storageService, "users_fav");
  static final SearchUserManagerService historyManager =
      SearchUserManagerService(
          AppService.instance.storageService, "history_fav");

  List<User> users = [];

  List<User> _getUsers() {
    final data = storageService[saveKey];
    if (data != null) {
      return (jsonDecode(data) as List).map((e) => User.fromJson(e)).toList();
    }
    return [];
  }

  void remove(User user) {
    users.removeWhere((element) => element.id == user.id);
    saveState();
    notifyListeners();
  }

  void add(User user) {
    if (exist(user)) return;
    users.add(user);
    saveState();
    notifyListeners();
  }

  bool exist(User user) {
    return users.any((element) => element.id == user.id);
  }

  void saveState() {
    storageService.setValue(
        saveKey, jsonEncode(users.map((e) => e.toJson()).toList()));
  }
}
