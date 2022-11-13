import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payutc/generated/l10n.dart';
import 'package:payutc/src/ui/style/color.dart';

class SelectAmount extends StatefulWidget {
  final void Function(BuildContext context, double amount) onAmountSelected;
  final bool Function(double amount)? validator;

  final String motif;

  const SelectAmount(
      {Key? key,
      required this.onAmountSelected,
      required this.motif,
      this.validator})
      : super(key: key);

  @override
  State<SelectAmount> createState() => _SelectAmountState();
}

class _SelectAmountState extends State<SelectAmount> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.motif,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            height: 150,
            child: AnimatedBuilder(
                animation: controller,
                builder: (context, snapshot) {
                  return Center(
                      child: Text(
                    "${controller.text} €",
                    style: const TextStyle(fontSize: 35),
                  ));
                }),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(34),
                ),
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: Center(child: _pad(controller))),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: ValidationBtnColor()),
                    onPressed: _validatePress(),
                    child: Text(Translate.of(context).validate),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _pad(TextEditingController controller) {
    return LayoutBuilder(builder: (context, snapshot) {
      double maxExtent = min(snapshot.maxHeight / 4, 90);
      return GridView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: maxExtent,
        ),
        children: [
          for (int i = 1; i < 10; i++)
            Center(
              child: SizedBox.square(
                dimension: maxExtent - 20,
                child: Material(
                  color: Colors.white24,
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    onTap: () => _padInteract(i),
                    child: SizedBox.expand(
                      child: Center(
                        child: Text(
                          "$i",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Center(
            child: SizedBox.square(
              dimension: maxExtent - 20,
              child: Material(
                color: Colors.white24,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: () => _padInteract(-2),
                  child: const SizedBox.expand(
                    child: Center(
                      child: Text(
                        ".",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox.square(
              dimension: maxExtent - 20,
              child: Material(
                color: Colors.white24,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: () => _padInteract(0),
                  child: const SizedBox.expand(
                    child: Center(
                      child: Text(
                        "0",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox.square(
              dimension: maxExtent - 20,
              child: Material(
                color: Colors.white24,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  onTap: () => _padInteract(-1),
                  child: const SizedBox.expand(
                    child: Center(
                      child: Icon(
                        Icons.backspace,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  _padInteract(int num) {
    if (num == -1) {
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
      }
    } else if (num == -2) {
      if (controller.text.length < 3) {
        controller.text = "${controller.text}.".padLeft(3, '0');
      }
      if (!controller.text.contains(".") && controller.text.length < 3) {
        controller.text += ".";
      }
    } else {
      if (controller.text.length == 5) {
        return;
      }
      if (controller.text.length == 2 && !controller.text.contains(".")) {
        controller.text += '.';
      }
      controller.text += num.toString();
    }
  }

  _validatePress() {
    bool res = true;
    if (widget.validator != null) {
      res = widget.validator!(double.tryParse(controller.text) ?? 0);
    } else {
      res = controller.text.isNotEmpty;
    }
    return res ? onPress : null;
  }

  void onPress() {
    widget.onAmountSelected(context, double.parse(controller.text));
  }
}

class ValidationBtnColor extends MaterialStateColor {
  ValidationBtnColor() : super(0);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return Colors.white30;
    }
    return AppColors.orange;
  }
}
