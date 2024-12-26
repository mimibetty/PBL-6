import 'package:get/get.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantController extends GetxController {
  RxList<Restaurant> restaurants = <Restaurant>[].obs; // RxList for reactive state management
  var isLoading = false.obs; // Loading state

  final String apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/';

  // Fetch a single restaurant's data by its ID
  Future<void> fetchRestaurantData(String restaurantID) async {
    isLoading.value = true;

    try {
      final response = await http.get(Uri.parse('$apiUrl$restaurantID'));

      if (response.statusCode == 200) {
        Map<String, dynamic> apiData = json.decode(utf8.decode(response.bodyBytes));

        // Create a new Restaurant object and add to the list only if it's not a duplicate
        Restaurant newRestaurant = Restaurant.fromApi(apiData);
        if (!restaurants.any((restaurant) => restaurant.restaurantID == newRestaurant.restaurantID)) {
          restaurants.add(newRestaurant);
        } else {
          print('Restaurant already exists in the list: ${newRestaurant.restaurantName}');
        }
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

  // Sort restaurants based on criteria
  void sortRestaurants(String criteria, {bool ascending = true}) {
    var sortedList = [...restaurants]; // Clone the list
    sortedList.sort((a, b) {
      switch (criteria) {
        case 'Name':
          return ascending
              ? a.restaurantName.compareTo(b.restaurantName)
              : b.restaurantName.compareTo(a.restaurantName);
        case 'Rating':
          return ascending
              ? a.rating.compareTo(b.rating)
              : b.rating.compareTo(a.rating);
        case 'Review Count':
          return ascending
              ? a.review.compareTo(b.review)
              : b.review.compareTo(a.review);
        default:
          return 0;
      }
    });

    restaurants.value = sortedList; // Update the reactive list
    print("\nRestaurants sorted by $criteria (${ascending ? 'ascending' : 'descending'})");
    for (var restaurant in restaurants) {
      print("Name: ${restaurant.restaurantName}, Rating: ${restaurant.rating}, Review Count: ${restaurant.review}");
    }
  }

  // Filter restaurants based on various criteria
  Future<void> filterRestaurants(String filters, int cityId) async {
    print("Filters applied: $filters");

    // Parse filters into a map
    Map<String, String> queryParameters = {};
    filters.split(',').forEach((filter) {
      List<String> parts = filter.split(':').map((e) => e.trim()).toList();
      if (parts.length == 2) {
        String key = parts[0].toLowerCase().replaceAll(' ', '_'); // Convert to snake_case
        String value = parts[1].trim();

        if (key == 'special_diets' || key == 'cuisines' || key == 'features' || key == 'meals') {
          value = value.split(' ').map((e) => e.trim()).join(','); // Join multiple values if needed
        }

        queryParameters[key] = value;
        print("Key: $key, Value: $value");
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
        List<dynamic> apiData = json.decode(utf8.decode(response.bodyBytes));
        restaurants.value = apiData
            .map((data) => Restaurant.fromApi(data))
            .toList()
            .toSet()
            .toList(); // Remove duplicates
        print("Restaurants fetched successfully.");
      } else {
        Get.snackbar("Error", "Failed to fetch restaurants");
        print('Failed to fetch restaurants. Status code: ${response.statusCode}');
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
