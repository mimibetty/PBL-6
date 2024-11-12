import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/sign_up_screen/models/sign_up_model.dart';

class SignUpController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Rx<SignUpModel> signUpModelObj = SignUpModel().obs;
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final String apiUrl = "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/";

  @override
  void onClose() {
    super.onClose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

    bool isValidEmail(String value, {bool isRequired = false}) {
      if (isRequired && value.isEmpty) {
        return false;
      }
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      return emailRegex.hasMatch(value);
    }


  Future<void> signUp() async {
    if (usernameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    final userData = {
      "email": emailController.text,
      "password": passwordController.text,
      "username": usernameController.text,
    };

    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Registration successful");
      } else {
        Get.snackbar("Error", "Failed to register: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
