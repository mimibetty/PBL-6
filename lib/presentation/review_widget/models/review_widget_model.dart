class ReviewModel {
  String title;
  String content;
  double rating;
  String language;
  String dateCreated;
  String companion;
  int id;
  int userId;
  String userName;
  String? userAvatarUrl;
  int? destinationId; // Có thể null
  int likeCount; // Thêm trường likeCount
  List<ReviewImage> images;

  ReviewModel({
    required this.userName,
    required this.title,
    required this.content,
    required this.rating,
    required this.language,
    required this.dateCreated,
    required this.companion,
    required this.id,
    required this.userId,
    this.destinationId, // Có thể null
    this.userAvatarUrl, // có thể null
    required this.likeCount,
    required this.images,
  });

  // Factory method để tạo ReviewModel từ JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      title: json['title'] ?? 'No Title',
      content: json['content'] ?? 'No Content',
      rating: (json['rating'] ?? 0).toDouble(),
      language: json['language'] ?? 'Unknown',
      dateCreated: json['date_create'] ?? DateTime.now().toIso8601String(),
      companion: json['companion'] ?? 'Unknown',
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? 'Unknown',
      userAvatarUrl: json['user_avatar_url'] ?? 'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png',
      destinationId: json['destination_id'], // Null nếu không có
      likeCount: json['like_count'] ?? 0, // Mặc định là 0
      images: (json['images'] as List<dynamic>?)
              ?.map((image) => ReviewImage.fromJson(image))
              .toList() ??
          [], // Trả về danh sách rỗng nếu `images` là null
    );
  }

  // Convert một ReviewModel sang JSON
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
      'like_count': likeCount,
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

  // Factory method để tạo ReviewImage từ JSON
  factory ReviewImage.fromJson(Map<String, dynamic> json) {
    return ReviewImage(
      id: json['id'] ?? 0,
      url: json['url'] ?? 'https://default-image-url.com/default.jpg', // URL mặc định
      blobName: json['blob_name'] ?? 'No Blob Name',
    );
  }

  // Convert một ReviewImage sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'blob_name': blobName,
    };
  }
}
