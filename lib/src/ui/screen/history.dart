import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/models/PayUtcHistory.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/services/history.dart';
import 'package:payutc/src/ui/component/payutc_item.dart';
import 'package:payutc/src/ui/style/theme.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Map all = {}, conso = {}, transfert = {}, reload = {};

  @override
  void initState() {
    compute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          Translate.of(context).history,
          style: TextStyle(color: Colors.white),
        ),
        systemOverlayStyle: AppTheme.combineOverlay(SystemUiOverlayStyle.light),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  text: Translate.of(context).all,
                ),
                Tab(
                  text: Translate.of(context).consomation,
                ),
                Tab(
                  text: Translate.of(context).historytransferts,
                ),
                Tab(
                  text: Translate.of(context).historyReloads,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildList(all),
                  buildList(conso),
                  buildList(transfert),
                  buildList(reload),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildList(Map list) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(15),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Text(
              "${list.entries.elementAt(index).key}".toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.white70, letterSpacing: 1),
            ),
            const SizedBox(
              height: 15,
            ),
            for (final payItem in list.entries.elementAt(index).value)
              PayutcItemWidget(item: payItem),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
      itemCount: list.length,
    );
  }

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

  void compute() async {
    HistoryService service = AppService.instance.historyService;
    all = formatDays(service.history!.historique!);
    conso = formatDays(service.history!.historique!
        .where((element) => element.isPurchase)
        .toList());
    transfert = formatDays(service.history!.historique!
        .where((element) => element.isVirement)
        .toList());
    reload = formatDays(service.history!.historique!
        .where((element) => element.isReload)
        .toList());
    if (mounted) setState(() {});
  }
}
