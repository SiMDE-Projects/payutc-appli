import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:payutc/src/models/payutc_history.dart';
import '../../services/app.dart';
import '../style/color.dart';

class PayUtcItemWidget extends StatelessWidget {
  final PayUtcItem item;

  const PayUtcItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _paymentCard(context, item);
  }

  Widget _paymentCard(BuildContext context, PayUtcItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _showModal(context),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.8), BlendMode.dstATop),
                    image: NetworkImage(item.imageUrl ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Icon(
                  item.isInAmount
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 40,
                  color: Colors.white70,
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
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.nameExtracted(context),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        softWrap: false,
                      ),
                    ),
                    Text(
                      item.service(context),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                  "${item.isInAmount ? "" : "-"}${AppService.instance.translateMoney(item.amountParse)}",
                  style: TextStyle(
                      color: item.isInAmount ? Colors.white : AppColors.red,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _row(String s, String t) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            s,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                t,
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      );

  void _showModal(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.black,
        barrierColor: Colors.white30,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (_) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Details",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _row("Montant", item.amountParse.toStringAsFixed(2)),
                    _row("Dénomination", item.nameExtracted(context)),
                    if (!item.isVirement)
                      _row("Service", item.service(context)),
                    _row("Date", DateFormat("dd/MM/yyyy").format(item.date)),
                    _row("Heure", DateFormat("HH:mm").format(item.date)),
                    const SizedBox(
                      height: 10,
                    ),
                    if (item.isVirement) ...[
                      Text(
                        "${item.userVirName} a écrit :",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Text(
                          "${item.name}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ));
  }
}
