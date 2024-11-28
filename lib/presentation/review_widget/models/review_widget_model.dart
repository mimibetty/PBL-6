class ReviewModel {
  String title;
  String content;
  double rating;
  String language;
  String dateCreated;
  String companion;
  int id;
  int userId;
  int destinationId;
  int likeCount; // Thêm trường likeCount
  List<ReviewImage> images;

  ReviewModel({
    required this.title,
    required this.content,
    required this.rating,
    required this.language,
    required this.dateCreated,
    required this.companion,
    required this.id,
    required this.userId,
    required this.destinationId,
    required this.likeCount, // Thêm trường likeCount
    required this.images,
  });

  // Factory method to create a Review object from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      title: json['title'],
      content: json['content'],
      rating: (json['rating'] as num).toDouble(),
      language: json['language'],
      dateCreated: json['date_create'],
      companion: json['companion'],
      id: json['id'],
      userId: json['user_id'],
      destinationId: json['destination_id'],
      likeCount: json['like_count'] ?? 0, // Giá trị mặc định nếu không có
      images: (json['images'] as List<dynamic>)
          .map((image) => ReviewImage.fromJson(image))
          .toList(),
    );
  }

  // Convert a Review object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'rating': rating,
      'language': language,
      'date_create': dateCreated,
      'companion': companion,
      'id': id,
      'user_id': userId,
      'destination_id': destinationId,
      'like_count': likeCount, // Thêm trường likeCount
      'images': images.map((image) => image.toJson()).toList(),
    };
  }
}


class ReviewImage {
  int id;
  String url;
  String blobName;

  ReviewImage({
    required this.id,
    required this.url,
    required this.blobName,
  });

  // Factory method to create a ReviewImage object from JSON
  factory ReviewImage.fromJson(Map<String, dynamic> json) {
    return ReviewImage(
      id: json['id'],
      url: json['url'],
      blobName: json['blob_name'],
    );
  }

  // Convert a ReviewImage object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'blob_name': blobName,
    };
  }
}

final List<ReviewModel> mockReviews = [
  ReviewModel(
    title: "Review 1 for Destination 2",
    content: "This is review 1 for Destination 2.",
    rating: 1.5,
    language: "english",
    dateCreated: "2024-11-13",
    companion: "Solo",
    id: 6,
    userId: 5,
    destinationId: 6,
    likeCount: 10, // Ví dụ giá trị cụ thể
    images: [], // No images for this review
  ),
  ReviewModel(
    title: "좋은",
    content: "호텔은 꽤 괜찮습니다",
    rating: 4.5,
    language: "Korean",
    dateCreated: "2024-11-27",
    companion: "Solo",
    id: 130,
    userId: 70,
    destinationId: 6,
    likeCount: 25, // Ví dụ giá trị cụ thể
    images: [
      ReviewImage(
        id: 279,
        url: "https://tripstoragepbl6.blob.core.windows.net/travel-image/reviews/279.png",
        blobName: "reviews/279.png",
      ),
    ],
  ),
  ReviewModel(
    title: "糟糕的酒店",
    content: "食物不好，房间不好，空调坏了",
    rating: 2.0,
    language: "Chinese",
    dateCreated: "2024-11-27",
    companion: "Family",
    id: 131,
    userId: 67,
    destinationId: 6,
    likeCount: 0, // Giá trị mặc định
    images: [
      ReviewImage(
        id: 280,
        url: "https://tripstoragepbl6.blob.core.windows.net/travel-image/reviews/280.png",
        blobName: "reviews/280.png",
      ),
    ],
  ),
];
