import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        length: 4,
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

  List<PayUtcItem> sortQtt(Map map) {
    List<PayUtcItem> list = [];
    map.forEach((key, value) {
      //copy item [0] and add quantity
      PayUtcItem item = PayUtcItem(
        name: value[0].name,
        imageUrl: value[0].imageUrl,
        productId: value[0].productId,
        quantity: value.length,
        amount: value[0].amount,
      );
      list.add(item);
    });
    list.sort((a, b) => b.quantity.compareTo(a.quantity));
    return list;
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
                    " (${widget.item.quantity} achats)",
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
                          "${item.quantity} achats",
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          AppService.instance.translateMoney(
                              ((item.amount ?? 1) * item.quantity) / 100),
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

class DayWithBalanceAmount {
  final DateTime day;
  final num balance;
  final num reloads;
  final num virements;
  final num purchases;

  DayWithBalanceAmount(
      this.day, this.balance, this.reloads, this.virements, this.purchases);

  static List<DayWithBalanceAmount> getDaysBalanceOf(List<PayUtcItem> history) {
    history = history.toList();
    history.sort((a, b) => a.date.compareTo(b.date));
    List<DayWithBalanceAmount> days = [];
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
      days.add(DayWithBalanceAmount(
          day, amount, dayReloads, dayVirements, dayPurchases));
      //remove all item of the day
      history.removeWhere((element) => element.date.day == day.day);
    }
    return (days);
  }
}

class BarChartSample2 extends StatefulWidget {
  final List<DayWithBalanceAmount> items;

  const BarChartSample2({super.key, required this.items});

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups = [];

  @override
  void initState() {
    super.initState();
    _generate();
    // final barGroup1 = makeGroupData(0, 5, 12);
    // final barGroup2 = makeGroupData(1, 16, 12);
    // final barGroup3 = makeGroupData(2, 18, 5);
    // final barGroup4 = makeGroupData(3, 20, 16);
    // final barGroup5 = makeGroupData(4, 17, 6);
    // final barGroup6 = makeGroupData(5, 19, 1.5);
    // final barGroup7 = makeGroupData(6, 10, 1.5);
    //
    // final items = [
    //   barGroup1,
    //   barGroup2,
    //   barGroup3,
    //   barGroup4,
    //   barGroup5,
    //   barGroup6,
    //   barGroup7,
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  makeTransactionsIcon(),
                  const SizedBox(
                    width: 38,
                  ),
                  const Text(
                    'Transactions',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    'state',
                    style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              if (showingBarGroups.isNotEmpty)
                Expanded(
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.grey,
                          getTooltipItem: (a, b, c, d) {
                            return BarTooltipItem(
                              AppService.instance.translateMoney(c.toY),
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: 1,
                            getTitlesWidget: leftTitles,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                      gridData: FlGridData(show: false),
                    ),
                  ),
                ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0€';
    } else if (value == 10) {
      text = '10€';
    } else if (value == 20) {
      text = '20€';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }

  void _generate() async {
    print('generate');
    final items = <BarChartGroupData>[];
    final list = widget.items
        .where((element) => element.day
            .isAfter(widget.items.last.day.subtract(const Duration(days: 7))))
        .toList();
    print(list.length);
    for (int i = 0; i < list.length; i++) {
      final item = list[i];
      items.add(makeGroupData(i, item));
    }
    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
    print("showingBarGroups: ${showingBarGroups.length}");
    setState(() {});
  }

  BarChartGroupData makeGroupData(int x, DayWithBalanceAmount item) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: item.purchases.abs().toDouble() / 100,
          color: leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: item.reloads.abs().toDouble() / 100,
          color: rightBarColor,
          width: width,
        ),
      ],
    );
  }
}
