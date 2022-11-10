import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/services/history.dart';
import 'package:payutc/src/services/utils.dart';
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
    //maybe for the future in case of a lot of history -> Use compute() in **Isolate** and a loading screen
    compute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          Translate.of(context).history,
          style: const TextStyle(color: Colors.white),
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
            const SizedBox(
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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(15),
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
              PayUtcItemWidget(item: payItem),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
      itemCount: list.length,
    );
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
