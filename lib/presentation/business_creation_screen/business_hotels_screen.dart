import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/list_view_widget.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';

class BusinessFacilityScreen extends StatefulWidget {
  final List<TravelDestination> destinations;

  const BusinessFacilityScreen({Key? key, required this.destinations})
      : super(key: key);

  @override
  _BusinessFacilityScreenState createState() => _BusinessFacilityScreenState();
}

class _BusinessFacilityScreenState extends State<BusinessFacilityScreen> {
  late List<TravelDestination> destinations;

  @override
  @override
  void initState() {
    super.initState();
    destinations = widget.destinations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Business Hotels"),
        centerTitle: true,
      ),
      body: destinations.isNotEmpty
          ? DestinationListWidget(recommendDestinations: destinations)
          : const Center(
              child: Text(
                "No Hotels Available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
    );
  }
}
