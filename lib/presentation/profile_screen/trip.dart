import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/profile_screen/my_trips_widget.dart';

import '../../core/app_export.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  _MyTripsScreenState createState() => _MyTripsScreenState();
}

List<TravelDestination> _getThingsToDoDestinations(
    List<TravelDestination> destinations) {
  return destinations
      .where((dest) => dest.hotelId == null && dest.restaurantId == null)
      .toList();
}

List<int> _getHotelIDs(List<TravelDestination> destinations) {
  return destinations
      .where((dest) => dest.hotelId != null)
      .map((dest) => dest.hotelId!)
      .toList();
}

List<int> _getRestaurantIDs(List<TravelDestination> destinations) {
  return destinations
      .where((dest) => dest.restaurantId != null)
      .map((dest) => dest.restaurantId!)
      .toList();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final HomeController homeController =
      Get.put(HomeController()); // Initialize here
  String _sortOption = 'Edit Recently'; // Default sort option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Trips"),
        backgroundColor: Colors.grey[100], // Set AppBar color to grey
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customize your trips with us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Create trip buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle creating a new trip
                      print("Create a New Trip clicked");
                    },
                    child: const Text('Create a New Trip'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle creating a trip with AI
                      print("Create Trip with AI clicked");
                    },
                    child: const Text('Create Trip with AI'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Sort options
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Sort: ',
                  style: TextStyle(fontSize: 16),
                ),
                PopupMenuButton<String>(
                  initialValue: _sortOption,
                  onSelected: (value) {
                    setState(() {
                      _sortOption = value;
                    });
                    // Handle sort action (e.g., by recently edited or created)
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Edit Recently', 'Edit Created'}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // List of trips
            Expanded(
              child: ListView.builder(
                itemCount: 2, // 2 trips for example
                itemBuilder: (context, index) {
                  return _TripCard(
                    index: index,
                    homeController:
                        homeController, // Pass the homeController here
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final int index;
  final HomeController homeController; // Accept HomeController as a parameter

  const _TripCard({required this.index, required this.homeController});

  @override
  Widget build(BuildContext context) {
    
    List<TravelDestination> allDestinations =
        homeController.myDestination.value;
    List<TravelDestination> thingsToDo =
        _getThingsToDoDestinations(allDestinations);
    List<TravelDestination> restaurants = _getRestaurantIDs(allDestinations)
        .map((id) =>
            allDestinations.firstWhere((dest) => dest.restaurantId == id))
        .toList();
    List<TravelDestination> hotels = _getHotelIDs(allDestinations)
        .map((id) => allDestinations.firstWhere((dest) => dest.hotelId == id))
        .toList();

    bool hasDate = index == 0; // Simulate different data for trips
    bool hasLocation = index == 0;

    return GestureDetector(
      onTap: () {
        print("Navigating to MyTripsWidget");
        print("Things to do: ${thingsToDo.map((e) => e.toString()).toList()}");
        print("Restaurants: ${restaurants.map((e) => e.toString()).toList()}");
        print("Places to stay: ${hotels.map((e) => e.toString()).toList()}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyTripsWidget(
              thingsToDo: thingsToDo,
              restaurants: restaurants,
              placesToStay: hotels,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(index == 0
                      ? 'assets/images/dana_trip.jpg'
                      : 'assets/images/dana_trip.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: hasDate
                            ? Text(
                                'Date: 2024-12-15 to 2024-12-20',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                              )
                            : TextButton(
                                onPressed: () {
                                  print("Add date clicked");
                                },
                                child: const Text('Have date yet? Add dates'),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: hasLocation
                            ? Text(
                                'Location: Da Nang, Viet Nam',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                              )
                            : Text(
                                'Location not set',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
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
