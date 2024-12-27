import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/start_rating_widget.dart';
import 'package:travelappflutter/presentation/common_views/circle_rating_widget_view.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_7.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/trip_data.dart';

class PlanScreen6 extends StatefulWidget {
  @override
  _PlanScreen6 createState() => _PlanScreen6();
}

class _PlanScreen6 extends State<PlanScreen6> {
  @override
  bool selectAll = true;

  void initState() {
    super.initState();
    // Select all items by default

    selectedCards.addAll(
      [
        ...thingsToDo.map((e) => e['title'] as String),
        ...restaurants.map((e) => e['title'] as String),
        ...hotels.map((e) => e['title'] as String),
      ],
    );
    _toggleSelectAll(selectAll);
  }

  void _toggleSelectAll(bool value) {
    setState(() {
      selectAll = value;
      selectedCards.clear();
      if (selectAll) {
        selectedCards.addAll(
          [
            ...thingsToDo.map((e) => e['title'] as String),
            ...restaurants.map((e) => e['title'] as String),
            ...hotels.map((e) => e['title'] as String),
          ],
        );
      }
    });
  }

  final List<Map<String, dynamic>> thingsToDo = [
    {
      'title': 'Must-See Attraction',
      'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 4.8,
      'duration': '2 hours',
      'features': ['Guide Included', 'Family Friendly'],
    },
    {
      'title': 'Hidden Gem',
     'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 4.5,
      'duration': '1.5 hours',
      'features': ['Quiet Spot', 'Scenic Views'],
    },
  ];

  final List<Map<String, dynamic>> restaurants = [
    {
      'title': 'Local Diner',
      'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 4.2,
      'duration': '1 hour',
      'features': ['Local Cuisine', 'Cozy Atmosphere'],
    },
    {
      'title': 'Fine Dining',
     'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 4.9,
      'duration': '2 hours',
      'features': ['Luxurious', 'Gourmet'],
    },
  ];

  final List<Map<String, dynamic>> hotels = [
    {
      'title': 'Luxury Hotel',
      'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 5.0,
      'duration': 'Stay',
      'features': ['Pool', 'Spa'],
    },
    {
      'title': 'Budget Inn',
     'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 3.8,
      'duration': 'Stay',
      'features': ['Affordable', 'Basic Amenities'],
    },
    {
      'title': 'Budget Inn 6',
      'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 3.8,
      'duration': 'Stay',
      'features': ['Affordable', 'Basic Amenities'],
    },
    {
      'title': 'Budget Inn 7',
      'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 3.8,
      'duration': 'Stay',
      'features': ['Affordable', 'Basic Amenities'],
    },
    {
      'title': 'Budget Inn 8',
      'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 3.8,
      'duration': 'Stay',
      'features': ['Affordable', 'Basic Amenities'],
    },
    {
      'title': 'Budget Inn 9',
      'image':
          'https://media-cdn-v2.laodong.vn/storage/newsportal/2024/12/24/1440299/DIFF-2023.jpg',
      'rating': 3.8,
      'duration': 'Stay',
      'features': ['Affordable', 'Basic Amenities'],
    },
  ];

  Set<String> selectedCards = {};

  @override
  Widget build(BuildContext context) {
    final startDate = TripDates().startDate;
    final endDate = TripDates().endDate;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Builder Preview'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
                  'Your Trip to Da Nang, Vietnam',
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
                    thingsToDo,
                  ),
                  _buildSection(
                    'Must-Try Dining Spots for Food Lovers',
                    'Savor culinary delights and local flavors.',
                    restaurants,
                  ),
                  _buildSection(
                    'The Finest Accommodations',
                    'Rest in comfort at these top-rated stays.',
                    hotels,
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
                      scale: 0.8, // Điều chỉnh kích thước của Switch
                      child: Switch(
                        value: selectedCards.length ==
                            (thingsToDo.length +
                                restaurants.length +
                                hotels.length),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PlanScreen7(), // Replace `NextPage` with your target page
                      ),
                    );
                  },
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

  Widget _buildSection(
      String title, String description, List<Map<String, dynamic>> items) {
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
                  final isSelected = selectedCards.contains(item['title']);

                  return Container(
                    width: cardWidth,
                    height: cardHeight,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => PageA(
                        //         title: item['title'],
                        //       ),
                        //     ),
                        //   );
                        // },
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
                                    item['image'],
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
                                      setState(() {
                                        if (isSelected) {
                                          selectedCards.remove(item['title']);
                                        } else {
                                          selectedCards.add(item['title']);
                                        }
                                      });
                                    },
                                    child: Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.add_circle,
                                      color: isSelected
                                          ? Colors.green
                                          : Colors.blue,
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
                                      item['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    CircleRatingWidget(
                                      rating: item['rating'],
                                      size: 16,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item['features'].join(', ')}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Duration: ${item['duration']}',
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
