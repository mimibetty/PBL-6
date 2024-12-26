import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelappflutter/presentation/home_screen/models/tour_model.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';

class TourController extends GetxController {
  RxList<Tour> tours = <Tour>[].obs; // List of tours
  RxList<ReviewModel> reviews = <ReviewModel>[].obs; // List of reviews
  RxBool isLoading = false.obs; // Loading state for tours
  RxBool isLoadingReviews = false.obs; // Loading state for reviews

  final String baseUrl =
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net';

  // Fetch tours by city ID
  Future<void> fetchTourByCityID(int cityID) async {
    isLoading.value = true; // Set loading to true
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tour/?city_id=$cityID&is_popular=true'),
      );

      if (response.statusCode == 200) {
        // Parse response body
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        tours.value = jsonResponse
            .map((data) => Tour.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        print('Failed to load tours: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load tours');
      }
    } catch (e) {
      print('Error fetching tours: $e');
      Get.snackbar('Error', 'An error occurred while fetching tours');
    } finally {
      isLoading.value = false; // Set loading to false
    }
  }


}
