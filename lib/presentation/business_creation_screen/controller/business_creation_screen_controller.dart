import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';

class BusinessCreationController extends GetxController {
  var selectedPage = 0.obs; // Track selected tab/page
  RxList<TravelDestination> destinations = <TravelDestination>[].obs; // Destination data
  RxBool isLoading = false.obs; // Loading state
  final int userId = Get.find<AuthController>().userId.value;

  final String baseUrl =
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/';
 

  @override
  void onInit() {
    super.onInit();

    // Initialize selected page if passed as an argument
    var initialPage = Get.arguments?['selectedPage'] ?? 0;
    selectedPage.value = initialPage;

    // Fetch destinations on initialization
    fetchDestinations();
  }

  void changePage(int index) {
    selectedPage.value = index;
  }

  Future<void> fetchDestinations({int limit = 15, int pageSize = 10}) async {
    isLoading.value = true; // Set loading state to true

    try {
      // Fetch the user ID from the profile controller
      final int userId = Get.find<AuthController>().userId.value;
      final Uri url = Uri.parse('$baseUrl?user_id=$userId&limit=$limit&page_size=$pageSize');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        destinations.value = jsonResponse
            .map((data) => TravelDestination.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        // Display error snackbar for non-200 responses
        Get.snackbar('Error', 'Failed to load destinations: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors gracefully
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false; // Reset loading state
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  
}
