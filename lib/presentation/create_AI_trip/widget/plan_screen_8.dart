import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_7.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';

class PlanScreen8 extends StatelessWidget {
  final List<int> selectedHotelIDs;
  final List<int> selectedRestaurantIDs;
  final List<int> selectedThingsToDoIDs;

  PlanScreen8({
    required this.selectedHotelIDs,
    required this.selectedRestaurantIDs,
    required this.selectedThingsToDoIDs,
  });

  final ProfileController profileScreenController = Get.put(ProfileController());
  final PlanScreenController planScreenController = Get.find<PlanScreenController>();

  @override
  Widget build(BuildContext context) {
    profileScreenController.fetchUserProfile();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Your Trip',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100], // Nền chính màu trắng
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ai_trip_icon.png', // Thêm hình minh họa
                height: 150,
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 12),
              Text(
                'We’ll help you organize your picks into a perfect itinerary or save them for later.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildOptionButton(
                context,
                icon: Icons.calendar_today,
                title: 'Create an Itinerary',
                description: 'Smartly organize your picks into a daily schedule.',
                backgroundColor: Color(0xFF13357B),
                textColor: Colors.white,
                onPressed: () async {
                  _buildAndNavigate(context);
                },
              ),
              SizedBox(height: 20),
              _buildOptionButton(
                context,
                icon: Icons.save,
                title: 'Save for Later',
                description: 'Keep all your selections and revisit them anytime.',
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  // Add your save functionality here
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buildAndNavigate(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Please wait for building trip"),
            ],
          ),
        );
      },
    );

    try {
      final result = await planScreenController.buildTripAI(
        duration: planScreenController.tripLength.value,
        hotelIds: selectedHotelIDs,
        thingToDoIds: selectedThingsToDoIDs,
        restaurantIds: selectedRestaurantIDs,
      );

      Navigator.pop(context);

      if (result['success']) {
        final jsonResponse = result['data'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanScreen7(jsonResponse: jsonResponse),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to build trip: ${result['message']}')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildOptionButton(
    BuildContext context, {
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
