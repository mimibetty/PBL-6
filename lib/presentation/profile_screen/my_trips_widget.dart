import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/recomendate.dart';

class MyTripsWidget extends StatefulWidget {
  final List<TravelDestination> thingsToDo;
  final List<TravelDestination> restaurants;
  final List<TravelDestination> placesToStay;

  const MyTripsWidget({
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
      appBar: AppBar(
        title: const Text("My Trips Details"),
        backgroundColor: Colors.grey[100],
        actions: [
          _buildSortDropdown(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_sortCriteria == 'Show All' || _sortCriteria == 'Things to Do') 
              _buildSection("Things to do", widget.thingsToDo),
            if (_sortCriteria == 'Show All' || _sortCriteria == 'Restaurants') 
              _buildSection("Restaurants", widget.restaurants),
            if (_sortCriteria == 'Show All' || _sortCriteria == 'Places to Stay') 
              _buildSection("Play to stay", widget.placesToStay),
          ],
        ),
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
      icon: Icon(Icons.sort, color: Colors.black),
      iconSize: 24,
      elevation: 16,
      itemBuilder: (BuildContext context) {
        return <String>['Show All', 'Things to Do', 'Restaurants', 'Places to Stay']
            .map<PopupMenuEntry<String>>((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      },
    ),
  );
}


  Widget _buildSection(String title, List<TravelDestination> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: items
              .map(
                (destination) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Material(
                    child: Recomendate(destination: destination),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
