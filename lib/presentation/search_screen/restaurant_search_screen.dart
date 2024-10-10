import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:travelappflutter/presentation/home_screen/restaurant_detail.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';

class RestaurantSearchScreen extends StatefulWidget {
  @override
  _RestaurantSearchScreenState createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<Restaurant> filteredRestaurants = [];
  late List<Restaurant> restaurants; // Declare late to initialize later

  @override
  void initState() {
    super.initState();
    // Ensure restaurantList is not null before filtering
    restaurants = restaurantList
        .where((destination) => destination.rating > 3.5)
        .toList();
    filteredRestaurants = restaurants; // Initialize with the complete list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Restaurants'),
        leading: BackButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterMenu(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = filteredRestaurants[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetailScreen(restaurant: restaurant),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display restaurant image (left)
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(restaurant.images[0]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Display restaurant info (right)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Restaurant name
                            Text(
                              restaurant.restaurantName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 15),
                            // Opening hours
                            Text(
                              "Time: ${restaurant.time}",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 15),
                            // Rating, Review
                            Row(
                              children: [
                                for (int i = 1; i <= 5; i++)
                                  Icon(
                                    Icons.circle,
                                    size: 12,
                                    color: i <= restaurant.rating.floor()
                                        ? Color(0xFF13357B)
                                        : (i == restaurant.rating.floor() + 1 &&
                                                restaurant.rating -
                                                        restaurant.rating
                                                            .floor() >=
                                                    0.5)
                                            ? Color(0xFF13357B).withOpacity(0.5)
                                            : Colors.grey,
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  "${restaurant.rating.toString()} ★",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    "(${restaurant.review} reviews)",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Divider(thickness: 1, color: Colors.black26),
                            const SizedBox(height: 5),
                            // Display restaurant features
                            Wrap(
                              spacing: 4,
                              children: restaurant.feature
                                  .map((feature) => Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          feature,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Show filter menu (bottom sheet)
  void _showFilterMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildCheckboxGroup('Establishment Type', 'types', [
                  'Restaurant',
                  'Coffee & Tea',
                  'Bar & Pubs',
                  'Dessert',
                  'Bakeries',
                  'Delivery Only',
                ]),
                _buildCheckboxGroup('Meals', 'meals', [
                  'Breakfast',
                  'Brunch',
                  'Lunch',
                  'Dinner',
                ]),
                _buildCheckboxGroup('Price', 'price', [
                  'Cheap Eats',
                  'Mid-range',
                  'Fine Dining',
                ]),
                _buildCheckboxGroup('Cuisines', 'cuisines', [
                  'Vietnamese',
                  'Asian',
                  'Seafood',
                  'Deli',
                ]),
                _buildCheckboxGroup('Dishes', 'dishes', [
                  'Beef',
                  'Fish',
                  'Salad',
                  'Noodle',
                ]),
                _buildCheckboxGroup('Features', 'features', [
                  'Seating',
                  'Reservation',
                  'Free Wifi',
                  'Serves Alcohol',
                ]),
                _buildCheckboxGroup('Good for', 'good_for', [
                  'Families with children',
                  'Large groups',
                  'Kids',
                  'Romantic',
                ]),
                _buildCheckboxGroup('Other', 'other', [
                  'Open Now',
                ]),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      var selectedFilters = _formKey.currentState!.value;
                      _applyFilters(selectedFilters);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Apply Filters'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildCheckboxGroup(String title, String name, List<String> options) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      FormBuilderCheckboxGroup<String>(
        name: name,
        options: options
            .map((option) => FormBuilderFieldOption(value: option))
            .toList(),
      ),
      const SizedBox(height: 16),
    ],
  );
}


  // Apply filters
  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      filteredRestaurants = restaurants.where((restaurant) {
        bool matchesType = filters['types'] != null &&
            filters['types'].any((type) => restaurant.feature.contains(type));
        bool matchesMeal = filters['meals'] != null &&
            filters['meals'].any((meal) => restaurant.feature.contains(meal));
        return matchesType && matchesMeal;
      }).toList();
    });
  }
}
