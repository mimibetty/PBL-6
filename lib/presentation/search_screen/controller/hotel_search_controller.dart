import 'package:get/get.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelController extends GetxController {
  RxList<Hotel> hotels = <Hotel>[].obs; // Change to RxList<Hotel>
  var isLoading = false.obs; // Loading state

  final String apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/';

  Future<void> fetchHotelData(String hotelID) async {
    isLoading.value = true;

    try {
      final response = await http.get(Uri.parse('$apiUrl$hotelID'));

      if (response.statusCode == 200) {
        // Parse the API response
        Map<String, dynamic> apiData = json.decode(utf8.decode(response.bodyBytes));

        // Create a new Hotel object
        Hotel newHotel = Hotel.fromApi(apiData);
        hotels.add(newHotel); // Add to the hotels list
      } else {
        Get.snackbar("Error", "Failed to load hotel data");
        print('Failed to load hotel data. Status code: ${response.statusCode}');
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
