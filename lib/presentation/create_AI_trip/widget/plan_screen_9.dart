import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';

class PlanScreen9 extends StatelessWidget {
  final int UserId;
  final List<int> selectedHotelIDs;
  final List<int> selectedRestaurantIDs;
  final List<int> selectedThingsToDoIDs;
  final String action;

  PlanScreen9({
    required this.UserId,
    required this.selectedHotelIDs,
    required this.selectedRestaurantIDs,
    required this.selectedThingsToDoIDs,
    required this.action,
  });

  final TextEditingController _tripNameController = TextEditingController();
  final PlanScreenController planScreenController = Get.find<PlanScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name your trip'),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Organize your saves and create a custom trip',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _tripNameController,
                decoration: InputDecoration(
                  labelText: 'Your itinerary name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
 
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}