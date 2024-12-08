import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/popular_place.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/recomendate.dart';

class SeeAllScreen extends StatelessWidget {
  final String title;
  final List<TravelDestination> destinations;

  const SeeAllScreen({
    Key? key,
    required this.title,
    required this.destinations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceDetailScreen(destination: destination),
                ),
              );
            },
            child: Recomendate(destination: destination),
          );
        },
      ),
    );
  }
}
