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

        // Check if the hotel already exists in the list
        if (!hotels.any((hotel) => hotel.hotelID == newHotel.hotelID)) {
          hotels.add(newHotel); // Add to the hotels list
        } else {
          print('Hotel already exists in the list: ${newHotel.hotelName}');
        }
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


  void sortHotels(String criteria, {bool ascending = true}) {
    var sortedList = [...hotels]; // Clone the original list
    sortedList.sort((a, b) {
      switch (criteria) {
        case 'Name':
          return ascending
              ? a.hotelName.compareTo(b.hotelName)
              : b.hotelName.compareTo(a.hotelName);
        case 'Review Count':
          return ascending
              ? a.reviewCount.compareTo(b.reviewCount)
              : b.reviewCount.compareTo(a.reviewCount);
        case 'Rating':
          return ascending
              ? a.rating.compareTo(b.rating)
              : b.rating.compareTo(a.rating);
        default:
          return 0;
      }
    });
    hotels.value = sortedList; // Update the observable list
  }

  Future<void> filterHotels(String filters, int cityId) async {
    print("Filters applied: $filters");

    // Parse filters into a map
    Map<String, String> queryParameters = {};
    filters.split(',').forEach((filter) {
      List<String> parts = filter.split(':').map((e) => e.trim()).toList();
      if (parts.length == 2) {
        String key = parts[0].toLowerCase().replaceAll(' ', '_'); // Convert to snake_case
        String value = parts[1].trim(); // Không chỉnh sửa giá trị trước khi xử lý

        if (key == 'price_range') {
          value = value.toLowerCase(); // Price Range chuyển thành lowercase
        } else if (key == 'star') {
          key = 'hotel_star'; // Đổi tên thành hotel_star
          value = value.split(' ')[0]; // Lấy số, bỏ từ "Star"
        }
        queryParameters[key] = value;
      }
    });

    // Add city_id as a dynamic parameter
    queryParameters['city_id'] = cityId.toString();
    queryParameters['is_popular'] = 'true';

    // Build the final URL with query parameters
    Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParameters);

    print("API URL: $uri");

    isLoading.value = true;
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse and update hotels list
        List<dynamic> apiData = json.decode(utf8.decode(response.bodyBytes));
        hotels.value = apiData
            .map((data) => Hotel.fromApi(data))
            .toList()
            .toSet() // Remove duplicates
            .toList();
        print("Hotels fetched successfully.");
      } else {
        Get.snackbar("Error", "Failed to fetch hotels");
        print('Failed to fetch hotels. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      print('Error: $e');
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
