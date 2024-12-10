import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';
import 'package:intl/intl.dart';

class ReviewWidgetController extends GetxController {
  RxList<ReviewModel> reviews = <ReviewModel>[].obs; // Store reviews
  RxBool isLoading = false.obs;

  final String apiBaseUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/';
  final String ratingDistributionUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/rating-distribution/';

  // Function to create review
  Future<void> setReviewData({
    required String title,
    required String content,
    required double rating,
    required String companion,
    required String destinationId,
    required String userId,
    List<File>? images, // List of image files
  }) async {
    await createReview(
      title: title,
      content: content,
      rating: rating,
      userId: int.parse(userId),
      destinationId: int.parse(destinationId),
      language: 'English',
      companion: companion,
      images: images,
    );
    print('Review created successfully');
  }

  /// Create a new review with the given parameters
  Future<void> createReview({
    required String title,
    required String content,
    required double rating,
    required int userId,
    required int destinationId,
    required String language,
    required String companion,
    String? dateCreate,
    List<File>? images,
  }) async {
    isLoading.value = true;
    try {
      dateCreate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());

      final Uri url = Uri.parse(apiBaseUrl).replace(queryParameters: {
        'title': title,
        'content': content,
        'rating': rating.toString(),
        'user_id': userId.toString(),
        'destination_id': destinationId.toString(),
        'language': language,
        'companion': companion,
        'date_create': dateCreate,
      });

      final request = http.MultipartRequest('POST', url);

      if (images != null && images.isNotEmpty) {
        for (File image in images) {
          request.files.add(await http.MultipartFile.fromPath('images', image.path));
        }
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Review created successfully!');
        Get.back(); // Navigate back
        fetchReviewsByDestinationID(destinationId); // Fetch updated reviews
      } else {
        final responseBody = await response.stream.bytesToString();
        Get.snackbar('Error', 'Failed to create review: $responseBody');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch reviews for a specific destination ID
  Future<void> fetchReviewsByDestinationID(int destinationId) async {
    isLoading.value = true;
    reviews.clear(); // Clear old data before fetching new reviews
    try {
      final Uri url = Uri.parse('$apiBaseUrl?destination_id=$destinationId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        final fetchedReviews = responseData.map((reviewData) => ReviewModel.fromJson(reviewData)).toList();
        reviews.value = fetchedReviews; // Store the reviews
      } else {
        Get.snackbar('Error', 'Failed to load reviews');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyFilter({
    required int destinationId,
    int? selectedRating,
    String? selectedSeason,
    String? selectedCompanion,
  }) async {
    try {
      // Fetch the latest reviews before applying filters
      await fetchReviewsByDestinationID(destinationId);

      // Apply filters on the fetched reviews
      reviews.value = reviews.where((review) {
        bool matchesRating = selectedRating == null || (review.rating >= selectedRating && review.rating < selectedRating + 1);
        bool matchesSeason = selectedSeason == null || _getSeason(review.dateCreated) == selectedSeason;
        bool matchesCompanion = selectedCompanion == null || review.companion.contains(selectedCompanion);
        return matchesRating && matchesSeason && matchesCompanion;
      }).toList();

      print("Reviews after filtering: ${reviews.length}"); // Print the number of reviews after applying the filter
    } catch (e) {
      print("Error applying filter: $e");
    }
  }

  // Helper function to get the season from a review's creation date
  String _getSeason(String dateCreated) {
    final date = DateFormat('yyyy-MM-dd').parse(dateCreated);
    final month = date.month;

    if (month >= 3 && month <= 5) {
      return 'Mar-May';
    } else if (month >= 6 && month <= 8) {
      return 'Jun-Aug';
    } else if (month >= 9 && month <= 11) {
      return 'Sep-Nov';
    } else {
      return 'Dec-Feb';
    }
  }

  /// Fetch rating distribution for a specific destination ID
  Future<Map<int, int>> fetchRatingDistribution(int destinationId) async {
    try {
      isLoading.value = true;

      final Uri url = Uri.parse('$ratingDistributionUrl$destinationId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));

        // Parse the response into a Map<int, int>
        return responseData.map((key, value) => MapEntry(int.parse(key), value as int));
      } else {
        Get.snackbar('Error', 'Failed to fetch rating distribution');
        return {};
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      return {};
    } finally {
      isLoading.value = false;
    }
  }
}