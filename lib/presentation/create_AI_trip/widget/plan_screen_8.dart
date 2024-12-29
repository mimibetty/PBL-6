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
  @override
Widget build(BuildContext context) {
  // Debug: Print the IDs of selected destinations
  print('Selected Hotel IDs: $selectedHotelIDs');
  print('Selected Restaurant IDs: $selectedRestaurantIDs');
  print('Selected ThingsToDo IDs: $selectedThingsToDoIDs');


  return Scaffold(
    appBar: AppBar(
      title: Text(
        'Plan Your Trip',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.blue,
      elevation: 0,
      centerTitle: true,
    ),
    body: Container(
      decoration: BoxDecoration(
        color: Colors.grey[100], // Main background color
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ai_trip_icon.png', // Illustration image
              height: 150,
            ),
            SizedBox(height: 80),
            Text(
              'Let’s Plan Your Dream Trip',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF13357B),
                shadows: [
                  Shadow(
                    offset: Offset(0, 3),
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Save your selections and get inspired with more guidance',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildOptionButton(
              icon: Icons.calendar_today,
              title: 'Create an Itinerary',
              description:
                  'We’ll smartly organize your picks into a daily itinerary you can edit and add to.',
              backgroundColor: Color(0xFF13357B),
              textColor: Colors.white,
              onPressed: () async {
                _buildAndNavigate(context);
              },
            ),
            const SizedBox(height: 20),
            _buildOptionButton(
              icon: Icons.save,
              title: 'Just save for now',
              description:
                  'We’ll keep all your selections together in a trip you can review, organize, and create an itinerary later.',
              backgroundColor: Colors.black,
              textColor: Colors.white,
              onPressed: () {
                final Map<String, dynamic> jsonResponse = {
                  'hotels': selectedHotelIDs,
                  'restaurants': selectedRestaurantIDs,
                  'things_to_do': selectedThingsToDoIDs,
                };

                // Debug: Print the JSON payload
                print('JSON Payload: $jsonResponse');

                // Navigate to PlanScreen9
                Get.to(() => PlanScreen9(
                      jsonResponse: jsonResponse,
                      action: 'Justsave',
                      UserId: Get.find<AuthController>().userId.value,
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
      SnackBar(content: Text('Error khi bấm save nè: $message')),
    );
  }

  Widget _buildOptionButton(
     {
    required IconData icon,
    required String title,
    required String description,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Ink(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 40, color: textColor),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
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
