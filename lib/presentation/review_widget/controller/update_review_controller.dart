import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';

class UpdateReviewController extends GetxController {
  final ReviewWidgetController reviewController = Get.find<ReviewWidgetController>();

  final String apiBaseUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/';
  final String destinationApiBaseUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/';

  Future<void> updateReview({
    required int id,
    required int reviewId,
    required String title,
    required String content,
    required double rating,
    required String language,
    required String companion,
    String? dateCreate,
    List<File>? newImages, // Images to add
    List<int>? imageIdsToRemove, // IDs of images to remove
  }) async {
    reviewController.isLoading.value = true;
    try {
      dateCreate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Determine the API endpoint based on typeOfReviews
      final String apiEndpoint = reviewController.typeOfReview == 'destination' ? '' : 'tour/';

      final Uri url = Uri.parse('$apiBaseUrl$apiEndpoint$reviewId').replace(queryParameters: {
        'title': title,
        'content': content,
        'rating': rating.toString(),
        'language': language,
        'companion': companion,
        'date_create': dateCreate,
      });

      if (newImages != null || (imageIdsToRemove != null && imageIdsToRemove.isNotEmpty)) {
        final request = http.MultipartRequest('PUT', url);

        // Add IDs of images to remove
        if (imageIdsToRemove != null && imageIdsToRemove.isNotEmpty) {
          request.fields['image_ids_to_remove'] = imageIdsToRemove.join(',');
        }

        // Add new images
        if (newImages != null && newImages.isNotEmpty) {
          for (File image in newImages) {
            request.files.add(await http.MultipartFile.fromPath('new_images', image.path));
          }
        }

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Review updated successfully!');
          reviewController.fetchReviews(id: id); // Refresh reviews
        } else {
          Get.snackbar('Error', 'Failed to update review: $responseBody');
        }
      } else {
        final response = await http.put(url);
        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Review updated successfully!');
          reviewController.fetchReviews(id: id); // Refresh reviews
        } else {
          Get.snackbar('Error', 'Failed to update review: ${response.body}');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      reviewController.isLoading.value = false;
    }
  }

  Future<Map<String, String>> fetchInfoDestination(int destinationId) async {
    final Uri url = Uri.parse('$destinationApiBaseUrl$destinationId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final name = data['name'] ?? 'Unknown';
        final address = '${data['address']['street']}, ${data['address']['ward']}, ${data['address']['district']}';
        final image = (data['images'] != null && data['images'].isNotEmpty) ? data['images'][0]['url'] : '';

        return {
          'name': name,
          'address': address,
          'image': image,
        };
      } else {
        Get.snackbar('Error', 'Failed to fetch destination info');
        return {'name': 'Unknown', 'address': '', 'image': ''};
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      return {'name': 'Unknown', 'address': '', 'image': ''};
    }
  }
}
