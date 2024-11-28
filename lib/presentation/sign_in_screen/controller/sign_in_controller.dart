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

  // Tạo instance của GetStorage để lưu trữ dữ liệu
  final storage = GetStorage();

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

    // Lấy thông tin đăng nhập từ các controller
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    // Tạo mô hình đăng nhập
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
      ).timeout(Duration(seconds: 5));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        SignInResponseModel signInResponse = SignInResponseModel.fromJson(responseData);
        accessToken.value = signInResponse.accessToken!;

        // Lưu accessToken vào localStorage
        storage.write('accessToken', accessToken.value);

        // Chuyển hướng đến màn hình chính nếu đăng nhập thành công
        Get.toNamed(AppRoutes.welcomeScreen);
        Get.snackbar('Success', 'Logged in successfully!');
      } else {
        // Hiển thị lỗi nếu đăng nhập thất bại
        final responseData = json.decode(response.body);
        String errorDetail = responseData['detail'] ?? 'Failed to sign in';
        print('Login failed: Status Code: ${response.statusCode}, Response: $responseData');
        Get.snackbar('Error', errorDetail, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Exception caught: $e');
      Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Phương thức để lấy accessToken từ localStorage
  String? getStoredAccessToken() {
    return storage.read('accessToken');
  }

  // Phương thức đăng xuất và xóa dữ liệu
Future<void> logout() async {
  // Xóa token và dữ liệu lưu trữ
  storage.remove('accessToken');
  accessToken.value = '';

  // Reset ProfileController
  final profileController = Get.find<ProfileController>();
  profileController.resetProfile();

  // Điều hướng về màn hình đăng nhập
  Get.offAllNamed(AppRoutes.signInScreen);
}

}
