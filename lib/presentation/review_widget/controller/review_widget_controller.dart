import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';
import 'dart:developer';


class ReviewWidgetController extends GetxController {
  // Reactive variables to manage reviews and loading state
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  RxBool isLoading = false.obs;

  // API endpoint
  final String apiBaseUrl =
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/';

  /// Fetch reviews for a specific destination ID
  Future<void> fetchReviewsByDestinationID(int destinationId) async {
    isLoading.value = true;

    try {
      // Construct API URL with destination_id as a query parameter
      final Uri url = Uri.parse('$apiBaseUrl?destination_id=$destinationId');
      log('Fetching reviews from: $url');

      // Make GET request
      final response = await http.get(url);

      // Handle successful response
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));

        // Parse JSON to ReviewModel and update state
        reviews.value = responseData
            .map((reviewData) => ReviewModel.fromJson(reviewData))
            .toList();

        log('Reviews fetched successfully: ${reviews.length}');
      } else {
        // Handle API errors
        log('Failed to fetch reviews. Status code: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load reviews');
      }
    } catch (e) {
      // Handle exceptions
      log('Error while fetching reviews: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
