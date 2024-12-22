import 'package:flutter/material.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  _MyTripsScreenState createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
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
                  return _TripCard(index: index);
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
  const _TripCard({required this.index});

  @override
  Widget build(BuildContext context) {
    // Simulate different data for each trip
    bool hasDate = index == 0; // First trip has date, second one doesn't
    bool hasLocation =
        index == 0; // First trip has location, second one doesn't

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          // Left side (image)
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(index == 0
                    ? 'assets/images/dana_trip.jpg'
                    : 'assets/images/dana_trip.jpg'), // Same image for this case
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          // Right side (trip information)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip title
                Text(
                  'Trip ${index + 1}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                  maxLines: 2, // Limit the title to one line

                  softWrap: true, // Allow soft wrapping to multiple lines
                ),
                const SizedBox(height: 8),
                // Date information with icon
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      // Ensure date text fits without overflow
                      child: hasDate
                          ? Text(
                              'Date: 2024-12-15 to 2024-12-20',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
                              maxLines: 2, // Prevent overflow
                              softWrap:
                                  true, // Allow soft wrapping to multiple lines
                            )
                          : TextButton(
                              onPressed: () {
                                // Handle adding date
                                print("Add date clicked");
                              },
                              child: const Text('Have date yet? Add dates'),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Location information with icon
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      // Ensure location text fits without overflow
                      child: hasLocation
                          ? Text(
                              'Location: Da Nang, Viet Nam',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2, // Prevent overflow
                              softWrap:
                                  true, // Allow soft wrapping to multiple lines
                            )
                          : Text(
                              'Location not set',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              overflow:
                                  TextOverflow.ellipsis, // Prevent overflow
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
  }
}
