import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_1.dart';

class PlanScreen9 extends StatelessWidget {
  final Map<String, dynamic> jsonResponse;
  final String action;
  final int UserId;

  PlanScreen9({
    required this.jsonResponse,
    required this.action,
    required this.UserId,
  });

  final TextEditingController _tripNameController = TextEditingController();
  final PlanScreenController planScreenController =
      Get.find<PlanScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Name Your Trip',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Correct property for a single color
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.map_outlined,
                  color: Colors.blue.shade700,
                  size: 80,
                ),
                SizedBox(height: 50),
                Text(
                  'Organize your saves and create a custom trip',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                TextField(
                  controller: _tripNameController,
                  decoration: InputDecoration(
                    labelText: 'Enter itinerary name',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    hintText: 'E.g., Summer Vacation 2024',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100, // Light background
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    String tripName = _tripNameController.text.trim();

                    if (tripName.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter a name for your trip",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    final result = action == "Itinerary"
                        ? await planScreenController.saveTripAI(
                            name: tripName,
                            monthTime: planScreenController.monthTime.value,
                            duration: planScreenController.tripLength.value,
                            userId: UserId,
                            buildData: jsonResponse,
                          )
                        : await planScreenController.buildTripNoAI(
                            name: tripName,
                            userId: UserId,
                            buildData: jsonResponse,
                          );

                    if (result['success']) {
                      Get.snackbar(
                        "Success",
                        action == "Itinerary"
                            ? "Trip created successfully!"
                            : "Trip saved successfully!",
                        snackPosition: SnackPosition.BOTTOM,
                      );

                      Get.off(() => PlanScreen());
                    } else {
                      Get.snackbar(
                        "Error",
                        result['message'] ?? "An error occurred",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Create Trip',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
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
