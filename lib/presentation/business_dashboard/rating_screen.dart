import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RatingBarChart extends StatelessWidget {
  final String chartTitle;
  final List<List<double>> chartData; // Multi-level list: 5 rating categories, 12 months

  RatingBarChart({
    required this.chartTitle,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart Title
          Padding(
            padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
            child: Text(
              chartTitle,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _calculateMaxY(chartData),
                minY: 0.0,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                        ];
                        // Mapping chartData correctly to month index
                        return Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            months[value.toInt()],
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 2,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                barGroups: _generateBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to generate bar groups based on `chartData`
  List<BarChartGroupData> _generateBarGroups() {
    return List.generate(12, (index) {
      final List<BarChartRodData> rods = [];
      for (int i = 0; i < chartData.length; i++) {
        rods.add(BarChartRodData(
          toY: chartData[i][index], // Use the multi-level list for data
          width: 16.0,
          gradient: LinearGradient(
            colors: [Colors.blue[800]!, Colors.blue[900]!],
          ),
          borderRadius: BorderRadius.zero, // Makes the top of the bars square
        ));
      }

      return BarChartGroupData(
        x: index, // Ensures x corresponds to the correct month (0-11)
        barRods: rods,
        barsSpace: -15.0, // Adjusted space between bars for better visibility
      );
    });
  }

  // Calculate maxY value based on the sum of ratings in each month
  double _calculateMaxY(List<List<double>> chartData) {
    double max = 0.0;
    for (var i = 0; i < 12; i++) { // Loop through all 12 months (from Jan (0) to Dec (11))
      double monthTotal = chartData.fold(0.0, (sum, list) => sum + list[i]);
      if (monthTotal > max) {
        max = monthTotal;
      }
    }
    return max + 1.0; // Add padding for better visualization
  }
}
