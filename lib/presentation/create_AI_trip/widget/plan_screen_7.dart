import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/trip_data.dart';
import 'package:travelappflutter/presentation/map/map_screen.dart';

class PlanScreen7 extends StatefulWidget {
  @override
  _PlanScreen7State createState() => _PlanScreen7State();
}

class _PlanScreen7State extends State<PlanScreen7>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    int numberOfDays = _calculateNumberOfDays();
    _tabController = TabController(
        length: numberOfDays + 1, vsync: this); // +1 for 'Places to stay'
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
        title: Text('Da Nang City Itinerary',
            style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: 'Places to stay'),
            for (int day = 1; day <= numberOfDays; day++) Tab(text: 'Day $day'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PlacesToStayTab(),
          for (int day = 1; day <= numberOfDays; day++)
            ItineraryDayTab(
                day: 'Day $day', description: 'Description for Day $day.'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Save itinerary'),
        icon: Icon(Icons.favorite_border),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PlacesToStayTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'We\'ve also recommended some places to stay during your trip.',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        SizedBox(height: 16),
        _buildPlaceToStay(
          imageUrl:
              'https://vivutour.vn/wp-content/uploads/2024/09/muong-thanh-luxury-anh-sp-1.jpg',
          name: 'Mường Thanh 1 Đà Nẵng',
          details: '4 star hotel · 2.80 mi from location',
          price: '\$209 USD - \$479 USD per night',
          description:
              'Perfectly located for exploring Da Nang, this hotel offers small, creative rooms with a modern ambiance and friendly service.',
        ),
        SizedBox(height: 16),
        _buildPlaceToStay(
          imageUrl:
              'https://vivutour.vn/wp-content/uploads/2024/09/muong-thanh-luxury-anh-sp-1.jpg',
          name: 'Mường Thanh 2 Đà Nẵng',
          details: '5 star resort · Beachfront',
          price: '\$309 USD - \$679 USD per night',
          description:
              'A luxurious escape with stunning ocean views, offering premium amenities and impeccable service.',
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPlaceToStay(
      {required String imageUrl,
      required String name,
      required String details,
      required String price,
      required String description}) {
    return Card(
      color: Colors.grey[100], // Lighter gray color for the card background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl,
                height: 120, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Icon(Icons.favorite_border, color: Colors.black),
              ],
            ),
            Text(details, style: TextStyle(color: Colors.black54)),
            Text(price, style: TextStyle(color: Colors.black)),
            SizedBox(height: 8),
            Text(description, style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class ItineraryDayTab extends StatelessWidget {
  final String day;
  final String description;

  ItineraryDayTab({required this.day, required this.description});

  @override
  Widget build(BuildContext context) {
    // Example coordinates
    final List<LatLng> coordinates = [
      LatLng(16.06778, 108.22083), // Cầu Rồng (Dragon Bridge)
      LatLng(16.06690, 108.22232), // Chợ Hàn (Han Market)
      LatLng(16.07127, 108.22483), // Nhà Thờ Con Gà (Danang Cathedral)
    ];

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          day,
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(height: 16),
        for (int i = 1; i <= 4; i++) _buildLocationCard(i),
        SizedBox(height: 16),
        // Map container at the end
        Container(
          height: 300,
          child: MapScreen(
            coordinates: coordinates,zoom:14,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        color: Colors.grey[100],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ExpansionTile(
            backgroundColor: Colors.grey[100],
            tilePadding: EdgeInsets.all(0),
            title: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text('Location $index',
                  style: TextStyle(color: Colors.black)),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Description of location $index',
                  style: TextStyle(color: Colors.black54)),
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
                              image: NetworkImage(
                                  "https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg"),
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
                                "Las Vegas 212 - Khu du thuy...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Time: Not available",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  for (int i = 1; i <= 5; i++)
                                    Icon(
                                      Icons.circle,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "0.0 ★",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "(0 reviews)",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Divider(thickness: 1, color: Colors.black26),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 4,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      "outdoor sitting",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black87),
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
                    const SizedBox(height: 20),
                    Text(
                      'Here is some additional information about Location $index. This can include details such as the history, significance, or tips for visiting.',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
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
