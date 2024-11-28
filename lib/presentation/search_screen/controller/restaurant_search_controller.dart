import 'package:get/get.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantController extends GetxController {
  RxList<Restaurant> restaurants = <Restaurant>[].obs; // RxList for reactive state management
  var isLoading = false.obs; // Loading state

  final String apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/';

  Future<void> fetchRestaurantData(String restaurantID) async {
    isLoading.value = true;

    try {
      final response = await http.get(Uri.parse('$apiUrl$restaurantID'));

      if (response.statusCode == 200) {
        // Parse the API response
        Map<String, dynamic> apiData = json.decode(utf8.decode(response.bodyBytes));

        // Create a new Restaurant object
        Restaurant newRestaurant = Restaurant.fromApi(apiData);
        restaurants.add(newRestaurant); // Add to the restaurants list
      } else {
        Get.snackbar("Error", "Failed to load restaurant data");
        print('Failed to load restaurant data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching data: $e");
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
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
