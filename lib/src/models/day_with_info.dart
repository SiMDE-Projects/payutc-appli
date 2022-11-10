import 'package:payutc/src/models/payutc_history.dart';

class DayWithBalanceInfos {
  final DateTime day;
  final num balance;
  final num reloads;
  final num virements;
  final num purchases;

  DayWithBalanceInfos(
      this.day, this.balance, this.reloads, this.virements, this.purchases);

  static List<DayWithBalanceInfos> getDaysBalanceOf(List<PayUtcItem> history) {
    history = history.toList();
    history.sort((a, b) => a.date.compareTo(b.date));
    List<DayWithBalanceInfos> days = [];
    num amount = 0;
    for (int i = 0; history.isNotEmpty; i++) {
      final item = history.first;
      DateTime day = DateTime(item.date.year, item.date.month, item.date.day);
      //get all item of the day
      List<PayUtcItem> itemsOfDay =
          history.where((element) => element.date.day == day.day).toList();
      num dayReloads = 0;
      num dayVirements = 0;
      num dayPurchases = 0;
      num dayAmount = itemsOfDay.fold(0, (previousValue, element) {
        num a = (element.amount ?? 0).abs();
        if (element.isOutAmount) a = -a;
        if (element.isReload) dayReloads += a;
        if (element.isVirement) dayVirements += a;
        if (element.isPurchase) dayPurchases += a;
        return previousValue + a;
      });
      amount += dayAmount;
      //add res to days
      days.add(DayWithBalanceInfos(
          day, amount, dayReloads, dayVirements, dayPurchases));
      //remove all item of the day
      history.removeWhere((element) => element.date.day == day.day);
    }
    return (days);
  }
}
