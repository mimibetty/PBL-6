import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';
import 'package:intl/intl.dart';

class ReviewWidgetController extends GetxController {
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  RxBool isLoading = false.obs;

  final String apiBaseUrl =
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/';

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
    // Pass the received data to createReview method
    await createReview(
      title: title,
      content: content,
      rating: rating,
      userId: int.parse(userId), // Ensure userId is parsed to int
      destinationId: int.parse(destinationId), // Ensure destinationId is parsed to int
      language: 'English', // Example language
      companion: companion,
      images: images,
    );
    print('Review created successfully');
    print('Title: $title, Content: $content, Rating: $rating, Companion: $companion, Destination ID: $destinationId, User ID: $userId');
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
      // Nếu date_create là null, gán giá trị ngày hiện tại theo định dạng YYYY-MM-DD
      dateCreate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());

      final Uri url = Uri.parse(apiBaseUrl).replace(queryParameters: {
        'title': title,
        'content': content,
        'rating': rating.toString(),
        'user_id': userId.toString(),
        'destination_id': destinationId.toString(),
        'language': language,
        'companion': companion,
        'date_create': dateCreate,  // Gửi date_create dưới dạng YYYY-MM-DD
      });

      final request = http.MultipartRequest('POST', url);

      if (images != null && images.isNotEmpty) {
        for (File image in images) {
          request.files.add(await http.MultipartFile.fromPath(
            'images',
            image.path,
          ));
        }
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        // Success - điều hướng về trang DetailPage
        Get.snackbar('Success', 'Review created successfully!');
        
        Get.back(); // Trở lại trang trước (trong trường hợp này là DetailPage)
        // Hoặc chuyển trực tiếp đến DetailPage:
        // Get.to(DetailPage(destinationId: destinationId)); 

        // Có thể cần làm mới lại dữ liệu reviews trên trang DetailPage
        fetchReviewsByDestinationID(destinationId);
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
    reviews.clear(); // Xóa dữ liệu cũ trước khi gọi API
    try {
      final Uri url = Uri.parse('$apiBaseUrl?destination_id=$destinationId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));
        final fetchedReviews = responseData
            .map((reviewData) => ReviewModel.fromJson(reviewData))
            .toList();

        // Kiểm tra trước khi cập nhật trạng thái
        if (Get.isRegistered<ReviewWidgetController>()) {
          reviews.value = fetchedReviews;
        }
      } else {
        Get.snackbar('Error', 'Failed to load reviews');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      if (Get.isRegistered<ReviewWidgetController>()) {
        isLoading.value = false;
      }
    }
  }
}

