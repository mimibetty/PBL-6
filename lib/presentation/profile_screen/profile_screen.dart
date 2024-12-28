import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/profile_screen/favourites.dart'
    as favourites;
import 'package:travelappflutter/presentation/profile_screen/preferences_screen.dart';
import 'package:travelappflutter/presentation/profile_screen/reviews.dart';
import 'package:travelappflutter/presentation/profile_screen/trip.dart';
import 'package:travelappflutter/presentation/search_screen/controller/things_to_do_controller.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/sign_in_controller.dart';

import '../sign_in_screen/sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  void _signOut(BuildContext context) async {
    // Gọi hàm logout từ ProfileController
    final signInController = Get.find<SignInController>();
    await signInController.logout();

    // Điều hướng tới màn hình đăng nhập
    Get.offAll(() => SignInScreen());
  }

  final ThingsToDoController thingsToDoController =
      Get.put(ThingsToDoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Profile
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/profile_image.jpg'), // Đặt đường dẫn ảnh avatar
            ),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),

          // Rewards Section
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Rewards',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          ListTile(
            leading: Icon(Icons.monetization_on, color: Colors.amber),
            title: Text('Rewards'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.trip_origin_sharp,
              color: const Color.fromARGB(255, 3, 161, 240),
            ),
            title: Text('Trips'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyTripsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.reviews,
              color: Colors.grey,
            ),
            title: Text('Reviews'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Review()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.redAccent,
            ),
            title: Text('Favourite'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => favourites.FavouriteScreen()),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.local_offer_outlined),
            title: Text('Offers'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),

          // Settings Section
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Preferences'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreferencesPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Support'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),

          // Sign Out
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: GestureDetector(
                onTap: () => _signOut(context), // Gọi hàm đăng xuất khi nhấn
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
