class ReviewWidgetModel {
  final String reviewId; // Mã định danh của review
  final String userId; // Mã định danh của người dùng
  final int destinationId; // Mã định danh của địa điểm
  final String context; // Nội dung của review
  final double rating; // Đánh giá (từ 1 đến 5)
  final DateTime dateCreated; // Ngày tạo review
  int likeCount; // Số lượng lượt thích
  final String travelTime; // Thời gian đi
  final List<String> companions; // Ai đi cùng
  final String title;
  final List<String>? images;
  final String purpose;
  // final int modeType;

  ReviewWidgetModel({
    required this.reviewId,
    required this.userId,
    required this.destinationId,
    required this.context,
    required this.rating,
    required this.dateCreated,
    required this.purpose,
    this.likeCount = 0,
    required this.travelTime,
    required this.companions,
    required this.title,
    this.images = const [],

    // required this.modeType,
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
      rating: json['rating'].toDouble(), // Đảm bảo rating là double
      dateCreated: DateTime.parse(json['dateCreated']),
      likeCount: json['likeCount'] ?? 0,
      travelTime: json['travelTime'] ?? '',
      companions: json['whoGoWith'] ?? '',
      title: json['title'] ?? '',
      images: json['images'] ?? '', // Thêm trường title
      purpose: json['purpose'] ?? '',
      // modeType: json['modeTypoe']?? '',
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
      'travelTime': travelTime,
      'companions': companions,
      'title': title,
      'images': images,
      'purpose': purpose,
      // 'modeType':modeType,
    };
  }
}

// Dữ liệu giả lập cho các review
List<ReviewWidgetModel> mockReviews = [
  ReviewWidgetModel(
    reviewId: '1',
    userId: 'user01',
    destinationId: 1,
    context:
        'Great place! Highly recommended for tourism and family. I\'ll come back next time.',
    rating: 4.6,
    dateCreated: DateTime.now(),
    likeCount: 10,
    travelTime: 'September/2024',
    companions: [
      'Family'
          'Friends'
    ],
    title: 'Amazing Experience!', // Thêm tiêu đề cho review
    images: [
      "https://duthuyendanang.com/wp-content/uploads/2021/08/cau-rong-da-nang-a-1024x664.jpg",
      "https://danangbest.com/upload_content/cau-rong-da-nang-4.webp",
    ],
    purpose: 'Leisure',
    // modeType:1,
  ),
  ReviewWidgetModel(
    reviewId: '2',
    userId: 'user02',
    destinationId: 2,
    context: 'Beautiful views and great service.',
    rating: 5.0,
    dateCreated: DateTime.now(),
    likeCount: 15,
    travelTime: 'August/2024',
    companions: ['Friends'],
    title: 'Unforgettable Trip!',
    images: [
      'https://ngocanhtravel.vn/wp-content/uploads/2022/06/bai-bien-my-khe-da-nang-min.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSDdZGDD0FF1USQuM1HacAqUWT34p6uJdwtNeDx9jNtNOMrsWFwVQwa6i6pqAO60-xflg&usqp=CAU',
    ],
    purpose: 'Business',
    // modeType: 1,
  ),
  ReviewWidgetModel(
    reviewId: '3',
    userId: 'user03',
    destinationId: 2,
    context: 'Not bad, but the food was mediocre.',
    rating: 3.0,
    dateCreated: DateTime.now(),
    likeCount: 7,
    travelTime: 'October/2024',
    companions: ['Solo'],
    title: 'Average Experience',
    images: [
      'https://dichvuthuexedanang.com/wp-content/uploads/2019/08/bien-my-khe-da-nang2-min.jpeg',
      'https://danangxanh.net/data/images/bien-my-khe.jpg',
    ],
    purpose: 'Leisure',
    // modeType: 1,
  ),
];
