import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:travelappflutter/presentation/navigation/controller/app_navigation_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelappflutter/presentation/profile_screen/trip.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/sign_in_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final AppController appController = Get.put(AppController());
  final GetStorage storage = GetStorage(); // Sử dụng GetStorage để lấy userRole

  @override
  Widget build(BuildContext context) {
    String? userRole = storage.read('userRole') ?? 'guest'; // Lấy userRole từ Storage
    print("User role: $userRole");

    return Obx(() => Material(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: BottomNavigationBar(
            currentIndex: appController.currentIndex.value, // Lấy từ controller
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            type: BottomNavigationBarType.fixed,
            iconSize: 28.0,
            elevation: 8.0,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontSize: 12.0),
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Iconsax.home1), label: 'Home'),
              const BottomNavigationBarItem(
                  icon: Icon(Iconsax.search_normal), label: 'Search'),
              BottomNavigationBarItem(
                icon: userRole == 'guest'
                    ? const Icon(Icons.computer) // Icon for AI Trip
                    : const Icon(
                        Icons.domain_add_outlined), // Icon for Destination
                label: userRole == 'guest' ? 'AI Trip' : 'Destination',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_outline), label: 'My Trips'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
            onTap: (index) {
              // Cập nhật trạng thái thông qua controller
              appController.changePage(index);

              // Điều hướng dựa trên index
              switch (index) {
                case 0:
                  Get.toNamed('/welcome_screen');
                  break;
                case 1:
                  Get.toNamed('/search_screen');
                  break;
                case 2:
                  if (userRole == 'guest') {
                    Get.toNamed('/plan_screen'); // Navigate to AI Trip
                  } else {
                    Get.toNamed('/business_creation_screen', arguments: {
                      "businessId": "3"
                    }); // Navigate to Destination
                  }
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyTripsScreen()),
                  );

                  break;
                case 4:
                  Get.toNamed('/profile_screen');
                  break;
              }
            },
          ),
        ));
  }
}
