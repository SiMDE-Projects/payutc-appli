import 'package:flutter/cupertino.dart';

import 'package:payutc/compil.dart';
import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/models/payutc_history.dart';
import 'package:payutc/src/services/app.dart';

class HistoryService extends ChangeNotifier {
  late final AppService context;

  HistoryService([AppService? context])
      : context = context ?? AppService.instance;

  PayUtcHistory? history;

  Future<PayUtcHistory> loadHistory() async {
    if (context.isConnected) {
      return history ?? await forceLoadHistory();
    }
    throw "Context error";
  }

  Future<PayUtcHistory> forceLoadHistory() {
    if (context.isConnected) {
      return context.nemoPayApi.getUserHistory().then((value) {
        history = value;
        notifyListeners();
        return history!;
      }).catchError((error, stackTrace) {
        logger.e("force load history", error, stackTrace);
        throw error;
      });
    }
    throw "Context error";
  }
}

class HistoryController extends ChangeNotifier {
  final HistoryService service;

  HistoryController(this.service) {
    service.addListener(notifyListeners);
  }

  PayUtcHistory? history;
  bool loading = false;

  void loadHistory({bool silent = false, bool forced = false}) async {
    if (!silent) {
      loading = true;
    }
    notifyListeners();
    if (forced) {
      history = await service.forceLoadHistory();
    } else {
      history = await service.loadHistory();
    }
    if (!silent) {
      loading = false;
    }
    notifyListeners();
  }

  Map<String, List<PayUtcItem>> parsedItems(BuildContext context) {
    if (history == null) return {};
    Map<String, List<PayUtcItem>> out = {};
    List<PayUtcItem> items = history!.historique!;
    for (final item in items) {
      String key = _generate(item.date);
      if (out[key] == null) {
        out[key] = [];
      }
      out[key]!.add(item);
    }
    Map<DateTime, List<PayUtcItem>> itemsDate =
        out.map((key, value) => MapEntry(DateTime.parse(key), value));
    //get most 7 most recents dates
    List<DateTime> dates = itemsDate.keys.toList();
    dates.sort((a, b) => b.compareTo(a));
    dates = dates.sublist(0, dates.length > 5 ? 5 : dates.length);
    //get items for each date
    Map<String, List<PayUtcItem>> out2 = {};
    for (final date in dates) {
      out2[_stringOfDateDiff(context, date)] = itemsDate[date]!;
    }
    return out2;
  }

  String _generate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  String _stringOfDateDiff(BuildContext context, DateTime key) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(key);
    if (diff.abs().inDays < 1) return Translate.of(context).today;
    if (diff.abs().inDays < 2) return Translate.of(context).yesterday;
    return "${key.day.toString().padLeft(2, '0')}/${key.month.toString().padLeft(2, '0')}/${key.year}";
  }
}
