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
        title: Text('Choose an Option'),
        backgroundColor: Colors.lightBlue.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(85, 131, 206, 241),
              const Color.fromARGB(33, 105, 175, 207)
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
              Text(
                'Continue planning your trip',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(211, 49, 201, 228),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Save your selections and get inspired with more guidance',
                style: TextStyle(
                  fontSize: 18,
                  color: const Color.fromARGB(225, 1, 36, 107),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              _buildOptionButton(
                context,
                icon: Icons.calendar_today,
                title: 'Create an itinerary',
                description: 'We’ll smartly organize your picks into a daily itinerary you can edit and add to.',
                onPressed: () async {
                  _buildAndNavigate(context);
                },
              ),
              SizedBox(height: 20),
              _buildOptionButton(
                context,
                icon: Icons.save,
                title: 'Just save for now',
                description:
                    'We’ll keep all your selections together in a trip you can review, organize, and create an itinerary later.',
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PlanScreen7(
                  //       UserId: profileScreenController.profileModelObj.value.id,
                  //       selectedHotelIDs: selectedHotelIDs,
                  //       selectedRestaurantIDs: selectedRestaurantIDs,
                  //       selectedThingsToDoIDs: selectedThingsToDoIDs,
                  //       action: 'Justsave',
                  //     ),
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buildAndNavigate(BuildContext context) async {
    // Hiển thị UI loading
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
      // Gọi hàm buildTripAI
      final result = await planScreenController.buildTripAI(
        duration: planScreenController.tripLength.value,
        hotelIds: selectedHotelIDs,
        thingToDoIds: selectedThingsToDoIDs,
        restaurantIds: selectedRestaurantIDs,
      );

      // Đóng dialog loading
      Navigator.pop(context);

      if (result['success']) {
        final jsonResponse = result['data'];
        print('Build Trip AI Result: $jsonResponse');

        // Điều hướng đến PlanScreen7
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanScreen7(
              jsonResponse: jsonResponse, // Truyền JSON vào đây
            ),
          ),
        );
      } else {
        // Hiển thị lỗi nếu build thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to build trip: ${result['message']}')),
        );
      }
    } catch (e) {
      // Đóng dialog loading
      Navigator.pop(context);

      // Hiển thị lỗi nếu có exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildOptionButton(BuildContext context,
      {required IconData icon, required String title, required String description, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade700,
        padding: EdgeInsets.all(16),
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
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
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
