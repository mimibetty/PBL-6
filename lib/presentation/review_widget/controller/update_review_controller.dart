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

  /// Hàm cập nhật review
  Future<void> updateReview({
    required int destinationId,
    required int reviewId,
    required String title,
    required String content,
    required double rating,
    required String language,
    required String companion,
    String? dateCreate,
    List<File>? newImages, // Danh sách ảnh mới để thêm
    List<int>? imageIdsToRemove, // ID ảnh cần xóa
  }) async {
    reviewController.isLoading.value = true; // Bắt đầu trạng thái loading
    try {
      // Đặt giá trị mặc định cho ngày tạo nếu không được cung cấp
      dateCreate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Tạo URL với query parameters
      final Uri url = Uri.parse('$apiBaseUrl$reviewId').replace(queryParameters: {
        'title': title,
        'content': content,
        'rating': rating.toString(),
        'language': language,
        'companion': companion,
        'date_create': dateCreate,
      });

      // Tạo request multipart
      final request = http.MultipartRequest('PUT', url);
  
      // Thêm ID ảnh cần xóa (nếu có)
      if (imageIdsToRemove != null && imageIdsToRemove.isNotEmpty) {
        request.fields['image_ids_to_remove'] = imageIdsToRemove.join(',');
        print('Image IDs to remove: $imageIdsToRemove');
      }

      // Thêm ảnh mới (nếu có)
      if (newImages != null && newImages.isNotEmpty) {
        for (File image in newImages) {
          request.files.add(await http.MultipartFile.fromPath('new_images', image.path));
        }
        print('New images added: ${newImages.map((e) => e.path).toList()}');
      }

      // Gửi yêu cầu
      final response = await request.send();

      // Kiểm tra phản hồi từ server
      print('Response status code: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Review updated successfully!');
        reviewController.fetchReviewsByDestinationID(destinationId); // Tải lại danh sách review
      } else {
        Get.snackbar('Error', 'Failed to update review: $responseBody');
      }
    } catch (e) {
      print('Error occurred: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
     reviewController.isLoading.value = false; // Kết thúc trạng thái loading
    }
  }


  /// Hàm lấy thông tin điểm đến
  Future<Map<String, String>> fetchInfoDestination(int destinationId) async {
    final Uri url = Uri.parse('$destinationApiBaseUrl$destinationId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
