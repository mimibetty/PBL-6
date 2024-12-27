import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';
import '/core/app_export.dart';
import 'package:travelappflutter/presentation/sign_in_screen/models/sign_in_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class SignInController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  Rx<SignInModel> signInModelObj = SignInModel().obs;
  var isLoading = false.obs;
  var accessToken = ''.obs;
  var userRole = ''.obs; // Variable to store the user's role

  final storage = GetStorage();

  @override
  void onReady() {
    super.onReady();
  }

  // @override
  // void onClose() {
  //   super.onClose();
    // usernameController.dispose();
    // passwordController.dispose();
  // }

  Future<void> signIn() async {
    isLoading.value = true;

    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    signInModelObj.value = SignInModel(username: username, password: password);

    try {
      final response = await http.post(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': signInModelObj.value.username,
          'password': signInModelObj.value.password,
        },
      ).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        SignInResponseModel signInResponse = SignInResponseModel.fromJson(responseData);
        accessToken.value = signInResponse.accessToken!;

        storage.write('accessToken', accessToken.value);

        await fetchUserRole();

        Get.toNamed(AppRoutes.welcomeScreen);
        Get.snackbar('Success', 'Logged in successfully!');
      } else {
        final responseData = json.decode(response.body);
        String errorDetail = responseData['detail'] ?? 'Failed to sign in';
        Get.snackbar('Error', errorDetail, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserRole() async {
    try {
      final response = await http.get(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/current-user'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        userRole.value = responseData['role'] ?? 'unknown';

        storage.write('userRole', userRole.value);
      } else {
        Get.snackbar('Error', 'Failed to fetch user role', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  String? getStoredAccessToken() {
    return storage.read('accessToken');
  }

  String? getStoredUserRole() {
    return storage.read('userRole');
  }

  Future<void> logout() async {
    storage.remove('accessToken');
    storage.remove('userRole');
    accessToken.value = '';
    userRole.value = '';

    final profileController = Get.find<ProfileController>();
    profileController.resetProfile();

    Get.offAllNamed(AppRoutes.signInScreen);
  }
}
