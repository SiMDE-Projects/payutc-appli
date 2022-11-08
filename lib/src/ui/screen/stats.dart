import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:payutc/src/models/payutc_history.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/services/utils.dart';
import 'package:payutc/src/ui/style/color.dart';
import 'package:payutc/src/ui/style/theme.dart';

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

  @override
  void initState() {
    super.initState();
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
        length: 5,
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
              tabs: const [
                Tab(
                  child: Text("Semaine"),
                ),
                Tab(
                  child: Text("Mois"),
                ),
                Tab(
                  child: Text("Année"),
                ),
                Tab(
                  child: Text("Depuis le jour 1"),
                ),
                Tab(
                  child: Text("SY02"),
                ),
              ],
            ),
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    color: Colors.black),
                child: TabBarView(
                  children: [
                    _buildPage(
                        history,
                        DateTime.now().subtract(const Duration(days: 7)),
                        DateTime.now(),
                        "la semaine glissante"),
                    _buildPage(
                        history,
                        DateTime(DateTime.now().year, DateTime.now().month),
                        DateTime.now(),
                        "le mois actuel"),
                    _buildPage(history, DateTime(DateTime.now().year),
                        DateTime.now(), "l'année actuelle"),
                    _buildPage(history, null, null, "la totale"),
                    _buildCrazyStats(history),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PayUtcItem> splitForPeriod(
      List<PayUtcItem> items, DateTime start, DateTime end) {
    List<PayUtcItem> res = [];
    start = DateTime(start.year, start.month, start.day);
    end = DateTime(end.year, end.month, end.day);
    for (PayUtcItem item in items) {
      if (item.date.isAfter(start) && item.date.isBefore(end)) {
        res.add(item);
      }
    }
    return res;
  }

  Widget _buildPage(
      List<PayUtcItem> items, DateTime? start, DateTime? end, String s) {
    items = splitForPeriod(items, start ?? DateTime(0), end ?? DateTime.now());
    if (items.isEmpty) {
      return Center(
        child: Text("Aucune donnée pour l'instant pour $s",
            style: const TextStyle(color: Colors.white)),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text("Infos ($s)",
            style: const TextStyle(fontSize: 20, color: Colors.white)),
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
        const SizedBox(height: 20),
        _buildTop(items.toList(), start, end),
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

  _buildTop(List<PayUtcItem> items, DateTime? start, DateTime? end) {
    List toDisplay = sortQtt(_extractProducts(items));
    toDisplay =
        toDisplay.sublist(0, toDisplay.length > 8 ? 8 : toDisplay.length);
    return Column(
      children: [
        for (PayUtcItem item in toDisplay)
          ListTile(
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
              "${item.quantity} achats",
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Text(
              AppService.instance
                  .translateMoney(((item.amount ?? 1) * item.quantity) / 100),
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
      ],
    );
  }

  _extractProducts(List<PayUtcItem> list) {
    Map<num, List<PayUtcItem>> map = {};
    for (PayUtcItem item in list) {
      if (item.isProduct && item.isOutAmount && item.name != "Ecocup") {
        if (map.containsKey(item.productId)) {
          map[item.productId!]!.add(item);
        } else {
          map[item.productId!] = [item];
        }
      }
    }
    return map;
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
        const SizedBox(height: 20),
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
        const Text("Sugar daddy(s)",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        _buildTopWidget(_extractMostReceivedMoneyFrom(history)),
        const SizedBox(height: 20),
        const Text("Je suis un sugar daddy de",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        _buildTopWidget(_extractMostSendMoneyFrom(history)),
        const SizedBox(height: 20),
        const Text("Apports",
            style: TextStyle(fontSize: 20, color: Colors.white)),
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
  _extractTopDays(List<PayUtcItem> history){
    Map<int, PayUtcItem> map = {};
    for (PayUtcItem item in history) {
      if (item.isOutAmount && item.isProduct && (item.amount ?? 1500) < 1500) {
        if (map.containsKey(item.date.weekday)) {
          map[item.date.weekday]!.amount =
              (map[item.date.weekday]!.amount ?? 0) + (item.amount ?? 0);
          map[item.date.weekday]!.quantity =
              map[item.date.weekday]!.quantity + 1;
        } else {
          map[item.date.weekday] = PayUtcItem(
              amount: item.amount,
              name: DateFormat("EEEE", "fr_FR").format(item.date).toUpperCase(),
              quantity: 1);
        }
      }
    }
    List<PayUtcItem> list = map.values.toList();
    list.sort((a, b) => b.amount!.compareTo(a.amount!));
    return list;
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

  List<PayUtcItem> _extractMostReceivedMoneyFrom(List<PayUtcItem> history) {
    Map<String,List<PayUtcItem>> map = {};
    for (PayUtcItem item in history) {
      if (item.isInAmount && item.isVirement){
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
          amount: value.fold(0, (previousValue, element) => (previousValue??0) + (element.amount ?? 0)),
          quantity: value.length));
    });
    list.sort((a, b) => b.amount!.compareTo(a.amount!));
    return list.length> 4 ? list.sublist(0, 4) : list;
  }
  List<PayUtcItem> _extractMostSendMoneyFrom(List<PayUtcItem> history) {
    Map<String,List<PayUtcItem>> map = {};
    for (PayUtcItem item in history) {
      if (item.isOutAmount && item.isVirement){
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
          amount: value.fold(0, (previousValue, element) => (previousValue??0) + (element.amount ?? 0)),
          quantity: value.length));
    });
    list.sort((a, b) => b.amount!.compareTo(a.amount!));
    return list.length> 4 ? list.sublist(0, 4) : list;
  }
}

class PieItems {
  final Color color;
  final double value;
  final String label;

  PieItems(this.color, this.value, this.label);
}

class Pie extends StatefulWidget {
  final List<PieItems> items;
  final bool reverse;

  const Pie({super.key, required this.items, this.reverse = false});

  @override
  State<Pie> createState() => _PieState();
}

class _PieState extends State<Pie> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final widgets = [
      Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 50,
              sections: showingSections(),
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 20,
      ),
      Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: _buildLegend(),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: widget.reverse ? widgets.reversed.toList() : widgets,
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return widget.items
        .map(
          (e) => PieChartSectionData(
            color: e.color,
            value: e.value,
            title: e.label,
            showTitle: false,
            badgePositionPercentageOffset: 0.98,
            badgeWidget: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text(
                "${(e.value * 100).toInt()}%",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
        .toList();
  }

  _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (PieItems item in widget.items.toList()
          ..sort((a, b) => b.value.compareTo(a.value))) ...[
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(color: Colors.white),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class ProductPage extends StatefulWidget {
  final PayUtcItem item;
  final DateTime? start, end;

  const ProductPage({
    Key? key,
    required this.item,
    this.start,
    this.end,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Map<String, List<PayUtcItem>> items = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    List<PayUtcItem> items = [];
    if (widget.start != null && widget.end != null) {
      items = (AppService.instance.historyService.history?.historique ?? [])
          .where((element) =>
              element.productId == widget.item.productId &&
              element.date.isAfter(widget.start!) &&
              element.date.isBefore(widget.end!))
          .toList();
    } else {
      items = (AppService.instance.historyService.history?.historique ?? [])
          .where((element) => element.productId == widget.item.productId)
          .toList();
    }
    this.items = formatDays(items);
    bool canPop = true;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < -150 && canPop) {
        canPop = false;
        Navigator.pop(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.current.copyWith(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: AppTheme.combineOverlay(
            SystemUiOverlayStyle.light,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              pinned: true,
              backgroundColor: Colors.black,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.item.productId!,
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.network(
                      widget.item.imageUrl ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, a) => Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  widget.item.name ?? "",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.black,
              titleSpacing: 10,
              titleTextStyle: const TextStyle(color: Colors.white),
              leading: const SizedBox(),
              leadingWidth: 0,
              elevation: 20,
              shadowColor: Colors.white12,
              title: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    widget.item.name ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    " (${widget.item.quantity.toInt()} achats)",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  Text(
                    "Total : ${AppService.instance.translateMoney(((widget.item.amount ?? 1) * widget.item.quantity) / 100)}",
                    style: const TextStyle(color: AppColors.orange),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                    endIndent: 10,
                    indent: 10,
                  ),
                  for (final row in items.entries) ...[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        row.key,
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    for (final item in row.value)
                      ListTile(
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
                      ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
