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
    userInfo: UserInfo.empty()
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

  isCitiesLoading.value = true;
  try {
    final response = await http.get(
      Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/'),
    );

    if (response.statusCode == 200) {
      final cities = json.decode(utf8.decode(response.bodyBytes)) as List;
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

  // Method to parse address from formatted string "Street, Ward, District"
void updateAddressFromString(String addressInput) {
  final parts = addressInput.split(',').map((e) => e.trim()).toList();
  if (parts.length == 3) {
    // Lấy thông tin userInfo hiện tại
    final currentUserInfo = profileModelObj.value.userInfo ?? UserInfo.empty();

    // Cập nhật address
    final updatedAddress = currentUserInfo.address.copyWith(
      street: parts[0],
      ward: parts[1],
      district: parts[2],
    );

    // Cập nhật userInfo với address mới
    final updatedUserInfo = currentUserInfo.copyWith(address: updatedAddress);

    // Cập nhật ProfileModel với userInfo mới
    profileModelObj.value = profileModelObj.value.copyWith(userInfo: updatedUserInfo);
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
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/userInfo/${profileModelObj.value.userInfo?.id}'
          '?description=${Uri.encodeComponent(profileModelObj.value.userInfo?.description ?? '')}'
          '&phone_number=${Uri.encodeComponent(profileModelObj.value.userInfo?.phoneNumber ?? '')}'
          '&district=${Uri.encodeComponent(profileModelObj.value.userInfo?.address.district ?? '')}'
          '&street=${Uri.encodeComponent(profileModelObj.value.userInfo?.address.street ?? '')}'
          '&ward=${Uri.encodeComponent(profileModelObj.value.userInfo?.address.ward ?? '')}'
          '&city_id=${profileModelObj.value.userInfo?.address.cityId}');
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
  void resetProfile() {
    // Reset ProfileModel về giá trị mặc định
    profileModelObj.value = ProfileModel(
      id: 0, // ID mặc định
      username: '', // Xóa tên đăng nhập
      email: '', // Xóa email
      role: '', // Xóa role
      status: '', // Xóa trạng thái
      userInfo: UserInfo.empty(), // Đặt UserInfo về trạng thái mặc định
    );

    // Reset các biến liên quan
    selectedCityId.value = null; // Xóa CityId đã chọn
    cityName.value = null; // Xóa tên thành phố
    citiesMap.clear(); // Xóa toàn bộ dữ liệu thành phố

    print("Profile reset to default values.");
  }


}
