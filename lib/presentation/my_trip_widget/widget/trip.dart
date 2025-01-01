import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/my_trip_widget/controller/trip_controller.dart';
import 'package:travelappflutter/presentation/create_AI_trip/model/trip_model.dart';
import 'package:travelappflutter/presentation/my_trip_widget/widget/itinerary_view_trip.dart';
import 'package:travelappflutter/presentation/my_trip_widget/widget/my_trips_widget.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  _MyTripsScreenState createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final TripController tripController = Get.put(TripController());
  final userId = Get.find<AuthController>().userId.value;
  String _sortOption = 'Duration'; // Default sort option

  @override
  void initState() {
    super.initState();
    // Fetch trips on initialization
    if (userId != 0) {
      Future.microtask(() => tripController.getTripByUserId(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Trips"),
        backgroundColor: Colors.grey[200],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (tripController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tripController.filteredTrips.isEmpty) {
          return const Center(
            child: Text(
              'No trips found matching the selected filter.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Plan your trips with ease',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        tripController.filterTrips('All');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        backgroundColor: const Color.fromARGB(255, 240, 11, 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'See All',
                        style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          tripController.filterTrips('With Itinerary');
                        },
                        icon: const Icon(Icons.map, size: 18),
                        label: const Text('With Itinerary'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          tripController.filterTrips('Without Itinerary');
                        },
                        icon: const Icon(Icons.auto_mode, size: 18),
                        label: const Text('Without Itinerary'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Sort: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: _sortOption,
                      items: const [
                        DropdownMenuItem(
                          value: 'Duration',
                          child: Text('Duration'),
                        ),
                        DropdownMenuItem(
                          value: 'MonthTime',
                          child: Text('MonthTime'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortOption = value ?? 'Duration';
                        });
                        tripController.sortTrips(_sortOption); // Call the sortTrips method
                        print("Selected sort: $_sortOption");
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: tripController.filteredTrips.length,
                  itemBuilder: (context, index) {
                    return _TripCard(
                      trip: tripController.filteredTrips[index],
                      onDelete: () => _showDeleteConfirmationDialog(
                          context, tripController.filteredTrips[index].id),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
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
                _deleteTrip(tripId);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteTrip(int tripId) {
    tripController.deleteTripByID(tripId).then((_) {
      // Ensure UI is updated only after the operation
      Future.microtask(() => tripController.getTripByUserId(userId));
    });
  }
}


class _TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onDelete;

  const _TripCard({required this.trip, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final tripController = Get.find<TripController>();
    //planScreencontroller.
    return GestureDetector(
      onTap: () async {
        if (trip.isAI) {
          try {
            print("go fetch trip for ID : " + trip.id.toString());

            // Fetch trip details và luôn đảm bảo dữ liệu mới nhất
            final jsonResponse = await tripController.fetchDestinationByTripID(trip.id);

            // Validate jsonResponse format
            if (jsonResponse['daily_schedule'] == null || jsonResponse['hotels'] == null) {
              throw Exception("Invalid JSON response format");
            }

            // Truyền lại dữ liệu mới nhất sang màn hình chi tiết
            await Get.to(() => ItineraryViewTrip(
                  tripName: tripController.tripDetail.value?.name ?? 'Unknown Trip',
                  userId: trip.userId,
                  jsonResponse: jsonResponse,
                  hotelList: tripController.hotelList.toList(),
                  restaurantList: tripController.restaurantList.toList(),
                  thingsToDoList: tripController.thingsToDoList.toList(),
                ));
          } catch (e) {
            // Print error to debug console
            print('Error: $e');

            // Display a snackbar with error details
            Get.snackbar(
              'Error',
              e.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          print("go fetch trip no AI for ID : " + trip.id.toString());

          // Fetch trip details và luôn đảm bảo dữ liệu mới nhất
          await tripController.fetchDestinationByTripID(trip.id);

          // Điều hướng đến MyTripsWidget cho trip không có itinerary
          print("This trip is not AI-generated. Navigating to MyTripsWidget.");
          await Get.to(() => MyTripsWidget(
                tripName: tripController.tripDetail.value?.name ?? 'Unknown Trip',
                thingsToDo: tripController.thingsToDoList.toList(),
                restaurants: tripController.restaurantList.toList(),
                placesToStay: tripController.hotelList.toList(),
              ));
          }
        },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  trip.imageUrl ?? 'https://i.ytimg.com/vi/Z20pEmSdig0/maxresdefault.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          trip.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        '${trip.duration} days',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timelapse_outlined, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        trip.monthTime,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
