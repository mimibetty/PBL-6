import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:travelappflutter/presentation/common_views/geocoding_service.dart';
import 'package:travelappflutter/presentation/common_views/heart_icon_widget.dart';
import 'package:travelappflutter/presentation/map/map_screen.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';

class ItineraryViewTrip extends StatefulWidget {
  final String tripName;
  final int userId;
  final Map<String, dynamic> jsonResponse;
  final List<TravelDestination> hotelList;
  final List<TravelDestination> restaurantList;
  final List<TravelDestination> thingsToDoList;

  const ItineraryViewTrip({
    required this.tripName,
    required this.userId,
    required this.jsonResponse,
    required this.hotelList,
    required this.restaurantList,
    required this.thingsToDoList,
    Key? key,
  }) : super(key: key);

  @override
  _ItineraryViewTripState createState() => _ItineraryViewTripState();
}

class _ItineraryViewTripState extends State<ItineraryViewTrip>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> dailyScheduleKeys;
  late Set<int> restaurantIDs;
  late Set<int> thingsToDoIDs;
  late Map<int, TravelDestination> allDestinations;

  // This will store coordinates for each day
  Map<String, List<LatLng>> dailyCoordinates = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Lấy danh sách các ngày từ jsonResponse
    dailyScheduleKeys = widget.jsonResponse['daily_schedule']?.keys
            .where(
                (key) => _getDayNumber(key) > 0) // Chỉ lấy những ngày lớn hơn 0
            .toList() ??
        [];
    dailyScheduleKeys.sort();

    // Lấy ID từ các danh sách truyền vào widget
    restaurantIDs = widget.restaurantList.map((r) => r.id).toSet();
    thingsToDoIDs = widget.thingsToDoList.map((t) => t.id).toSet();

    // Tạo một bản đồ allDestinations
    allDestinations = {
      for (var destination
          in widget.hotelList + widget.restaurantList + widget.thingsToDoList)
        destination.id: destination,
    };

    // Prepare daily coordinates map
    final dailySchedule = widget.jsonResponse['daily_schedule'] ?? {};
    for (var dayKey in dailyScheduleKeys) {
      List<TravelDestination> destinations =
          (dailySchedule[dayKey] as List<dynamic>?)
                  ?.map((id) => allDestinations[id])
                  .whereType<TravelDestination>()
                  .toList() ??
              [];

      List<LatLng> coordinates = [];
      for (var destination in destinations) {
        // Assuming you have a way to fetch coordinates, like a geocoding service
        String fullAddress = [
          destination.address.street?.trimRight(),
          destination.address.ward?.trimRight(),
          destination.address.district?.trimRight(),
          "City" // You can replace with actual city name
        ]
            .where((item) => item != null && item.isNotEmpty)
            .map((item) => item?.replaceAll(RegExp(r',\s*$'), ''))
            .join(', ');

        try {
          var coordinate =
              await GeocodingService.getCoordinatesFromAddress(fullAddress);
          if (coordinate != null) {
            coordinates
                .add(LatLng(coordinate['latitude']!, coordinate['longitude']!));
          }
        } catch (e) {
          print("Error fetching coordinates: $e");
        }
      }
      dailyCoordinates[dayKey] = coordinates;
    }

    // Initialize TabController
    _tabController = TabController(
      length: dailyScheduleKeys.length + 1,
      vsync: this,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dailySchedule = widget.jsonResponse['daily_schedule'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text("Itinerary for ${widget.tripName}"),
        backgroundColor: Colors.grey[200],
      ),
      body: Column(
        children: [
          // TabBar showing days and "Places to Stay" tab
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.blueAccent,
            tabs: [
              const Tab(text: 'Places to Stay'),
              for (var dayKey in dailyScheduleKeys)
                Tab(text: _formatDayLabel(dayKey)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // "Places to Stay" tab
                PlacesToStayTab(hotels: widget.hotelList),
                // Daily schedule tabs
                for (var dayKey in dailyScheduleKeys)
                  DailyScheduleTab(
                    dayKey: _formatDayLabel(dayKey),
                    destinations: (dailySchedule[dayKey] as List<dynamic>?)
                            ?.map((id) => allDestinations[id])
                            .whereType<TravelDestination>()
                            .toList() ??
                        [],
                    restaurantIDs: restaurantIDs,
                    thingsToDoIDs: thingsToDoIDs,
                    allDestinations: allDestinations,
                    coordinates: dailyCoordinates[dayKey] ?? [],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDayLabel(String dayKey) {
    return 'Day ${_getDayNumber(dayKey)}';
  }

  int _getDayNumber(String dayKey) {
    return int.parse(dayKey.replaceAll(RegExp(r'\D'), ''));
  }
}


class HotelCard extends StatelessWidget {
  final TravelDestination hotel;

  const HotelCard({required this.hotel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(destination: hotel),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    hotel.images.isNotEmpty
                        ? hotel.images[0]
                        : Hotel.defaultImageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: HeartIconWidget(
                    userId: Get.find<AuthController>().userId.value,
                    destinationId: hotel.id,
                    isLiked: false,
                    size: 30,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.location,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

class DailyScheduleTab extends StatelessWidget {
  final String dayKey;
  final List<TravelDestination> destinations;
  final Set<int> restaurantIDs;
  final Set<int> thingsToDoIDs;
  final Map<int, TravelDestination> allDestinations;
  final List<LatLng> coordinates;

  const DailyScheduleTab({
    required this.dayKey,
    required this.destinations,
    required this.restaurantIDs,
    required this.thingsToDoIDs,
    required this.allDestinations,
    required this.coordinates,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Wrap everything in a scroll view
      child: Column(
        children: [
          // Map for each day

          // List of destinations for the day
          ListView.builder(
            shrinkWrap: true, // Prevent ListView from taking full screen space
            physics:
                NeverScrollableScrollPhysics(), // Disable the ListView's own scroll
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];

              // Determine if the destination is a restaurant or "Things to Do"
              final isRestaurant = restaurantIDs.contains(destination.id);
              final tag = isRestaurant ? "Restaurant" : "Things to Do";

              return DestinationCard(destination: destination, tag: tag);
            },
          ),
          SizedBox(height: 16),
          Padding(
            padding:
                const EdgeInsets.only(left: 1.0), // Adds padding to the left
            child: const Text(
              "Map",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 400, // Set height for the map
            child: coordinates.isNotEmpty
                ? MapScreen(coordinates: coordinates, zoom: 12.0)
                : Center(child: Text("No coordinates available for $dayKey")),
          ),
        ],
      ),
    );
  }
}

class PlacesToStayTab extends StatelessWidget {
  final List<TravelDestination> hotels;

  const PlacesToStayTab({required this.hotels, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Wrap the entire content in a scrollable view
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Find your perfect home away from home",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Discover new places to stay, picked just for you",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            hotels.isEmpty
                ? const Center(child: Text("No hotels available."))
                : ListView.builder(
                    shrinkWrap:
                        true, // Prevent ListView from taking full screen space
                    itemCount: hotels.length,
                    itemBuilder: (context, index) =>
                        HotelCard(hotel: hotels[index]),
                  ),
          ],
        ),
      ),
    );
  }
}

class DestinationCard extends StatefulWidget {
  final TravelDestination destination;
  final String tag;

  const DestinationCard({
    required this.destination,
    required this.tag,
    Key? key,
  }) : super(key: key);

  @override
  _DestinationCardState createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  bool isExpanded = false;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;
    final userId = Get.find<AuthController>().userId.value;
    final detailedAddress =
        '${destination.address.street}, ${destination.address.ward}, ${destination.address.district}';

    return GestureDetector(
      onTap: () {
        // Navigate to PlaceDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(destination: destination),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            // Make the card content scrollable
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with image, heart icon, and tag
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        destination.images.isNotEmpty
                            ? destination.images[0]
                            : Hotel.defaultImageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: HeartIconWidget(
                        userId: userId,
                        destinationId: destination.id,
                        isLiked: false,
                        size: 30,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: widget.tag == "Restaurant"
                              ? Colors.red.withOpacity(0.8)
                              : Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Name and details
                Text(
                  destination.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Address
                Row(
                  children: [
                    const Icon(Icons.location_pin,
                        color: Colors.blue, size: 20),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        detailedAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Open Time
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Colors.orange, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Open: ${destination.openTime}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Rating and Price Range
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${destination.rating.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${destination.numOfReviews} reviews)',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Price: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '\$${destination.priceBottom.toStringAsFixed(1)} - \$${destination.priceTop.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Expandable Description
                if (isExpanded) ...[
                  Text(
                    destination.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                GestureDetector(
                  onTap: toggleExpanded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        isExpanded ? 'Show Less' : 'Show More',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
