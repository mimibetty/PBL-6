import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_2.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';
import 'package:travelappflutter/presentation/my_trip_widget/controller/trip_controller.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final ProfileController profileScreenController = Get.put(ProfileController());
  final TripController tripController = Get.put(TripController());
  final userId = Get.find<AuthController>().userId.value;

  @override
  void initState() {
    super.initState();
    // Chỉ gọi API khi cần
    //if (tripController.trips.isEmpty) {
    //}
  }

  @override
  Widget build(BuildContext context) {
    if (userId != 0) {
      tripController.getTripByUserId(userId);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trips',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        // if (tripController.isLoading.value) {
        //   return _loadingOverlay("Fetching Trip List...");
        // }
        if (tripController.trips.isEmpty) {
          return const Center(
            child: Text(
              'No Trip Yet.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 120),
          itemCount: tripController.trips.length,
          itemBuilder: (context, index) {
            final trip = tripController.trips[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      'https://i.ytimg.com/vi/Z20pEmSdig0/maxresdefault.jpg',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://i.ytimg.com/vi/Z20pEmSdig0/maxresdefault.jpg',
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.title, color: Colors.blueAccent, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  trip.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmationDialog(context, trip.id),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                            // const SizedBox(width: 8),
                            // Text(
                            //   trip.cityName ?? 'Unknown City',
                            //   style: const TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black87,
                            //   ),
                            // ),
                          ],
                        ),
                        //const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Duration: ${trip.duration} days',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Month: ${trip.monthTime}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlanScreen2()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 28.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        icon: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 24),
        label: const Text(
          'Create Trip by AI Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _loadingOverlay(String message) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int tripId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this trip?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                tripController.deleteTripByID(tripId).then((_) {
                  // Reload the trip list after deletion
                  tripController.getTripByUserId(userId);
                });
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}