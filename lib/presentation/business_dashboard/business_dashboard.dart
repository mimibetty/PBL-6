import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/business_dashboard/bar_chart.dart';
import 'package:travelappflutter/presentation/business_dashboard/bar_chart_2.dart';
import 'package:travelappflutter/presentation/business_dashboard/line_chart.dart';

class BusinessDashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<BusinessDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Dashboard'),
        backgroundColor: Colors.grey[100],
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(  // Wrap the body with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Welcome to VinGroup Company Dashboard \n\nAnalyze your business performance",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20.0,
                    children: <Widget>[
                      buildDashboardCard(
                        "assets/images/places.png",
                        "Total Places",
                        "69 Places",
                      ),
                      buildDashboardCard(
                        "assets/images/total_tours.png",
                        "Total Tour Packages",
                        "12 Tours",
                      ),
                      buildDashboardCard(
                        "assets/images/total_review.png",
                        "Total Reviews",
                        "96 Review",
                      ),
                      buildDashboardCard(
                        "assets/images/total_rating.png",
                        "Average Ratings",
                        "3.6",
                      ),
                    ],
                  ),
                ),
              ),
              // Add both charts inside the Column
              LineChartSample2(),
              BarChartSample3(),  
          

            ],
          ),
        ),
      ),
    );
  }

  Widget buildDashboardCard(String assetPath, String title, String subtitle) {
    return SizedBox(
      width: 160.0,
      height: 160.0,
      child: Card(
        color: Colors.grey[200],
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  assetPath,
                  width: 64.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Flexible(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
