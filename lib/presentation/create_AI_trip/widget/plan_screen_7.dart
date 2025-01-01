import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/common_views/geocoding_service.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_9.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/trip_data.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/map/map_screen.dart';

class PlanScreen7 extends StatefulWidget {
  final int UserId;
  final Map<String, dynamic> jsonResponse; // JSON từ PlanScreen8
  
  PlanScreen7({
    required this.UserId,
    required this.jsonResponse,
  });

  @override
  _PlanScreen7State createState() => _PlanScreen7State();
}

class _PlanScreen7State extends State<PlanScreen7>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final PlanScreenController planScreenController =
      Get.find<PlanScreenController>();
  late List<String> dailyScheduleKeys;
  Map<String, List<LatLng>> dailyCoordinates = {};
  LatLng? selectedHotelCoordinates;

  @override
  void initState() {
    super.initState();
    _fetchData();
    dailyScheduleKeys = widget.jsonResponse['daily_schedule'].keys.toList();
    int numberOfDays = _calculateNumberOfDays();
    _tabController = TabController(
        length: numberOfDays + 1, vsync: this); // +1 for 'Places to stay'
  }

  Future<void> _fetchData() async {
    final dailySchedule = widget.jsonResponse['daily_schedule'];

    await planScreenController.fetchDailyDestinations(dailySchedule);

    dailyCoordinates.clear(); // Ensure this is empty before populating

    for (String dayKey in dailySchedule.keys) {
      List<TravelDestination> destinations =
          planScreenController.dailyGroupedDestinations[dayKey] ?? [];
      List<LatLng> coordinates = [];

      print("Processing day: $dayKey");
      for (var destination in destinations) {
        // Exclude hotels
        String fullAddress = [
          destination.address.street?.trimRight(),
          destination.address.ward?.trimRight(),
          destination.address.district?.trimRight(),
          planScreenController.cityName.value.isNotEmpty
              ? planScreenController.cityName.value
              : "Không rõ thành phố"
        ]
            .where((item) =>
                item != null &&
                item.isNotEmpty) // Filter out null or empty values
            .map((item) => item?.replaceAll(
                RegExp(r',\s*$'), '')) // Remove trailing commas
            .join(', '); // Join with a comma

        try {
          await Future.delayed(Duration(milliseconds: 500));

          var coordinate =
              await GeocodingService.getCoordinatesFromAddress(fullAddress);
          if (coordinate != null) {
            LatLng latLng =
                LatLng(coordinate['latitude']!, coordinate['longitude']!);
            coordinates.add(latLng);

            // Print destination and its coordinates
            print("Destination: ${destination.name}, LatLng: $latLng");
          } else {
            print('Failed to get coordinates for address: $fullAddress');
          }
        } catch (e) {
          print('Error geocoding $fullAddress: $e');
        }
      }

      dailyCoordinates[dayKey] = coordinates;
      print("Coordinates for $dayKey: $coordinates");
    }

    setState(() {});
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  int _calculateNumberOfDays() {
    final tripDates = TripDates();
    if (tripDates.startDate == null || tripDates.endDate == null) {
      return 0;
    }
    return tripDates.endDate!
        .difference(tripDates.startDate!)
        .inDays; // Calculate the number of days
  }

  @override
  Widget build(BuildContext context) {
    int numberOfDays = _calculateNumberOfDays();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '${planScreenController.cityName} City Itinerary',
            style: TextStyle(color: Colors.black),
          ),
        ),
        
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: 'Places to stay'),
                for (int day = 1; day <= numberOfDays; day++)
                  Tab(text: 'Day $day'),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        final planScreenController = Get.find<PlanScreenController>();
        return TabBarView(
          controller: _tabController,
          children: [
            // Places to Stay Tab
            PlacesToStayTab(),

            // Day Tabs with Map
            for (var dayKey in dailyScheduleKeys)
              Column(
                children: [
                  // Card Section for Day Content
                  Expanded(
                    child: ItineraryDayTab(
                      day: dayKey,
                      destinations: planScreenController
                              .dailyGroupedDestinations[dayKey] ??
                          [],
                    ),
                  ),

                  // Map and Save Button Section
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Container(
                          height: 250, // Reduced height for a closer look

                          child: Builder(
                            builder: (context) {
                              final coordinates =
                                  dailyCoordinates[dayKey] ?? [];
                              return coordinates.isNotEmpty
                                  ? MapScreen(
                                      coordinates: coordinates,
                                      zoom: 12.0,
                                    )
                                  : Center(
                                      child: Text(
                                        "No coordinates available for $dayKey",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                    // Centered Save Button (Conditionally Rendered)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final Map<String, dynamic> jsonResponse = widget.jsonResponse;
                            final String action = "Itinerary";

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlanScreen9(
                                  jsonResponse: jsonResponse,
                                  action: action,
                                  UserId: widget.UserId,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 5,
                          ),
                          icon: Icon(
                            Icons.save_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Text(
                            'Save Itinerary',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        );
      }),
    );
  }
}

class PlacesToStayTab extends StatefulWidget {
  @override
  _PlacesToStayTabState createState() => _PlacesToStayTabState();
}

class _PlacesToStayTabState extends State<PlacesToStayTab> {
  final PlanScreenController planScreenController =
      Get.find<PlanScreenController>();

  LatLng? selectedCoordinates;
  bool showMap = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (planScreenController.hotelPlanScreen.isEmpty) {
        return Center(
          child: Text(
            'No recommended places to stay available.',
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        );
      }

      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: planScreenController.hotelPlanScreen.length,
              itemBuilder: (context, index) {
                final hotel = planScreenController.hotelPlanScreen[index];

                return GestureDetector(
                  onTap: () async {
                    String fullAddress = [
                      hotel.address.street?.trimRight(),
                      hotel.address.ward?.trimRight(),
                      hotel.address.district?.trimRight(),
                      planScreenController.cityName.value
                    ]
                        .where((item) => item != null && item.isNotEmpty)
                        .map((item) => item!.replaceAll(RegExp(r',\s*\$'), ''))
                        .join(', ');

                    try {
                      var coordinate =
                          await GeocodingService.getCoordinatesFromAddress(
                              fullAddress);

                      if (coordinate != null) {
                        setState(() {
                          selectedCoordinates = LatLng(coordinate['latitude']!,
                              coordinate['longitude']!);
                          showMap = true;
                        });
                      } else {
                        print('Unable to find coordinates for: $fullAddress');
                      }
                    } catch (e) {
                      print('Geocoding error: $e');
                    }
                  },
                  child: _buildPlaceToStay(
                    imageUrl: hotel.images[0],
                    name: hotel.name,
                    address: hotel.address.district ?? "No address available",
                    time: hotel.openTime.toString(),
                    rating: hotel.rating.toStringAsFixed(1),
                    numOfReviews: hotel.numOfReviews.toString(),
                    price: hotel.priceTop - hotel.priceBottom == 0
                        ? '\$${hotel.priceTop}'
                        : '\$${hotel.priceBottom} - \$${hotel.priceTop}',
                    description: hotel.description,
                  ),
                );
              },
            ),
          ),
          if (showMap)
            Stack(
              children: [
                Container(
                  height: 250,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: MapScreen(
                    coordinates: [selectedCoordinates!],
                    zoom: 12.0,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showMap = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
        ],
      );
    });
  }

  Widget _buildPlaceToStay({
    required String imageUrl,
    required String name,
    required String address,
    required String time,
    required String rating,
    required String numOfReviews,
    required String price,
    required String description,
  }) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 5),

            // Title and Heart Icon for favorite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.favorite_border, color: Colors.red, size: 24), // Favorite icon
              ],
            ),
            SizedBox(height: 5),

            // Address
            Text(address, style: TextStyle(color: Colors.black54)),
            SizedBox(height: 5),

            // Time
            Text(
              "Time: $time",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 5),

            // Rating and Reviews
            Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.amber),
                SizedBox(width: 4),
                Text("$rating", style: TextStyle(fontSize: 14, color: Colors.black)),
                SizedBox(width: 10),
                Text("($numOfReviews reviews)", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            SizedBox(height: 5),

            // Price
            Text(
              price,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // Description
            Text(description, style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class ItineraryDayTab extends StatelessWidget {
  final String day;
  final List<TravelDestination> destinations; // List of destinations for the current day

  ItineraryDayTab({
    required this.day,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        final destination = destinations[index];
        return _buildLocationCard(
          name: destination.name,
          imageUrl: destination.images[0],
          description: destination.description,
          address: destination.address.district ?? "No address available",
          addressDetail: "${destination.address.street ?? ''} ${destination.address.ward ?? ''}",
          time: destination.openTime.toString(),
          rating: destination.rating.toStringAsFixed(1),
          numOfReviews: destination.numOfReviews.toString(),
        );
      },
    );
  }

  Widget _buildLocationCard({
    required String name,
    required String imageUrl,
    required String description,
    required String address,
    required String addressDetail,
    required String time,
    required String rating,
    required String numOfReviews,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Increased bottom padding for better separation
      child: Card(
        color: Colors.white, // Changed to white for better contrast
        elevation: 5, // Increased elevation for better card effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners for a smoother look
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ExpansionTile(
            backgroundColor: Colors.white, // Same background color as the card
            tilePadding: EdgeInsets.all(0),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(address, style: TextStyle(color: Colors.black54, fontSize: 14)),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.location_pin, color: Colors.red, size: 18),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      addressDetail,
                                      style: TextStyle(color: Colors.black54),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Time: $time",
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    "$rating ★",
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "($numOfReviews reviews)",
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
      ),
    );
  }
}
