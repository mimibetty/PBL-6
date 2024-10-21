import 'package:get/get.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';
class ReviewWidgetController extends GetxController {
  RxList<ReviewWidgetModel> reviewList = mockReviews.obs; // Sử dụng dữ liệu giả lập từ mô hình
  RxList<ReviewWidgetModel> filteredReviews = <ReviewWidgetModel>[].obs;

  void filterReviewsByDestination(int destinationId) {
    filteredReviews.value = reviewList.where((review) => review.destinationId == destinationId).toList();
  }

  RxString radioGroup = "".obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void likeReview(String reviewId) {
    int index = reviewList.indexWhere((review) => review.reviewId == reviewId);
    if (index != -1) {
      reviewList[index].increaseLikeCount();
      reviewList.refresh();
    }
  }

  void unlikeReview(String reviewId) {
    int index = reviewList.indexWhere((review) => review.reviewId == reviewId);
    if (index != -1) {
      reviewList[index].decreaseLikeCount();
      reviewList.refresh();
    }
  }
}
