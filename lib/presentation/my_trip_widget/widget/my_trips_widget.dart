import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/recomendate.dart';

class MyTripsWidget extends StatefulWidget {
  final String tripName;
  final List<TravelDestination> thingsToDo;
  final List<TravelDestination> restaurants;
  final List<TravelDestination> placesToStay;

  const MyTripsWidget({
    required this.tripName,
    super.key,
    required this.thingsToDo,
    required this.restaurants,
    required this.placesToStay,
  });

  @override
  _MyTripsWidgetState createState() => _MyTripsWidgetState();
}

class _MyTripsWidgetState extends State<MyTripsWidget> {
  String _sortCriteria = 'Show All'; // Default sorting criteria

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "${widget.tripName} Details",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueAccent.withOpacity(1),
        actions: [
          _buildSortDropdown(),
        ],
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16), // Khoảng cách từ AppBar đến nội dung
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.tripName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 36), // Thêm khoảng cách giữa tên trip và nội dung
              if (_sortCriteria == 'Show All' || _sortCriteria == 'Things to Do')
                _buildSection("Things to Do", widget.thingsToDo),
              if (_sortCriteria == 'Show All' || _sortCriteria == 'Restaurants')
                _buildSection("Restaurants", widget.restaurants),
              if (_sortCriteria == 'Show All' || _sortCriteria == 'Places to Stay')
                _buildSection("Places to Stay", widget.placesToStay),
            ],
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage('assets/background.jpg'), // Thay bằng đường dẫn ảnh của bạn
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Container(
        color: Colors.black.withOpacity(0.3), // Hiệu ứng mờ
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: PopupMenuButton<String>(
        onSelected: (String newValue) {
          setState(() {
            _sortCriteria = newValue;
          });
        },
        icon: const Icon(Icons.sort, color: Colors.white),
        itemBuilder: (BuildContext context) {
          return <String>['Show All', 'Things to Do', 'Restaurants', 'Places to Stay']
              .map<PopupMenuEntry<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList();
        },
      ),
    );
  }

  Widget _buildSection(String title, List<TravelDestination> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        child: Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            hintColor: Colors.blueAccent,
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
            childrenPadding: const EdgeInsets.symmetric(vertical: 8.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (items.isNotEmpty)
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      items.length.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: AnimatedRotation(
              turns: 0.5,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.expand_more, color: Colors.blueAccent),
            ),
            children: items
                .map(
                  (destination) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Material(
                          color: Colors.grey[100],
                          child: Recomendate(destination: destination),
                        ),
                      ),
                      if (destination != items.last)
                        Divider(color: Colors.grey[300], thickness: 1),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
