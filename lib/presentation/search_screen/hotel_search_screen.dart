import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:travelappflutter/presentation/home_screen/hotel_detail.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';

class HotelSearchScreen extends StatefulWidget {
  @override
  _HotelSearchScreenState createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<Hotel> filteredHotels = [];
  late List<Hotel> hotels;

  @override
  void initState() {
    super.initState();
    hotels = mockHotels
        .where((hotel) => hotel.rating > 3.5)
        .toList();
    filteredHotels = hotels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels'),
        leading: BackButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterMenu(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top Hotels in Da Nang",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${filteredHotels.length}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " result match your filter", 
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort by: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  DropdownButton<String>(
                    value: "Rating",
                    items: <String>[
                      'Rating',
                      'Name',
                      'Review Count',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      _sortHotels(newValue);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHotels.length,
              itemBuilder: (context, index) {
                final hotel = filteredHotels[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HotelDetailScreen(hotel: hotel),
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
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(hotel.images[0]),
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
                                    hotel.hotelName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Address: ${hotel.hotelLocation}",
                                    style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      for (int i = 1; i <= 5; i++)
                                        Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: i <= hotel.rating.floor()
                                              ? Color(0xFF13357B)
                                              : (i ==
                                                          hotel.rating.floor() + 1 &&
                                                      hotel.rating - hotel.rating.floor() >= 0.5)
                                                  ? Color(0xFF13357B).withOpacity(0.5)
                                                  : Colors.grey,
                                        ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${hotel.rating.toString()} ★",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          "(${hotel.review} reviews)",
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
                                  Wrap(
                                    spacing: 4,
                                    children: hotel.roomFeature
                                        .map((feature) => Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(15),
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
          ),
        ],
      ),
    );
  }

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
                FormBuilderDateRangePicker(
                  name: 'date_range',
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  decoration: InputDecoration(
                    labelText: 'Select Check-in & Check-out Dates',
                  ),
                ),
                const SizedBox(height: 16),
                _buildCheckboxGroup('Price Range', 'price', [
                  'Low',
                  'Medium',
                  'High',
                ]),
                _buildCheckboxGroup('Amenities', 'amenities', [
                  'Free Wifi',
                  'Breakfast Included',
                  'Parking',
                  'Pool',
                ]),
                const SizedBox(height: 16),
                
                const SizedBox(height: 16),
                _buildCheckboxGroup('Hotel Star', 'hotel_star', [
                  '1 Star',
                  '2 Star',
                  '3 Star',
                  '4 Star',
                  '5 Star',
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
    return FormBuilderCheckboxGroup(
      decoration: InputDecoration(labelText: title),
      name: name,
      options: options
          .map((option) => FormBuilderFieldOption(value: option))
          .toList(),
    );
  }

  void _applyFilters(Map<String, dynamic> filters) {
    // setState(() {
    //   filteredHotels = hotels.where((hotel) {
    //     bool matchesPrice = filters['price'] != null &&
    //         filters['price'].any((price) => hotel.price == price);
    //     // Logic for other filters
    //     return matchesPrice;
    //   }).toList();
    // });
  }

  void _sortHotels(String? newValue) {
    // setState(() {
    //   if (newValue == "Rating") {
    //     filteredHotels.sort((a, b) => b.rating.compareTo(a.rating));
    //   } else if (newValue == "Name") {
    //     filteredHotels.sort(
    //         (a, b) => a.hotelName.compareTo(b.hotelName));
    //   } else if (newValue == "Review Count") {
    //     filteredHotels.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    //   }
    // });
  }
}

