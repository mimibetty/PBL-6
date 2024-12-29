import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/common_views/circle_rating_widget_view.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_8.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/trip_data.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';

class PlanScreen6 extends StatefulWidget {
  @override
  _PlanScreen6 createState() => _PlanScreen6();
}

class _PlanScreen6 extends State<PlanScreen6> {
  final PlanScreenController planScreenController =
      Get.find<PlanScreenController>();

  bool selectAll = true;
  Set<String> selectedCards = {};
  List<int> selectedThingsToDoIDs = [];
  List<int> selectedHotelIDs = [];
  List<int> selectedRestaurantIDs = [];

  @override
  void initState() {
    super.initState();
    // Fetch destinations and select all items by default
    planScreenController.fetchDestinationsByCityAndTags().then((_) {
      _toggleSelectAll(selectAll);
    });
  }

  void _toggleSelectAll(bool value) {
    setState(() {
      selectAll = value;
      selectedCards.clear();
      selectedThingsToDoIDs.clear();
      selectedHotelIDs.clear();
      selectedRestaurantIDs.clear();
      if (selectAll) {
        selectedCards.addAll(
          [
            ...planScreenController.thingsToDoPlanScreen.map((e) => e.name),
            ...planScreenController.restaurantPlanScreen.map((e) => e.name),
            ...planScreenController.hotelPlanScreen.map((e) => e.name),
          ],
        );
        selectedThingsToDoIDs.addAll(
          planScreenController.thingsToDoPlanScreen.map((e) => e.id),
        );
        selectedHotelIDs.addAll(
          planScreenController.hotelPlanScreen.map((e) => e.id),
        );
        selectedRestaurantIDs.addAll(
          planScreenController.restaurantPlanScreen.map((e) => e.id),
        );
      }
    });
  }

  void _toggleSelection(String name, int id, String type) {
    setState(() {
      if (selectedCards.contains(name)) {
        selectedCards.remove(name);
        if (type == 'ThingsToDo') {
          selectedThingsToDoIDs.remove(id);
        } else if (type == 'Hotel') {
          selectedHotelIDs.remove(id);
        } else if (type == 'Restaurant') {
          selectedRestaurantIDs.remove(id);
        }
      } else {
        selectedCards.add(name);
        if (type == 'ThingsToDo') {
          selectedThingsToDoIDs.add(id);
        } else if (type == 'Hotel') {
          selectedHotelIDs.add(id);
        } else if (type == 'Restaurant') {
          selectedRestaurantIDs.add(id);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final startDate = TripDates().startDate;
    final endDate = TripDates().endDate;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trip Builder Preview',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Makes the text bold
            color: Colors.black, // Ensures the text color is visible
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Trip to ${planScreenController.cityName.value}, Vietnam',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      startDate != null && endDate != null
                          ? '${DateFormat('MMM d').format(startDate)} - ${DateFormat('MMM d').format(endDate)}'
                          : 'Dates not selected',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Things to Do Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Plan Your Day with These Must-Do Experiences',
                    'Explore activities tailored for you to make the most of your trip.',
                    planScreenController.thingsToDoPlanScreen,
                    'ThingsToDo',
                  ),
                  _buildSection(
                    'Must-Try Dining Spots for Food Lovers',
                    'Savor culinary delights and local flavors.',
                    planScreenController.restaurantPlanScreen,
                    'Restaurant',
                  ),
                  _buildSection(
                    'The Finest Accommodations',
                    'Rest in comfort at these top-rated stays.',
                    planScreenController.hotelPlanScreen,
                    'Hotel',
                  ),
                ],
              ),
            ),
          ),

          // Selected Cards Count
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedCards.length} items selected',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.8, // Adjust the size of the Switch
                      child: Switch(
                        value: selectedCards.length ==
                            (planScreenController.thingsToDoPlanScreen.length +
                                planScreenController
                                    .restaurantPlanScreen.length +
                                planScreenController.hotelPlanScreen.length),
                        onChanged: (value) {
                          _toggleSelectAll(value);
                        },
                      ),
                    ),
                    SizedBox(width: 3),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    final numberOfDays = TripDates().endDate != null &&
                            TripDates().startDate != null
                        ? TripDates()
                            .endDate!
                            .difference(TripDates().startDate!)
                            .inDays
                        : 0;

                    // Check if the number of selected restaurants is at least the number of days
                    // if (selectedRestaurantIDs.length < numberOfDays) {
                    //   // Show an alert dialog
                    //   showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return AlertDialog(
                    //         title: Text('Insufficient Restaurants Selected'),
                    //         content: Text(
                    //           'You need to select at least $numberOfDays restaurant(s) for your trip.',
                    //         ),
                    //         actions: [
                    //           TextButton(
                    //             onPressed: () {
                    //               Navigator.of(context)
                    //                   .pop(); // Close the dialog
                    //             },
                    //             child: Text('OK'),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   );
                    // } else {
                    // Navigate to the next screen if the condition is satisfied
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlanScreen8(
                          selectedHotelIDs: selectedHotelIDs,
                          selectedRestaurantIDs: selectedRestaurantIDs,
                          selectedThingsToDoIDs: selectedThingsToDoIDs,
                        ),
                      ),
                    );
                  },
                  // },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Blue background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 14, // Adjust font size
                      color: Colors.white, // White text color
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String description,
      List<TravelDestination> items, String type) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth =
                  (constraints.maxWidth - 24) / 2; // Adjust for spacing
              const cardHeight = 300.0; // Fixed height for the card

              return GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Avoid nested scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio:
                      cardWidth / cardHeight, // Adjust aspect ratio
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = selectedCards.contains(item.name);

                  return Container(
                    width: cardWidth,
                    height: cardHeight,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _toggleSelection(item.name, item.id, type);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Section
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    item.images.isNotEmpty
                                        ? item.images[0]
                                        : '',
                                    width: double.infinity,
                                    height: 140, // Fixed image height
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      _toggleSelection(
                                          item.name, item.id, type);
                                    },
                                    child: Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.add_circle,
                                      color: isSelected
                                          ? const Color.fromARGB(
                                              255, 63, 240, 10)
                                          : const Color.fromARGB(
                                              255, 2, 145, 255),
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Card Content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    CircleRatingWidget(
                                      rating: double.parse(
                                          item.rating.toStringAsFixed(1)),
                                      size: 16,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.description}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Duration: ${item.duration}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
