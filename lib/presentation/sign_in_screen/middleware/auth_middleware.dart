import 'package:flutter/material.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // Nếu chưa đăng nhập, điều hướng đến màn hình đăng nhập
    if (!authController.isLoggedIn) {
      return RouteSettings(name: AppRoutes.signInScreen);
    }
    return null;
  }
}
