import 'package:flutter/material.dart';
import 'package:payut/src/models/PayUtHistory.dart';

import '../../services/app.dart';
import '../style/color.dart';

class PayutItemWidget extends StatelessWidget {
  final PayUtItem item;

  const PayutItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _paymentCard(context, item);
  }

  Widget _paymentCard(BuildContext context, PayUtItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          showModalBottomSheet(
              backgroundColor: Colors.black,
              barrierColor: Colors.white30,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))
              ),
              builder: (_) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Details",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          _row("Montant", item.amountParse.toStringAsFixed(2)),
                          _row("Dénomination", item.nameExtracted(context)),
                          SizedBox(
                            height: 10,
                          ),
                          if (item.isVirement) ...[
                            Text(
                              "Message",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(15)),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              child: Text(
                                "${item.name}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ));
        },
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(15)),
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
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "${item.nameExtracted(context)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        softWrap: false,
                      ),
                    ),
                    Text(
                      "${item.service(context)}",
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
            "$s",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "$t",
            style: TextStyle(color: Colors.white),
          ),
        ],
      );
}
