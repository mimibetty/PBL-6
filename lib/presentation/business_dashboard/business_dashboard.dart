import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Statistics Section
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildStatCard("Pending", "\$12,800", Icons.hourglass_top, screenWidth),
                  _buildStatCard("Earnings", "\$14,200", Icons.attach_money, screenWidth),
                  _buildStatCard("Bookings", "\$8,100", Icons.book_online, screenWidth),
                  _buildStatCard("Services", "22,786", Icons.electric_bolt, screenWidth),
                ],
              ),
              const SizedBox(height: 20),

              // Graph and Recent Bookings
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildEarningGraph(),
                  ),
                  const SizedBox(width: 16),
                  // Expanded(
                  //   flex: 1,
                  //   child: _buildRecentBookings(),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, double screenWidth) {
    return SizedBox(
      width: (screenWidth < 600) ? (screenWidth / 2) - 24 : 150,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningGraph() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Earning Statistics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: "This Week",
              items: ["This Week", "This Month"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.6, // Đảm bảo tỷ lệ đồ thị phù hợp
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: [
                        FlSpot(0, 100),
                        FlSpot(1, 150),
                        FlSpot(2, 200),
                        FlSpot(3, 180),
                        FlSpot(4, 240),
                        FlSpot(5, 280),
                        FlSpot(6, 300),
                      ],
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
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

  // Widget _buildRecentBookings() {
  //   return Card(
  //     elevation: 4,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               const Text(
  //                 "Recent Bookings",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               const Spacer(),
  //               TextButton(
  //                 onPressed: () {},
  //                 child: const Text(
  //                   "View All",
  //                   style: TextStyle(color: Colors.blue),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 10),
  //           Container(
  //             height: 200, // Đảm bảo không tràn khi danh sách dài
  //             child: ListView(
  //               children: [
  //                 _buildBookingRow("#1", "New York", "\$130", "\$0", "Pending",
  //                     "04/04/2024"),
  //                 _buildBookingRow("#2", "Discover America", "\$130", "\$0",
  //                     "Confirmed", "04/04/2024"),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBookingRow(String id, String item, String total, String paid,
      String status, String created) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(id, style: const TextStyle(fontSize: 14))),
          Expanded(child: Text(item, style: const TextStyle(fontSize: 14))),
          Expanded(child: Text(total, style: const TextStyle(fontSize: 14))),
          Expanded(child: Text(paid, style: const TextStyle(fontSize: 14))),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: status == "Pending" ? Colors.yellow : Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
          Expanded(child: Text(created, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
