import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'custom_bottom_nav_bar.dart';

class AppNavigation extends StatelessWidget {
  final HomeController controller;
  final Widget child;

  AppNavigation({required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation'), // Thêm tiêu đề cho AppBar
        backgroundColor: Colors.black, // Màu nền cho AppBar
      ),
      body: child,
      bottomNavigationBar: CustomBottomNavBar(controller: controller),
    );
  }
}
