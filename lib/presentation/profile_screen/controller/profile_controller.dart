import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'dart:convert';
import 'package:travelappflutter/presentation/profile_screen/models/profile_model.dart';
import '/core/app_export.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel> profileModelObj = ProfileModel(
    id: 0,
    username: '',
    email: '',
    role: '',
    status: '',
    userInfo: UserInfo.empty()
  ).obs;

  // Sử dụng citiesMap để lưu các cặp (cityId: cityName)
  Map<int, String> citiesMap = {};
  Rx<int?> selectedCityId = Rx<int?>(null); // Để lưu cityId đã chọn
  RxBool isLoading = false.obs;
  RxBool isCitiesLoading = false.obs;
  final storage = GetStorage();
  Rx<String?> cityName = Rx<String?>(null);
  RxList<TravelDestination> likedDestinations = <TravelDestination>[].obs; // Observable for liked destinations

  // Controllers cho các trường địa chỉ
  TextEditingController streetController = TextEditingController();
  TextEditingController wardController = TextEditingController();
  TextEditingController districtController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    streetController.dispose();
    wardController.dispose();
    districtController.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
    fetchCities().whenComplete(() => fetchUserProfile());
    fetchUserProfile(); // Gọi fetchUserProfile 
  }

  // Lấy tên của thành phố từ cityId, nếu không tồn tại thì trả về "Unknown"
  String getCityName(int? cityId) => citiesMap[cityId] ?? "Unknown";

  // Khi nhận dữ liệu từ fetchUserProfile, thiết lập selectedCityId
  RxBool isProfileReady = false.obs; // Thêm trạng thái theo dõi hoàn thành

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    isProfileReady.value = false; // Đặt trạng thái chưa sẵn sàng

    String? accessToken = storage.read('accessToken');
    if (accessToken == null) {
      Get.snackbar('Error', 'Access token not found. Please log in again.');
      isLoading.value = false;
      return;
    }

    try {
      // Đảm bảo fetchCities trước khi tiếp tục
      await fetchCities();

      final response = await http.get(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/current-user'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        print('JSON Input to Model: $responseData');
        profileModelObj.value = ProfileModel.fromJson(responseData);

        // Đồng bộ selectedCityId với cityId từ userInfo
        selectedCityId.value = profileModelObj.value.userInfo?.address.cityId;

        // Đồng bộ các trường địa chỉ
        streetController.text = profileModelObj.value.userInfo?.address.street ?? '';
        wardController.text = profileModelObj.value.userInfo?.address.ward ?? '';
        districtController.text = profileModelObj.value.userInfo?.address.district ?? '';

        isProfileReady.value = true; // Đặt trạng thái hoàn thành
      } else {
        print('Failed to load profile: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load profile information');
      }
    } catch (e) {
      print('Exception caught: $e');
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCities() async {
    if (citiesMap.isNotEmpty) return; // Nếu đã có dữ liệu thì không cần gọi API

    isCitiesLoading.value = true; // Bắt đầu trạng thái loading
    try {
      final response = await http.get(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/'),
      );

      if (response.statusCode == 200) {
        // Parse JSON và lưu id, name
        final List<dynamic> cities = json.decode(utf8.decode(response.bodyBytes));
        citiesMap = {
          for (var city in cities)
            city['id'] as int: city['name'] as String,
        };
      } else {
        print('Failed to load cities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cities: $e');
    } finally {
      isCitiesLoading.value = false; // Kết thúc trạng thái loading
    }
  }
  void resetProfile() {
    // Reset ProfileModel về giá trị mặc định
    profileModelObj.value = ProfileModel(
      id: 0,
      username: '',
      email: '',
      role: '',
      status: '',
      userInfo: UserInfo.empty(),
    );

    // Reset các controller về trạng thái rỗng
    streetController.text = '';
    wardController.text = '';
    districtController.text = '';

    // Reset các biến liên quan
    selectedCityId.value = null;
    cityName.value = null;
    citiesMap.clear();

    print("Profile reset to default values.");
  }


  // Cập nhật thông tin địa chỉ từ các TextEditingController
  void updateAddressFromFields() {
    final currentUserInfo = profileModelObj.value.userInfo ?? UserInfo.empty();

    // Cập nhật address
    final updatedAddress = currentUserInfo.address.copyWith(
      street: streetController.text,
      ward: wardController.text,
      district: districtController.text,
    );

    // Cập nhật userInfo với address mới
    final updatedUserInfo = currentUserInfo.copyWith(address: updatedAddress);

    // Cập nhật ProfileModel với userInfo mới
    profileModelObj.value = profileModelObj.value.copyWith(userInfo: updatedUserInfo);
  }

  // Update user info via API
  Future<void> updateUserInfo(List<File> selectedImages) async {
    isLoading.value = true;
    String? accessToken = storage.read('accessToken');
    if (accessToken == null) {
      Get.snackbar('Error', 'Access token not found. Please log in again.');
      isLoading.value = false;
      return;
    }

    try {
      // Tạo URL với các query parameters từ các trường dữ liệu khác
      final uri = Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${profileModelObj.value.userInfo?.id}'
          '?description=${Uri.encodeComponent(profileModelObj.value.userInfo?.description ?? '')}'
          '&phone_number=${Uri.encodeComponent(profileModelObj.value.userInfo?.phoneNumber ?? '')}'
          '&district=${Uri.encodeComponent(profileModelObj.value.userInfo?.address.district ?? '')}'
          '&street=${Uri.encodeComponent(profileModelObj.value.userInfo?.address.street ?? '')}'
          '&ward=${Uri.encodeComponent(profileModelObj.value.userInfo?.address.ward ?? '')}'
          '&city_id=${profileModelObj.value.userInfo?.address.cityId}');

      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Thêm ảnh vào request nếu có ảnh được chọn
      if (selectedImages.isNotEmpty) {
        final file = selectedImages[0];
        request.files.add(
          await http.MultipartFile.fromPath('image_inp', file.path),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User info updated successfully.');
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody');
        final errorData = json.decode(responseBody);
        Get.snackbar('Error', 'Failed to update profile: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Exception caught: $e');
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchLikedDestinations(int userId) async {
    isLoading.value = true; // Start loading
    try {
      // Fetch liked destination IDs
      final likedIdsResponse = await http.get(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/$userId/likes'),
      );

      if (likedIdsResponse.statusCode == 200) {
        List<int> likedIds = List<int>.from(json.decode(utf8.decode(likedIdsResponse.bodyBytes)));
        
        // Fetch all destination details in parallel
        List<Future<TravelDestination?>> fetchTasks = likedIds.map((id) async {
          final response = await http.get(
            Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/$id'),
          );
          if (response.statusCode == 200) {
            return TravelDestination.fromJson(json.decode(utf8.decode(response.bodyBytes)));
          } else {
            return null; // Skip invalid destinations
          }
        }).toList();

        // Wait for all requests to complete
        List<TravelDestination> destinations = (await Future.wait(fetchTasks))
            .whereType<TravelDestination>() // Filter out null values
            .toList();

        likedDestinations.value = destinations; // Update the liked destinations
      } else {
        print('Failed to fetch liked IDs: ${likedIdsResponse.body}');
      }
    } catch (e) {
      print('Error fetching liked destinations: $e');
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

}
