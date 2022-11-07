import 'package:flutter/material.dart';

class StatPage extends StatefulWidget {
  const StatPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  int select = 0;

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
                  child: Text("Infos pratiques"),
                ),
                Tab(
                  child: Text("Consomation"),
                ),
                Tab(
                  child: Text("Virement"),
                ),
                Tab(
                  child: Text("Recharge"),
                ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    color: Colors.black),
                child: TabBarView(
                  children: [
                    for (int i = 0; i < 4; i++)
                      ListView(
                        children: const [],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
