class Business {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String description;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final List<String> type;
  final String email;
  final String logoUrl;

  Business({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.description,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.type,
    required this.email,
    required this.logoUrl,
  });

  // Factory method để tạo từ JSON
  factory Business.fromJson(Map<String, dynamic> json) {
    final userInfo = json['user_info'] ?? {};
    final address = userInfo['address'] ?? {};
    final image = userInfo['image'] ?? {};

    return Business(
      id: json['id']?.toString() ?? '0',
      name: json['username'] ?? 'Unknown Business',
      address: address.isNotEmpty
          ? '${address['street'] ?? ''}, ${address['ward'] ?? ''}, ${address['district'] ?? ''}'
          : 'Unknown Address',
      phoneNumber: userInfo['phone_number'] ?? 'Unknown Phone',
      description: userInfo['description'] ?? 'No description available',
      images: image['url'] != null ? [image['url']] : [],
      rating: 0.0, // Default rating
      reviewCount: 0, // Default review count
      type: ['Business'], // Default type
      email: json['email'] ?? 'Unknown Email',
      logoUrl: image['url'] ?? '', // Use the logo URL from the image field
    );
  }

  // Phương thức để tạo dữ liệu mặc định nếu không có JSON
  static Business empty() {
    return Business(
      id: '0',
      name: 'Unknown Business',
      address: 'Unknown Address',
      phoneNumber: 'Unknown Phone',
      description: 'No description available',
      images: [],
      rating: 0.0,
      reviewCount: 0,
      type: ['Business'],
      email: 'Unknown Email',
      logoUrl: '',
    );
  }
    // Add the copyWith method
  Business copyWith({
    String? id,
    String? name,
    String? address,
    String? phoneNumber,
    String? description,
    List<String>? images,
    double? rating,
    int? reviewCount,
    List<String>? type,
    String? email,
    String? logoUrl,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      type: type ?? this.type,
      email: email ?? this.email,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
final List<Business> mockBusinessDatabase = [
  Business(
    id: "A1",
    name: "Sun Group",
    address: "123 Beach Road, Da Nang",
    phoneNumber: "09054567890",
    description: "A big group with good services.",
    type: ['Hotel', 'Restaurant', 'Thing to do'],
    images: [
      "https://sungroupthanhhoa.info/uploads/sun-thanh-hoa-tt-dai-lo-01-1536x864.jpg",
      "https://sunhome.com.vn/wp-content/uploads/2021/12/La-Festa-20211226.jpg"
    ],
    rating: 4.5,
    reviewCount: 150,
    email: 'HkG6M@example.com',
    logoUrl:
        "https://inkythuatso.com/uploads/thumbnails/800/2021/10/logo-vinfast-inkythuatso-21-11-22-46.jpg",
  ),
  Business(
    id: "A2",
    name: "Vin Group",
    address: "456 Hill Street, Da Nang",
    phoneNumber: "123 555-7890",
    description: "A huge companies in the mountains with panoramic views.",
    images: [
      "https://ircdn.vingroup.net/storage/public/2019/07/DJI_0030-fixed2-mini-20190727T100030844048.jpg",
      "https://maisonoffice.vn/wp-content/uploads/2023/12/2-vingroup-la-tap-doan-kinh-te-co-von-dieu-le-lon-nhat-thi-truong-viet-nam.jpg"
    ],
    email: 'maison@gmail.com',
    rating: 4.2,
    type: ['Hotel', 'Restaurant', 'Thing to do'],
    logoUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_3oNME3dOzDakJ-vgAQa2eS5ifAmL2zHi6g&s",
    reviewCount: 85,
  ),
];


