import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/profile_screen/account_info_screen.dart';
import 'package:travelappflutter/presentation/profile_screen/change_pw_screen.dart';
import 'package:travelappflutter/presentation/profile_screen/language_selection_screen.dart';

class PreferencesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences Page'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: Text(
              'Preferences',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          // Account Info
          ListTile(
            title: Text(
              'Account Info',
              style: TextStyle(fontSize: 18),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountInfoScreen()),
              );
            },
          ),
          Divider(),
          // Language
          ListTile(
            title: Text(
              'Language',
              style: TextStyle(fontSize: 18),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('English(Vietnam)'),
                Icon(Icons.chevron_right),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LanguageSelectionScreen()),
              );
            },
          ),
          Divider(),
          // Currency
          // ListTile(
          //   title: Text(
          //     'Currency',
          //     style: TextStyle(fontSize: 18),
          //   ),
          //   trailing: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Text('Vietnamese Dong'),
          //       Icon(Icons.chevron_right),
          //     ],
          //   ),
          // ),
          // Divider(),
          // // Units
         

          ListTile(
            title: Text(
              'Notifications',
              style: TextStyle(fontSize: 18),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Change Password',
              style: TextStyle(fontSize: 18),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),
          Divider(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
