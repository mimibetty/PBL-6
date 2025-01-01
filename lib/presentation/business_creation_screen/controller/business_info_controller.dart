import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';

class BusinessInfoController extends GetxController {
  Rx<Business> business = Business.empty().obs; // Khởi tạo business mặc định
  RxBool isLoading = false.obs;
  final storage = GetStorage();

  @override
  void onReady() {
    super.onReady();
    fetchBusinessProfile(); // Gọi API để lấy thông tin business
  }

Future<void> fetchBusinessProfile() async {
  isLoading.value = true; // Start loading
  String? accessToken = storage.read('accessToken'); // Get access token

  if (accessToken == null) {
    Get.snackbar('Error', 'Access token not found. Please log in again.');
    isLoading.value = false;
    return;
  }

  try {
    // Fetch Business Profile
    final profileResponse = await http.get(
      Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/current-user'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (profileResponse.statusCode == 200) {
      final profileData = json.decode(utf8.decode(profileResponse.bodyBytes));
      print('Profile JSON: $profileData');

      Business newBusiness = Business.fromJson(profileData);

      // Fetch destinations using user_id from the profile
      final userId = profileData['id'];
      final destinationResponse = await http.get(
        Uri.parse(
            'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?user_id=$userId&page_size=10'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (destinationResponse.statusCode == 200) {
        final destinationData =
            List<Map<String, dynamic>>.from(json.decode(utf8.decode(destinationResponse.bodyBytes)));
        print('Destination JSON: $destinationData');

        // Extract up to 4 unique image URLs
        List<String> extractedImages = [];
        for (var destination in destinationData) {
          final images = destination['images'] ?? [];
          for (var image in images) {
            if (extractedImages.length < 4) {
              extractedImages.add(image['url']);
            } else {
              break;
            }
          }
          if (extractedImages.length >= 4) break;
        }

        // Update Business object with extracted images
        newBusiness = newBusiness.copyWith(
          images: extractedImages.isNotEmpty ? extractedImages : newBusiness.images,
        );
      } else {
        print('Failed to fetch destinations: ${destinationResponse.statusCode}');
      }

      // Update business observable
      business.value = newBusiness;
      print('Updated Business: ${business.value}');
    } else {
      print('Failed to load business profile: ${profileResponse.statusCode}');
      Get.snackbar('Error', 'Failed to load business profile.');
    }
  } catch (e) {
    print('Exception caught: $e');
    Get.snackbar('Error', 'Something went wrong: $e');
  } finally {
    isLoading.value = false; // Stop loading
  }
}

  void resetBusiness() {
    // Đặt lại Business về giá trị mặc định
    business.value = Business.empty();
    print("Business reset to default values.");
  }
}
