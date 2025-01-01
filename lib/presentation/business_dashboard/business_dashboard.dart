import 'package:flutter/material.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/business_creation_screen/controller/business_controller.dart';
import 'package:travelappflutter/presentation/business_dashboard/rating_screen.dart';

class BusinessDashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<BusinessDashboard> {
  final BusinessController businessController =
      Get.put(BusinessController()); // Initialize controller

  var selectedDestinationIndex = 0; // Track selected destination

  @override
  void initState() {
    super.initState();
    businessController.fetchTotalReviews();
    businessController.fetchTop5Ids().then((_) {
      businessController.fetchTopDestinationDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
        backgroundColor: Colors.grey[100],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (businessController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final totalReviews = businessController.totalReview.value;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    child: const Text(
                      "Welcome to our Company Dashboard \n\nAnalyze your business performance",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 30.0,
                        runSpacing: 20.0,
                        children: <Widget>[
                          buildDashboardCard(
                            "assets/images/places.png",
                            "Total Places",
                            "${businessController.businessMetrics.value?.totalPlaces ?? 0} Places",
                          ),
                          buildDashboardCard(
                            "assets/images/total_tours.png",
                            "Total Tour Packages",
                            "${businessController.businessMetrics.value?.totalTours ?? 0} Tours",
                          ),
                          buildDashboardCard(
                            "assets/images/total_review.png",
                            "Total Reviews",
                            "$totalReviews Reviews",
                          ),
                          buildDashboardCard(
                            "assets/images/total_rating.png",
                            "Average Ratings",
                            "${businessController.businessMetrics.value?.averageRatings.toStringAsFixed(1) ?? "0.0"}",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Obx(() {
                      if (businessController.simpleDestinations.isEmpty) {
                        return const Center(
                          child: Text('No chart data available.'),
                        );
                      }

                      // Get the selected destination
                      final selectedDestination = businessController
                          .simpleDestinations[selectedDestinationIndex];

                 
                      if (selectedDestination.chartData == null ||
                          selectedDestination.chartData!.isEmpty) {
                        return const Center(
                          child: Text(
                              'No chart data available for this destination.'),
                        );
                      }

                      // Convert chartData into List<List<double>> for stacked chart
                      List<List<double>> stackedChartData = List.generate(
                        5, // Assuming 1-star to 5-star ratings
                        (starIndex) => List.generate(
                          12, // 12 months
                          (monthIndex) =>
                              selectedDestination.chartData![starIndex]
                                  [monthIndex] ??
                              0.0,
                        ),
                      );

                      return Container(
                        alignment: Alignment.center,
                        height: 400,
                        child: RatingBarChart(
                          chartTitle: selectedDestination.name,
                          chartData: stackedChartData, // Pass stacked data
                        ),
                      );
                    }),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      "Top 5 Destinations",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _buildTopDestinationsTable(),
                  ),
                ],
              ),
            );
          }
        }),
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
                  width: 50.0,
                ),
                const SizedBox(height: 10.0),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w200,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopDestinationsTable() {
    return Obx(() {
      if (businessController.simpleDestinations.isEmpty) {
        return const Center(
          child: Text('No destinations available.'),
        );
      }

      return ListView.builder(
        itemCount: businessController.simpleDestinations.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final destination = businessController.simpleDestinations[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDestinationIndex = index; // Update selected index
              });
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    // Display image if available
                    destination.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              destination.imageUrl ??
                                  '', // Ensure imageUrl is not null
                              width: 80.0, // Set width for the image
                              height: 80.0, // Set height for the image
                              fit: BoxFit
                                  .cover, // Make sure image fits within box
                            ),
                          )
                        : Container(
                            width: 80.0,
                            height: 80.0), // Empty container if no image
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            destination.address,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Rating: ${destination.averageRating.toStringAsFixed(1)} ★',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      '#${index + 1}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
