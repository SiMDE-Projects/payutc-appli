import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:skeletons/skeletons.dart';

import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/services/history.dart';
import 'package:payutc/src/services/unilinks.dart';
import 'package:payutc/src/ui/component/payutc_item.dart';
import 'package:payutc/src/ui/screen/history.dart';
import 'package:payutc/src/ui/screen/reload.dart';
import 'package:payutc/src/ui/screen/stats.dart';
import 'package:payutc/src/ui/screen/transfert_select_amount.dart';
import 'package:payutc/src/ui/style/color.dart';
import 'package:payutc/src/ui/style/theme.dart';
import '../component/rounded_icon.dart';
import 'account_screen.dart';
import 'receive.dart';
import 'search_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int offset = 230;
  late AnimationController mainController;
  late Animation<double> controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    mainController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    mainController.value = 1;
    controller = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: mainController, curve: Curves.easeInOut));
    historyController.loadHistory(silent: false, forced: true);
    UniLinks.handleLink(context);
    super.initState();
  }

  HistoryController historyController =
      HistoryController(AppService.instance.historyService);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (mainController.value == 0) {
          _closeSheet();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AnimatedBuilder(
                    animation: mainController,
                    builder: (context, snapshot) {
                      return Theme(
                        data: AppTheme.current.copyWith(
                          appBarTheme: AppBarTheme(
                            systemOverlayStyle: AppTheme.combineOverlay(
                              mainController.value == 1
                                  ? SystemUiOverlayStyle.dark
                                  : SystemUiOverlayStyle.light,
                            ),
                          ),
                        ),
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          actions: [
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (builder) => const AccountPage(),
                                ),
                              ).then((value) => setState(() {})),
                              icon: const Icon(
                                Icons.account_circle,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                          leading: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () async {
                              historyController.loadHistory(forced: true);
                              try {
                                await AppService.instance.refreshContent();
                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentMaterialBanner();
                                }
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(Translate.of(context)
                                        .refreshContentError),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        Translate.of(context).myPayutc,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AnimatedBuilder(
                        animation: historyController,
                        builder: (context, snapshot) {
                          return Skeleton(
                            isLoading: historyController.loading,
                            skeleton: SkeletonLine(
                              style: SkeletonLineStyle(
                                width: 100,
                                height: 35,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  AppService.instance.translateMoney(
                                      (historyController.history?.credit ??
                                              00) /
                                          100),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                    color: AppColors.orange,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                if (AppService.instance.userWallet!.blocked)
                                  Text(" ${Translate.of(context).card_blocked}")
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 125,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCard(
                        Translate.of(context).reload,
                        const Icon(
                          Icons.add,
                          size: 30,
                        ),
                        () async {
                          bool res = await PaymentFlowPage.paymentFlow(context);
                          if (res) {
                            historyController.loadHistory(forced: true);
                            await AppService.instance
                                .refreshContent()
                                .then((value) {
                              ScaffoldMessenger.of(context).showMaterialBanner(
                                MaterialBanner(
                                  leading: const Icon(
                                    Icons.campaign,
                                    color: AppColors.orange,
                                  ),
                                  content: const Text(
                                      "L'apparition de la recharge peut prendre 1-2 minutes"),
                                  actions: [
                                    IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentMaterialBanner();
                                      },
                                      icon: const Icon(Icons.close),
                                      color: AppColors.orange,
                                    )
                                  ],
                                ),
                              );
                              if (mounted) setState(() {});
                            });
                          }
                        },
                      ),
                      _buildCard(
                          Translate.of(context).send,
                          const Icon(
                            CupertinoIcons.arrow_up_right_circle_fill,
                            size: 30,
                          ),
                          _sendMoneyPage),
                      _buildCard(
                        Translate.of(context).receive,
                        const Icon(CupertinoIcons.arrow_down_left_circle_fill,
                            size: 30),
                        _receivePage,
                      ),
                      _buildCard(
                        Translate.of(context).statistics,
                        const Icon(Icons.stacked_line_chart, size: 30),
                        _statPage,
                      ),
                      _buildCard(
                        Translate.of(context).history,
                        const Icon(Icons.history, size: 30),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => const HistoryPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 65,
                ),
              ],
            ),
            AnimatedBuilder(
                animation: mainController,
                builder: (context, snapshot) {
                  return Transform.translate(
                    offset: Offset(0, 360 * controller.value),
                    child: _bottomSheet(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String text, Icon icon, GestureTapCallback onTap) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 85,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3f000000),
              blurRadius: 55,
              spreadRadius: -20,
              offset: Offset(0, 13),
            ),
          ],
          color: Colors.white,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: RoundedIcon(
                      icon: icon,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          text,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  _bottomSheet() => GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            _closeSheet();
          } else if (details.delta.dy < -sensitivity) {
            if (historyController.loading) return;
            mainController.reverse();
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30 * controller.value),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 15,
                )
              ]),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 20 * (1 - controller.value),
              ),
              SizedBox(
                height: 45,
                child: Row(
                  children: [
                    Text(
                      Translate.of(context).activity,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: controller.value != 0
                          ? const SizedBox()
                          : IconButton(
                              key: const ValueKey(123456),
                              onPressed: _closeSheet,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (_) {
                    if (_.metrics.pixels < -120) {
                      _closeSheet();
                      return false;
                    }
                    return true;
                  },
                  child: AnimatedBuilder(
                    animation: historyController,
                    builder: (context, snapshot) {
                      return Skeleton(
                        isLoading: historyController.loading,
                        skeleton: SkeletonListView(
                          item: skeletonItem(),
                        ),
                        child: ListView(
                          controller: _scrollController,
                          physics: controller.value == 1
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          children: [
                            for (final item in historyController
                                .parsedItems(context)
                                .entries) ...[
                              Text(
                                item.key.toUpperCase(),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    color: Colors.white70, letterSpacing: 1),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              for (final payItem in item.value)
                                PayUtcItemWidget(item: payItem),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.black),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            const HistoryPage()));
                              },
                              child: Text(
                                Translate.of(context).see_history_sentence,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void _closeSheet() {
    if (historyController.loading) return;
    mainController.forward();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  Widget skeletonItem() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: 60,
                  height: 60,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    Row(
                      children: [
                        SkeletonLine(
                          style: SkeletonLineStyle(
                              borderRadius: BorderRadius.circular(15),
                              width: 100),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      );

  void _sendMoneyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => SelectUserPage(
          callBack: (c, user) async {
            bool? res = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (builder) => SelectTransfertAmountScreen(target: user),
              ),
            );
            if (res == true) {
              historyController.loadHistory(forced: true);
            }
            if ((res ?? false) && mounted) Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _statPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const StatPage(),
      ),
    );
  }

  void _receivePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const ReceivePage(),
      ),
    );
  }
}
