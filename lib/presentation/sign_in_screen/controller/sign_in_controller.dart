import '/core/app_export.dart';
import 'package:travelappflutter/presentation/sign_in_screen/models/sign_in_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isPasswordVisible = false.obs;

  Rx<SignInModel> signInModelObj = SignInModel().obs;
  var isLoading = false.obs;
  var accessToken = ''.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    usernameController.dispose();
    passwordController.dispose();
  }

  Future<void> signIn() async {
  isLoading.value = true;

  // Get the input from the controllers
  String username = usernameController.text.trim();
  String password = passwordController.text.trim();

  // Create a login model
  signInModelObj.value = SignInModel(username: username, password: password);

  try {
    print("trytopostlogin");
    final response = await http.post(
      Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'username': signInModelObj.value.username,
        'password': signInModelObj.value.password,
      },
    );


    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      
      SignInResponseModel signInResponse = SignInResponseModel.fromJson(responseData);
      accessToken.value = signInResponse.accessToken!;

      // Navigate to the home screen if login is successful
      Get.offNamed(AppRoutes.welcomeScreen); 
      Get.snackbar('Success', 'Logged in successfully!');
    } else {
      // Display error details if login fails
      final responseData = json.decode(response.body);
      String errorDetail = responseData['detail'] ?? 'Failed to sign in';
      // Log chi tiết lỗi ra console
      print('Login failed: Status Code: ${response.statusCode}, Response: $responseData');
      Get.snackbar('Error', errorDetail, snackPosition: SnackPosition.BOTTOM);
    }
  } catch (e) {
    Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
  } finally {
    isLoading.value = false;
  }
  }
}
