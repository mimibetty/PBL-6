import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/sign_in_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final HomeController controller;

  const CustomBottomNavBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final signInController = Get.find<SignInController>();
    // Gọi fetchUserProfile nếu dữ liệu chưa sẵn sàng
    // if (!profileController.isLoading.value) {
    //   profileController.fetchUserProfile();
    // }
    print("Role: " + signInController.userRole.value);

    return Obx(() => Material(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: BottomNavigationBar(
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
              // Dynamic icon and label based on role
              BottomNavigationBarItem(
                icon: signInController.userRole.value == 'guest'
                    ? const Icon(Icons.computer) // Icon for AI Trip
                    : const Icon(Icons.domain_add_outlined), // Icon for Destination
                label: signInController.userRole.value == 'guest'
                    ? 'AI Trip'
                    : 'Destination',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_outline), label: 'Forum'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
            currentIndex: controller.selectedPage.value,
            onTap: (index) {
              controller.changePage(index);

              // Handle navigation based on selected index and role
              switch (index) {
                case 0:
                  Get.toNamed('/welcome_screen');
                  break;
                case 1:
                  Get.toNamed('/search_screen');
                  break;
                case 2:
                  if (signInController.userRole.value == 'guest') {
                    Get.toNamed('/plan_screen'); // Navigate to AI Trip
                  } else {
                    Get.toNamed('/business_creation_screen'); // Navigate to Destination
                  }
                  break;
                case 3:
                  Get.toNamed('/saved_screen');
                  break;
                case 4:
                  Get.toNamed('/profile_screen');
                  break;
                default:
                  Get.toNamed('/welcome_screen');
              }
            },
          ),
        ));
  }
}
