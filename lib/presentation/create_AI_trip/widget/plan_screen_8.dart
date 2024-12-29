import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_7.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_9.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';

class PlanScreen8 extends StatelessWidget {
  final List<int> selectedHotelIDs;
  final List<int> selectedRestaurantIDs;
  final List<int> selectedThingsToDoIDs;

  PlanScreen8({
    required this.selectedHotelIDs,
    required this.selectedRestaurantIDs,
    required this.selectedThingsToDoIDs,
  });

  final AuthController authController = Get.find<AuthController>();
  final PlanScreenController planScreenController = Get.find<PlanScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose an Option'),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(85, 131, 206, 241),
              const Color.fromARGB(33, 105, 175, 207),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Continue planning your trip',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(211, 49, 201, 228),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Save your selections and get inspired with more guidance',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(225, 1, 36, 107),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildOptionButton(
                icon: Icons.calendar_today,
                title: 'Create an itinerary',
                description: 'We’ll smartly organize your picks into a daily itinerary you can edit and add to.',
                onPressed: () => _buildAndNavigate(context),
              ),
              const SizedBox(height: 20),
              _buildOptionButton(
                icon: Icons.save,
                title: 'Just save for now',
                description: 'We’ll keep all your selections together in a trip you can review, organize, and create an itinerary later.',
                onPressed: () {
                  final Map<String, dynamic> jsonResponse = {
                    'hotels': selectedHotelIDs,
                    'restaurants': selectedRestaurantIDs,
                    'things_to_do': selectedThingsToDoIDs,
                  };

                  // Navigate to PlanScreen9
                  Get.to(() => PlanScreen9(
                        jsonResponse: jsonResponse,
                        action: 'Justsave',
                        UserId: authController.userId.value,
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buildAndNavigate(BuildContext context) async {
    // Show loading dialog
    _showLoadingDialog(context);

    try {
      // Call buildTripAI
      final result = await planScreenController.buildTripAI(
        duration: planScreenController.tripLength.value,
        hotelIds: selectedHotelIDs,
        thingToDoIds: selectedThingsToDoIDs,
        restaurantIds: selectedRestaurantIDs,
      );

      Navigator.pop(context); // Dismiss the loading dialog

      if (result['success']) {
        final jsonResponse = result['data'];
        // Navigate to PlanScreen7
        Get.to(() => PlanScreen7(
              UserId: authController.userId.value,
              jsonResponse: jsonResponse,
            ));
      } else {
        _showErrorSnackbar(context, result['message']);
      }
    } catch (e) {
      Navigator.pop(context); // Dismiss the loading dialog
      _showErrorSnackbar(context, e.toString());
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Row(
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Please wait for building trip"),
            ],
          ),
        );
      },
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message')),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade700,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
