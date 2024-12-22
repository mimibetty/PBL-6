import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Assuming AppColors class exists in your project
class AppColors {
  static const contentColorBlue = Colors.blue;  // Define your color
  static const contentColorCyan = Colors.cyan;  // Define your color
}

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround, // Adjust alignment (can also use spaceBetween, start, etc.)
        maxY: 20,
        groupsSpace: 3, // Adjust the space between the groups here
      ),
    );
  }

  // Bar touch configuration
  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
        BarChartGroupData group,
        int groupIndex,
        BarChartRodData rod,
        int rodIndex,
      ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: AppColors.contentColorCyan,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  // Title for the chart
  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: AppColors.contentColorBlue.withOpacity(0.8),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'D1';
        break;
      case 1:
        text = 'D2';
        break;
      case 2:
        text = 'D3';
        break;
      case 3:
        text = 'D4';
        break;
      case 4:
        text = 'D5';
        break;
      default:
        text = 'D5';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 9,
      child: Text(text, style: style),
    );
  }

  // Titles for the X and Y axes
  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  // Border configuration for the chart
  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  // Gradient for the bars
  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      AppColors.contentColorBlue.withOpacity(0.8),
      AppColors.contentColorCyan.withOpacity(0.8),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  // Bar groups (data for each bar)
  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: 8,
          gradient: _barsGradient,
          width: 20, // Adjust the width of the bar (optional)
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: 10,
          gradient: _barsGradient,
          width: 20,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: 14,
          gradient: _barsGradient,
          width: 20,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 15,
          gradient: _barsGradient,
          width: 20,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [
        BarChartRodData(
          toY: 16,
          gradient: _barsGradient,
          width: 20,
        )
      ],
      showingTooltipIndicators: [0],
    ),
  ];
}

class BarChartSample3 extends StatefulWidget {
  const BarChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1.5, // Adjust the aspect ratio as necessary
      child: _BarChart(),
    );
  }
}
