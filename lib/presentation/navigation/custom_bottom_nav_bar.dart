import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final HomeController controller;

  const CustomBottomNavBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Access ProfileController to get the role directly without re-instantiation
    final profileController = Get.find<ProfileController>();
    print("Role: " + profileController.profileModelObj.value.role);
    return Obx(() => Material(
          borderRadius: BorderRadius.only(
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
              const BottomNavigationBarItem(
                  icon: Icon(Icons.domain_add_outlined),
                  label: 'Destination'),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bookmark_outline),
                // Show "AI Trip" or "Business" based on the role in ProfileController
                label: profileController.profileModelObj.value.role == 'business'
                    ? 'Business'
                    : 'AI Trip',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
            currentIndex: controller.selectedPage.value,
            onTap: (index) {
              controller.changePage(index);

              // Navigate based on selected index and role
              switch (index) {
                case 0:
                  Get.toNamed('/welcome_screen');
                  break;
                case 1:
                  Get.toNamed('/search_screen');
                  break;
                case 2:
                  Get.toNamed('/business_creation_screen');
                  break;
                case 3:
                  Get.toNamed(profileController.profileModelObj.value.role == 'business'
                      ? '/business_screen'
                      : '/plan_screen');
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
