import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

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
