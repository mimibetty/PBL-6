import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  final List<int> data;  // List of values for the bars

  const BarChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        // Correct usage of barRods with `fromY` and `toY`
        BarChartRodData(
          toY: y.toDouble(),  // Fix: Use `toY` instead of `y`
          color: Colors.blue,  // Custom color
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AspectRatio(
        aspectRatio: 2,
        child: BarChart(
          BarChartData(
            barGroups: widget.data.asMap().entries.map((entry) {
              return generateGroupData(entry.key + 1, entry.value);
            }).toList(),
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchCallback: (event, response) {
                if (response != null && response.spot != null && event is FlTapUpEvent) {
                  setState(() {
                    final x = response.spot!.touchedBarGroup.x;
                    final isShowing = showingTooltip == x;
                    if (isShowing) {
                      showingTooltip = -1;
                    } else {
                      showingTooltip = x;
                    }
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
