import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';
import 'package:intl/intl.dart';

class ReviewWidgetController extends GetxController {
  RxList<ReviewModel> reviews = <ReviewModel>[].obs; // Store reviews
  RxBool isLoading = false.obs;
  var ratingCounts = <int, int>{}.obs; // Observable map để lưu rating counts
  RxInt totalReviews = 0.obs;
  RxDouble averageRating = 0.0.obs;
  RxString selectedLanguage = 'English'.obs; // Lưu ngôn ngữ được chọn
  
  final String apiBaseUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/';
  final String ratingDistributionUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/rating-distribution/';
  
  // Function to create review

  // Hàm Create Review
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
    isLoading.value = true; // Bắt đầu trạng thái loading
    try {
      dateCreate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Tạo URL với query parameters
      final Uri url = Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/')
          .replace(queryParameters: {
        'title': title,
        'content': content,
        'rating': rating.toString(),
        'user_id': userId.toString(),
        'destination_id': destinationId.toString(),
        'language': language,
        'companion': companion,
        'date_create': dateCreate,
      });

      if (images != null && images.isNotEmpty) {
        // Nếu có ảnh, tạo request multipart
        final request = http.MultipartRequest('POST', url);

        // Thêm tệp hình ảnh
        for (File image in images) {
          request.files.add(await http.MultipartFile.fromPath('images', image.path));
        }

        // Gửi yêu cầu
        final response = await request.send();

        // Xử lý phản hồi
        print('Request sent with multipart data');
        print('Response status code: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Review created successfully');
          fetchReviewsByDestinationID(destinationId); // Tải lại danh sách review
        } else {
          Get.snackbar('Error', 'Failed to update review: $responseBody');
        }
      } else {
        // Nếu không có ảnh, gửi request thường
        final response = await http.post(url);

        // Xử lý phản hồi
        print('Request sent without multipart data');
        print('Response status code: ${response.statusCode}');
        if (response.statusCode == 200) {
          print('Review created successfully');
          fetchReviewsByDestinationID(destinationId); // Tải lại danh sách review
        } else {
          print('Error: ${response.body}');
        }
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      isLoading.value = false; // Kết thúc trạng thái loading
    }
  }


  // xử lý xóa Review
  Future<void> deleteReview(int reviewId, int destinationId) async {
  isLoading.value = true;
  try {
    final Uri url = Uri.parse('$apiBaseUrl/$reviewId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Review deleted successfully!');
      // Cập nhật danh sách đánh giá sau khi xóa
      fetchReviewsByDestinationID(destinationId);
    } else {
      Get.snackbar('Error', 'Failed to delete review: ${response.body}');
    }
  } catch (e) {
    Get.snackbar('Error', 'An error occurred: $e');
  } finally {
    isLoading.value = false;
  }
}

  /// Fetch reviews by destination ID and include user details
  Future<void> fetchReviewsByDestinationID(int destinationId) async {
    isLoading.value = true;
    reviews.clear(); // Clear old data before fetching new reviews
    int thisUserId = Get.find<ProfileController>().profileModelObj.value.id;
    try {
      final Uri url = Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/review/?destination_id=$destinationId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        final List<Future<ReviewModel>> reviewFutures = responseData.map((reviewData) async {
          final int userId = reviewData['user_id'];
          final Uri userUrl = Uri.parse(
              'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/$userId');
          final userResponse = await http.get(userUrl);
          String userName = 'Unknown';
          String userAvatarUrl =
              'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png';

          if (userResponse.statusCode == 200) {
            final userData = json.decode(utf8.decode(userResponse.bodyBytes));
            userName = userData['username'] ?? userName;
            userAvatarUrl = userData['user_info']?['image']?['url'] ?? userAvatarUrl;
          }

          return ReviewModel.fromJson({
            ...reviewData,
            'user_name': userName,
            'user_avatar_url': userAvatarUrl,
          });
        }).toList();
        reviews.value = await Future.wait(reviewFutures);

        // Sort the reviews to place this user's reviews at the top
        reviews.sort((a, b) {
          if (a.userId == thisUserId && b.userId != thisUserId) {
            return -1; // `a` should come before `b`
          } else if (a.userId != thisUserId && b.userId == thisUserId) {
            return 1; // `b` should come before `a`
          } else {
            return 0; // Leave the order unchanged if neither matches
          }
        });

        // Update totalReviews and averageRating
        totalReviews.value = reviews.length;
        averageRating.value = calculateAverageRating(reviews);
      } else {
        Get.snackbar('Error', 'Failed to load reviews');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false; // Đặt trạng thái tải xong
    }
  }



  Future<void> applyFilter({
    required int destinationId,
    String? selectedRating,
    String? selectedSeason,
    String? selectedCompanion,
    String? selectedLanguage, // Thêm ngôn ngữ vào filter
  }) async {
    try {
      // Fetch the latest reviews before applying filters
      await fetchReviewsByDestinationID(destinationId);

      // Lọc theo ngôn ngữ nếu được chọn
      if (selectedLanguage != null && selectedLanguage.isNotEmpty) {
        await filterReviewsByLanguage(destinationId: destinationId, language: selectedLanguage);
      }

      // Apply other filters on the fetched reviews
      reviews.value = reviews.where((review) {
        bool matchesRating = selectedRating == null || selectedRating == "All" || 
                            (review.rating >= double.parse(selectedRating) && review.rating < double.parse(selectedRating) + 1);
        bool matchesSeason = selectedSeason == null || _getSeason(review.dateCreated) == selectedSeason;
        bool matchesCompanion = selectedCompanion == null || review.companion.contains(selectedCompanion);
        return matchesRating && matchesSeason && matchesCompanion;
      }).toList();

      print("Reviews after filtering: ${reviews.length}"); // Print the number of reviews after applying the filter
    } catch (e) {
      print("Error applying filter: $e");
    }
  }

  Future<void> filterReviewsByLanguage({
    required int destinationId,
    required String language,
  }) async {
    isLoading.value = true; // Bắt đầu trạng thái loading
    try {
      final Uri url = Uri.parse('$apiBaseUrl?destination_id=$destinationId&language=$language');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        final List<Future<ReviewModel>> reviewFutures = responseData.map((reviewData) async {
          final int userId = reviewData['user_id'];
          final Uri userUrl = Uri.parse(
              'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/user/$userId');
          final userResponse = await http.get(userUrl);
          String userName = 'Unknown';
          String userAvatarUrl =
              'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png';

          if (userResponse.statusCode == 200) {
            final userData = json.decode(utf8.decode(userResponse.bodyBytes));
            userName = userData['username'] ?? userName;
            userAvatarUrl = userData['user_info']?['image']?['url'] ?? userAvatarUrl;
          }

          return ReviewModel.fromJson({
            ...reviewData,
            'user_name': userName,
            'user_avatar_url': userAvatarUrl,
          });
        }).toList();
        reviews.value = await Future.wait(reviewFutures);

        // Cập nhật tổng số review và điểm trung bình
        totalReviews.value = reviews.length;
        averageRating.value = calculateAverageRating(reviews);
      } else {
        Get.snackbar('Error', 'Failed to fetch reviews by language');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false; // Kết thúc trạng thái loading
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
  Future<void> fetchRatingDistribution(int destinationId) async {
    try {
      isLoading.value = true;

      final Uri url = Uri.parse('$ratingDistributionUrl$destinationId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        print('Rating distribution: $responseData');
        // Gán trực tiếp dữ liệu từ API vào ratingCounts
        ratingCounts.value =
            responseData.map((key, value) => MapEntry(int.parse(key), value as int));
      } else {
        Get.snackbar('Error', 'Failed to fetch rating distribution');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
    double calculateAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0.0; // Nếu không có đánh giá, trả về 0.0
    
    // Tính tổng điểm rating
    double totalRating = reviews.fold(0, (sum, review) => sum + review.rating);
    
    // Tính trung bình và làm tròn đến 1 chữ số sau dấu thập phân
    double averageRating = totalRating / reviews.length;
    return double.parse(averageRating.toStringAsFixed(1));
  }
}