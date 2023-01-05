import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:payutc/src/models/payutc_history.dart';
import 'package:payutc/src/services/app.dart';
import 'package:payutc/src/services/utils.dart';
import 'package:payutc/src/ui/style/color.dart';
import 'package:payutc/src/ui/style/theme.dart';

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
          .where((PayUtcItem element) =>
              element.productId == widget.item.productId &&
              element.date.isAfter(widget.start!) &&
              element.date.isBefore(widget.end!) &&
              element.isOutAmount)
          .toList();
    } else {
      items = (AppService.instance.historyService.history?.historique ?? [])
          .where((element) =>
              element.productId == widget.item.productId && element.isOutAmount)
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
        backgroundColor: AppColors.scaffoldDark,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.scaffoldDark,
              expandedHeight: MediaQuery.of(context).size.width * 0.8,
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
              backgroundColor: AppColors.scaffoldDark,
              titleSpacing: 10,
              titleTextStyle: const TextStyle(color: Colors.white),
              leading: const SizedBox(),
              leadingWidth: 0,
              elevation: 20,
              shadowColor: Colors.black,
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
                    "Total : ${AppService.instance.translateMoney(((widget.item.amount ?? 1)) / 100)}",
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
