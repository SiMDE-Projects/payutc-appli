import 'package:payutc/src/models/payutc_history.dart';

Map<String, List<PayUtcItem>> formatDays(List<PayUtcItem> inData) {
  Map<String, List<PayUtcItem>> out = {};
  List<PayUtcItem> items = inData;
  for (final item in items) {
    String key = _generate(item.date);
    if (out[key] == null) {
      out[key] = [];
    }
    out[key]!.add(item);
  }
  Map<DateTime, List<PayUtcItem>> itemsDate =
  out.map((key, value) => MapEntry(DateTime.parse(key), value));
  return itemsDate
      .map((key, value) => MapEntry(_stringOfDateDiff(key), value));
}

String _generate(DateTime date) =>
    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

String _stringOfDateDiff(DateTime key) {
  DateTime now = DateTime.now();
  Duration diff = now.difference(key);
  if (diff.abs().inDays < 1) return "aujourd'hui";
  if (diff.abs().inDays < 2) return "Hier";
  return "Le ${key.day.toString().padLeft(2, '0')}/${key.month.toString().padLeft(2, '0')}/${key.year}";
}