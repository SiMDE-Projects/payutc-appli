import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:payutc/src/api/assos_utc.dart';
import 'package:payutc/src/models/payutc_history.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/ui/component/overlay.dart';
import 'package:payutc/src/ui/component/pie.dart';
import 'package:payutc/src/ui/style/color.dart';
import 'stats_product.dart';

class StatPage extends StatefulWidget {
  const StatPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  int select = 0;
  List<PayUtcItem> history =
      AppService.instance.historyService.history?.historique ?? [];
  late Semester selectedSemester;
  List<Semester> semesters = [];

  @override
  void initState() {
    super.initState();
    semesters = AppService.instance.semesters.toList();
    semesters.removeWhere((element) {
      //remove future semesters
      if (DateTime.now().isBefore(element.beginAt)) return true;
      //remove semesters without history
      if (history.isNotEmpty &&
          !(history.any((e) => isInSemester(e.date, element)))) return true;
      return false;
    });
    selectedSemester = _findCurrentSemester(semesters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Statistiques"),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 5 + (semesters.isNotEmpty ? 1 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              padding: const EdgeInsets.all(5),
              isScrollable: true,
              indicator: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(15),
              ),
              tabs: [
                const Tab(
                  child: Text("SY02"),
                ),
                const Tab(
                  child: Text("Semaine"),
                ),
                const Tab(
                  child: Text("Mois"),
                ),
                if (semesters.isNotEmpty)
                  const Tab(
                    child: Text("Semestre"),
                  ),
                const Tab(
                  child: Text("Année"),
                ),
                const Tab(
                  child: Text("Depuis le jour 1"),
                ),
              ],
            ),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  color: AppColors.scaffoldDark,
                ),
                child: TabBarView(
                  children: [
                    _buildCrazyStats(history),
                    _buildPage(
                        history,
                        DateTime.now().subtract(const Duration(days: 7)),
                        DateTime.now(),
                        "la semaine glissante",
                        8),
                    _buildPage(
                        history,
                        DateTime(DateTime.now().year, DateTime.now().month),
                        DateTime.now(),
                        "le mois actuel",
                        12),
                    if (semesters.isNotEmpty) _buildSemesterPage(),
                    _buildPage(history, DateTime(DateTime.now().year),
                        DateTime.now(), "l'année actuelle", 20),
                    _buildPage(history, null, null, "la totale", 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterPage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Semestre",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownButtonFormField<Semester>(
          value: selectedSemester,
          iconSize: 24,
          elevation: 16,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColors.scaffold),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColors.scaffold),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: AppColors.scaffold),
            ),
            fillColor: AppColors.scaffold,
            filled: true,
            hintText: 'Choisissez un semestre',
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
          ),
          onChanged: (Semester? newValue) {
            setState(() {
              selectedSemester = newValue!;
            });
          },
          items: semesters.map<DropdownMenuItem<Semester>>((Semester value) {
            return DropdownMenuItem<Semester>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 20,
        ),
        ...buildContentPage(
          splitForPeriod(
              history, selectedSemester.beginAt, selectedSemester.endAt),
          selectedSemester.beginAt,
          selectedSemester.endAt,
          selectedSemester.name,
          20,
        )
      ],
    );
  }

  Widget _buildPage(
      List<PayUtcItem> items, DateTime? start, DateTime? end, String s,
      [int? maxTopItems]) {
    items =
        splitForPeriod(items, start ?? items.last.date, end ?? DateTime.now());
    if (items.isEmpty) {
      return Center(
        child: Text("Aucune donnée pour l'instant pour $s",
            style: const TextStyle(color: Colors.white)),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ...buildContentPage(items, start, end, s, maxTopItems),
      ],
    );
  }

  Widget _buildInfo(String title, int value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          Text(
            AppService.instance.translateMoney(value / 100),
            style: const TextStyle(color: AppColors.orange, fontSize: 15),
          ),
        ],
      ),
    );
  }

  _buildTop(List<PayUtcItem> items, DateTime? start, DateTime? end,
      [int max = 8, bool isQttMode = true]) {
    late List<PayUtcItem> toDisplay;
    toDisplay = _extractProducts(items).values.map((e) {
      return e.fold<PayUtcItem>(e.first.copyWith(quantity: 0, amount: 0),
          (previousValue, element) {
        return previousValue.copyWith(
          quantity: previousValue.quantity + element.quantity,
          amount: previousValue.amount! + element.amount!,
        );
      });
    }).toList();
    if (!isQttMode) {
      toDisplay.sort((a, b) => b.amount!.compareTo(a.amount!));
    } else {
      toDisplay.sort((a, b) => b.quantity.compareTo(a.quantity));
    }
    toDisplay =
        toDisplay.sublist(0, toDisplay.length > max ? max : toDisplay.length);
    return Column(
      children: [
        for (PayUtcItem item in toDisplay)
          Row(
            children: [
              Text(
                "#${toDisplay.indexOf(item) + 1}",
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
              Expanded(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  leading: Hero(
                    tag: item.productId!,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.imageUrl ?? "",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, a) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    item.name ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "${item.quantity.toInt()} achats",
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    AppService.instance
                        .translateMoney(((item.amount ?? 1)) / 100),
                    style: const TextStyle(color: AppColors.orange),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ProductPage(
                          item: item,
                          start: start,
                          end: end,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCrazyStats(List<PayUtcItem> history) {
    List vir = history.where((element) => element.isVirement).toList();
    List reloads = history.where((element) => element.isReload).toList();
    num reloadsAmount = reloads.fold(
        0, (previousValue, element) => previousValue + element.amount!);
    List virOut = vir.where((element) => element.isOutAmount).toList();
    num virOutAmount = virOut.fold(
        0, (previousValue, element) => previousValue + element.amount!);
    List virIn = vir.where((element) => element.isInAmount).toList();
    num virInAmount = virIn.fold(
        0, (previousValue, element) => previousValue + element.amount!);
    num totalIn = reloadsAmount + virInAmount;
    num virTotal = virOutAmount + virInAmount;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Jours avec le plus de dépenses",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const Text(
          "En moyenne par jours depuis le début",
          style: TextStyle(fontSize: 11, color: Colors.white54),
        ),
        const SizedBox(height: 5),
        _buildTopWidget(_extractTopDays(history)),
        const SizedBox(height: 20),
        const Text("Virements",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        const SizedBox(height: 5),
        Pie(
          items: [
            PieItems(AppColors.red, virOutAmount / virTotal,
                "Envoyés ${AppService.instance.translateMoney(virOutAmount / 100)}"),
            PieItems(AppColors.orange, virInAmount / virTotal,
                "Reçus ${AppService.instance.translateMoney(virInAmount / 100)}"),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Sugar daddy(s)",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const Text(
          "Personne qui t'a envoyé le plus d'argent (remboursements ,photos pieds ,etc)",
          style: TextStyle(fontSize: 11, color: Colors.white54),
        ),
        const SizedBox(height: 5),
        _buildTopWidget(_extractMostReceivedMoneyFrom(history)),
        const SizedBox(height: 20),
        const Text(
          "Je suis un sugar daddy de",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const Text(
          "Les gens que tu régales le plus ou à qui tu dois beaucoup de choses",
          style: TextStyle(fontSize: 11, color: Colors.white54),
        ),
        _buildTopWidget(_extractMostSendMoneyFrom(history)),
        const SizedBox(height: 20),
        const Text("Apports",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        const Text(
          "Avec quoi/qui tu as rechargé ton compte",
          style: TextStyle(fontSize: 11, color: Colors.white54),
        ),
        const SizedBox(height: 5),
        Pie(
          items: [
            PieItems(AppColors.red, virInAmount / totalIn,
                "Virements reçus ${AppService.instance.translateMoney(virInAmount / 100)}"),
            PieItems(AppColors.orange, reloadsAmount / totalIn,
                "Recharges ${AppService.instance.translateMoney(reloadsAmount / 100)}"),
          ],
          reverse: true,
        ),
      ],
    );
  }

  _buildTopWidget(List<PayUtcItem> list) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (list.length > 1)
                _buildScore(list[1], 110, AppColors.orange.shade900),
              if (list.isNotEmpty) _buildScore(list[0], 150, AppColors.red),
              if (list.length > 2)
                _buildScore(list[2], 80, AppColors.orange.shade500),
            ],
          ),
        ),
        if (list.length > 3)
          for (final item in list.sublist(3)) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.orange.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    AppService.instance
                        .translateMoney((item.amount ?? 0) / 100),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ]
      ],
    );
  }

  Widget _buildScore(PayUtcItem item, double height, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${item.name}",
          style: const TextStyle(color: Colors.white),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, right: 5, left: 5),
          constraints: const BoxConstraints(maxWidth: 100),
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                top: 15,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    AppService.instance
                        .translateMoney((item.amount ?? 0) / 100),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> buildContentPage(
      List<PayUtcItem> items, DateTime? start, DateTime? end, String s,
      [int? maxTopItems]) {
    GlobalKey menuOverlayKey = GlobalKey();
    bool isQuantityMode = true, showOverlay = false;
    return [
      Text("Infos ($s)",
          style: const TextStyle(fontSize: 20, color: Colors.white)),
      Text(
        "Période du ${DateFormat("dd/MM/yyyy").format(start ?? items.last.date)} au ${DateFormat("dd/MM/yyyy").format(end ?? DateTime.now())}",
        style: const TextStyle(fontSize: 11, color: Colors.white54),
      ),
      const SizedBox(height: 20),
      _buildInfo(
          "Achats",
          items.where((element) => element.isPurchase).fold(
              0,
              (previousValue, element) =>
                  previousValue + (element.amount!.abs().toInt()))),
      const SizedBox(height: 10),
      _buildInfo(
          "Virements envoyé",
          items
              .where((element) => element.isVirement && element.isOutAmount)
              .fold(
                  0,
                  (previousValue, element) =>
                      previousValue + (element.amount!.abs().toInt()))),
      const SizedBox(height: 10),
      _buildInfo(
          "Virements reçu",
          items
              .where((element) => element.isVirement && element.isInAmount)
              .fold(
                  0,
                  (previousValue, element) =>
                      previousValue + (element.amount!.abs().toInt()))),
      const SizedBox(height: 10),
      _buildInfo(
          "Recharges",
          items.where((element) => element.isReload).fold(
              0,
              (previousValue, element) =>
                  previousValue + (element.amount!.abs().toInt()))),
      const SizedBox(height: 20),
      const Text("Top des achats",
          style: TextStyle(fontSize: 20, color: Colors.white)),
      StatefulBuilder(builder: (context, snapshot) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                snapshot(() {
                  showOverlay = !showOverlay;
                });
              },
              child: Row(
                children: [
                  const Text(
                    "Trié par ",
                    style: TextStyle(fontSize: 11, color: Colors.white54),
                  ),
                  OverlayBuilder(
                    showOverlay: showOverlay,
                    overlayBuilder: (BuildContext context) {
                      RenderBox box = menuOverlayKey.currentContext
                          ?.findRenderObject() as RenderBox;
                      Offset center = box.localToGlobal(const Offset(0.0, 0.0));
                      center = center.translate(0, 15);
                      return Stack(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              snapshot(() {
                                showOverlay = false;
                              });
                            },
                            child: SizedBox.expand(
                              child: Container(),
                            ),
                          ),
                          Positioned(
                            top: center.dy,
                            left: center.dx,
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        snapshot(() {
                                          isQuantityMode = true;
                                        });
                                        snapshot(() {
                                          showOverlay = false;
                                        });
                                      },
                                      child: const SizedBox(
                                        height: 30,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Nombre d'achats"),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        snapshot(() {
                                          isQuantityMode = false;
                                        });
                                        snapshot(() {
                                          showOverlay = false;
                                        });
                                      },
                                      child: const SizedBox(
                                        height: 30,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Dépenses"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    child: Text(
                      isQuantityMode ? "nb achats" : "dépenses",
                      key: menuOverlayKey,
                      style:
                          const TextStyle(fontSize: 11, color: Colors.white54),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white54,
                    size: 15,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTop(
                items.toList(), start, end, maxTopItems ?? 8, isQuantityMode),
          ],
        );
      }),
    ];
  }

//----- logic for stats methods -----//

  List<PayUtcItem> splitForPeriod(
      List<PayUtcItem> items, DateTime start, DateTime end) {
    List<PayUtcItem> res = [];
    start = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day).add(const Duration(days: 1));
    for (PayUtcItem item in items) {
      if (item.date.isAfter(start) && item.date.isBefore(end)) {
        res.add(item);
      }
    }
    return res;
  }

  Map<num, List<PayUtcItem>> _extractProducts(List<PayUtcItem> list) {
    Map<num, List<PayUtcItem>> map = {};
    for (PayUtcItem item in list) {
      if (item.isProduct &&
          item.isOutAmount &&
          item.name != "Ecocup" &&
          (item.amount ?? 0) > 5) {
        //remove in tops "politesse" item
        if (map.containsKey(item.productId)) {
          map[item.productId!]!.add(item);
        } else {
          map[item.productId!] = [item];
        }
      }
    }
    return map;
  }

  List<PayUtcItem> _extractMostReceivedMoneyFrom(List<PayUtcItem> history) {
    Map<String, List<PayUtcItem>> map = {};
    for (PayUtcItem item in history) {
      if (item.isInAmount && item.isVirement) {
        if (map.containsKey(item.userVirName)) {
          map[item.userVirName]!.add(item);
        } else {
          map[item.userVirName] = [item];
        }
      }
    }
    List<PayUtcItem> list = [];
    map.forEach((key, value) {
      list.add(PayUtcItem(
          name: key,
          amount: value.fold(
              0,
              (previousValue, element) =>
                  (previousValue ?? 0) + (element.amount ?? 0)),
          quantity: value.length));
    });
    list.sort((a, b) => b.amount!.compareTo(a.amount!));
    return list.length > 4 ? list.sublist(0, 4) : list;
  }

  List<PayUtcItem> _extractMostSendMoneyFrom(List<PayUtcItem> history) {
    Map<String, List<PayUtcItem>> map = {};
    for (PayUtcItem item in history) {
      if (item.isOutAmount && item.isVirement) {
        if (map.containsKey(item.userVirName)) {
          map[item.userVirName]!.add(item);
        } else {
          map[item.userVirName] = [item];
        }
      }
    }
    List<PayUtcItem> list = [];
    map.forEach((key, value) {
      list.add(PayUtcItem(
          name: key,
          amount: value.fold(
              0,
              (previousValue, element) =>
                  (previousValue ?? 0) + (element.amount ?? 0)),
          quantity: value.length));
    });
    list.sort((a, b) => b.amount!.compareTo(a.amount!));
    return list.length > 4 ? list.sublist(0, 4) : list;
  }

  _extractTopDays(List<PayUtcItem> history) {
    history = history.toList();
    history.removeWhere((element) => (element.amount ?? 0) > 1500);
    Map<DateTime, PayUtcItem> map = {};
    //group history by date day/month/year
    for (PayUtcItem item in history) {
      if (item.isOutAmount && item.isProduct) {
        DateTime date =
            DateTime(item.date.year, item.date.month, item.date.day);
        if (map.containsKey(date)) {
          map[date]!.amount = map[date]!.amount! + item.amount!;
          map[date]!.quantity = map[date]!.quantity + item.quantity;
        } else {
          map[date] = PayUtcItem(
            date: date,
            amount: item.amount,
            quantity: item.quantity,
          );
        }
      }
    }
    Map<int, PayUtcItem> out = {};
    map.forEach((key, value) {
      if (out.containsKey(key.weekday)) {
        out[key.weekday]!.quantity = out[key.weekday]!.quantity + 1;
        out[key.weekday]!.amount = out[key.weekday]!.amount! + value.amount!;
      } else {
        out[key.weekday] = PayUtcItem(
          date: value.date,
          amount: value.amount,
          quantity: 1,
          name: DateFormat("EEEE", "fr_FR").format(value.date).toUpperCase(),
        );
      }
    });
    out.remove(6);
    out.remove(7);
    List<PayUtcItem> list = out.values.toList();
    for (int i = 0; i < list.length; i++) {
      list[i].amount = list[i].amount! / list[i].quantity;
    }
    list.sort((a, b) => b.amount!.compareTo(a.amount!));
    return list;
  }

  List<PayUtcItem> sortQtt(Map<num, List<PayUtcItem>> map) {
    List<PayUtcItem> list = [];
    map.forEach((key, value) {
      //copy item [0] and add quantity
      PayUtcItem item = PayUtcItem(
        name: value[0].name,
        imageUrl: value[0].imageUrl,
        productId: value[0].productId,
        quantity: value.fold(
            0, (previousValue, element) => previousValue + element.quantity),
        amount: value[0].amount! / value[0].quantity,
      );
      list.add(item);
    });
    list.sort((a, b) => b.quantity.compareTo(a.quantity));
    return list;
  }

  Semester _findCurrentSemester(List<Semester> semesters) {
    final now = DateTime.now();
    for (final semester in semesters) {
      if (semester.beginAt.isBefore(now) && semester.endAt.isAfter(now)) {
        return semester;
      }
    }
    return semesters.first;
  }

  bool isInSemester(DateTime date, Semester element) =>
      date.isAfter(element.beginAt) && date.isBefore(element.endAt);
}
