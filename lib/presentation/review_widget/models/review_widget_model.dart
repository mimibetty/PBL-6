

class ReviewWidgetModel {
  final String reviewId;         // Mã định danh của review
  final String userId;           // Mã định danh của người dùng
  final int destinationId;    // Mã định danh của địa điểm
  final String context;          // Nội dung của review
  final double rating;           // Đánh giá (từ 1 đến 5)
  final DateTime dateCreated;    // Ngày tạo review
  int likeCount;                 // Số lượng lượt thích

  ReviewWidgetModel({
    required this.reviewId,
    required this.userId,
    required this.destinationId,
    required this.context,
    required this.rating,
    required this.dateCreated,
    this.likeCount = 0,          // Số lượt thích mặc định là 0
  });

  // Phương thức tăng lượt thích
  void increaseLikeCount() {
    likeCount += 1;
  }

  // Phương thức giảm lượt thích
  void decreaseLikeCount() {
    if (likeCount > 0) {
      likeCount -= 1;
    }
  }

  factory ReviewWidgetModel.fromJson(Map<String, dynamic> json) {
    return ReviewWidgetModel(
      reviewId: json['reviewId'],
      userId: json['userId'],
      destinationId: json['destinationId'],
      context: json['context'],
      rating: json['rating'],
      dateCreated: DateTime.parse(json['dateCreated']),
      likeCount: json['likeCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'destinationId': destinationId,
      'context': context,
      'rating': rating,
      'dateCreated': dateCreated.toIso8601String(),
      'likeCount': likeCount,
    };
  }
}

// Dữ liệu giả lập cho các review
List<ReviewWidgetModel> mockReviews = [
  ReviewWidgetModel(
    reviewId: '1',
    userId: 'user01',
    destinationId: 1,
    context: 'Great place! Highly recommended for tourism and family . Ill comeback next time.',
    rating: 4.5,
    dateCreated: DateTime.now(),
    likeCount: 10,
  ),
  ReviewWidgetModel(
    reviewId: '2',
    userId: 'user02',
    destinationId: 2,
    context: 'Beautiful views and great service.',
    rating: 5.0,
    dateCreated: DateTime.now(),
    likeCount: 15,
  ),
  ReviewWidgetModel(
    reviewId: '3',
    userId: 'user03',
    destinationId: 2,
    context: 'Not bad, but the food was mediocre.',
    rating: 3.0,
    dateCreated: DateTime.now(),
    likeCount: 7,
  ),
];
