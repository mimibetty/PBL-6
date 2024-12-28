import 'package:flutter/material.dart';
import 'custom_bottom_nav_bar.dart';

class AppNavigation extends StatelessWidget {
  final Widget child;

  AppNavigation({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation'),
        backgroundColor: Colors.black,
      ),
      body: child,
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
