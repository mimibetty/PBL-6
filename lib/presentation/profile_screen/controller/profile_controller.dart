import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
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
    name: '',
    contactNumber: '',
    description: '',
    imageUrl: '',
    address: Address(
      street: '',
      district: '',
      ward: '',
      cityId: 0,
    ),
  ).obs;

  // Sử dụng citiesMap để lưu các cặp (cityId: cityName)
  Map<int, String> citiesMap = {};
  Rx<int?> selectedCityId = Rx<int?>(null); // Để lưu cityId đã chọn
  RxBool isLoading = false.obs;
  RxBool isCitiesLoading = false.obs;
  final storage = GetStorage();
  Rx<String?> cityName = Rx<String?>(null);
  
  @override
  void onInit() {
    super.onInit();
    
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
Future<void> fetchUserProfile() async {
    isLoading.value = true;
    String? accessToken = storage.read('accessToken');
    if (accessToken == null) {
      Get.snackbar('Error', 'Access token not found. Please log in again.');
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/current-user'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        profileModelObj.value = ProfileModel.fromJson(responseData);

        // Fetch city name based on cityId
        fetchCityName(profileModelObj.value.address.cityId);
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
    // Fetch city data và lưu vào citiesMap
    Future<void> fetchCities() async {
      isCitiesLoading.value = true;
      try {
        final response = await http.get(
          Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/'),
        );

        if (response.statusCode == 200) {
          final cities = json.decode(utf8.decode(response.bodyBytes)) as List;
          // Only save the 'id' and 'name' in citiesMap
          citiesMap = {
            for (var city in cities) city['id'] as int: city['name'] as String,
          };
        } else {
          print('Failed to load cities: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching cities: $e');
      } finally {
        isCitiesLoading.value = false;
      }
    }

  Future<void> fetchCityName(int cityId) async {
    try {
      final response = await http.get(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/$cityId'),
      );

      if (response.statusCode == 200) {
        final cityData = json.decode(utf8.decode(response.bodyBytes));
        cityName.value = cityData['name'] ?? '';
        print("City name: ${cityName.value}");
      } else {
        print('Failed to fetch city name: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to fetch city name');
      }
    } catch (e) {
      print('Error fetching city name: $e');
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Method to parse address from formatted string "Street, Ward, District"
  void updateAddressFromString(String addressInput) {
    final parts = addressInput.split(',').map((e) => e.trim()).toList();
    if (parts.length == 3) {
      profileModelObj.value = profileModelObj.value.copyWith(
        address: Address(
          street: parts[0],
          ward: parts[1],
          district: parts[2],
          cityId: profileModelObj.value.address.cityId, // retain the existing cityId
        ),
      );
    } else {
      Get.snackbar('Error', 'Please enter address in the format "Street, Ward, District"');
    }
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
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${profileModelObj.value.id - 3}'
          '?description=${Uri.encodeComponent(profileModelObj.value.description ?? '')}'
          '&phone_number=${Uri.encodeComponent(profileModelObj.value.contactNumber ?? '')}'
          '&district=${Uri.encodeComponent(profileModelObj.value.address.district ?? '')}'
          '&street=${Uri.encodeComponent(profileModelObj.value.address.street ?? '')}'
          '&ward=${Uri.encodeComponent(profileModelObj.value.address.ward ?? '')}'
          '&city_id=${profileModelObj.value.address.cityId}');
      // Print the full URI with parameters
      print('Request URI: $uri');

      // Tạo một yêu cầu MultipartRequest
      final request = http.MultipartRequest('PUT', uri);

      // Thêm header
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Thêm ảnh vào request nếu có ảnh được chọn
      if (selectedImages.isNotEmpty) {
        final file = selectedImages[0];
        print('Image File Path: ${file.path}'); // Ensure the file path is valid
        request.files.add(
          await http.MultipartFile.fromPath('image_inp', file.path),
        );
      } else {
        print('No image selected for upload.');
      }
      // Log the request fields and files
      print('Request Headers: ${request.headers}');
      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files}');

      // Gửi yêu cầu và xử lý phản hồi
      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'User info updated successfully.');
      } else {
        print('Failed to update profile: Status Code ${response.statusCode}');
        print('Response Headers: ${response.headers}');
        final responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody');

        // Decode response body nếu có lỗi
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

}
