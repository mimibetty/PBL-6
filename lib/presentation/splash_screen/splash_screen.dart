import 'controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:travelappflutter/core/app_export.dart';

class SplashScreen extends GetWidget<SplashController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // Nền trắng
        body: Center( // Đặt logo ở giữa
          child: AnimatedSplashImage(), // Thêm animation vào hình ảnh
        ),
      ),
    );
  }
}

class AnimatedSplashImage extends StatefulWidget {
  @override
  _AnimatedSplashImageState createState() => _AnimatedSplashImageState();
}

class _AnimatedSplashImageState extends State<AnimatedSplashImage> {
  double _opacity = 0.0; // Độ mờ ban đầu

  @override
  void initState() {
    super.initState();
    _startFadeAnimation();
  }

  void _startFadeAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200)); // Đợi 300ms
    setState(() {
      _opacity = 1.0; // Tăng độ mờ
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(seconds: 2), // Thời gian hiệu ứng fade-in
      opacity: _opacity,
      child: Image.asset(
        'assets/images/splash_art.png', // Thay bằng đường dẫn hình của bạn
        width: 200, // Chiều rộng hình
        height: 200, // Chiều cao hình
        fit: BoxFit.contain,
      ),
    );
  }
}
