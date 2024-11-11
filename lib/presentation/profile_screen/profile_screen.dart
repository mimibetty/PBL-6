import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/profile_screen/preferences_screen.dart';

import '../sign_in_screen/sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  void _signOut(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }
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
              backgroundImage: AssetImage('assets/profile_image.jpg'), // Đặt đường dẫn ảnh avatar
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
          controller: HomeController()),
    );
  }
}
