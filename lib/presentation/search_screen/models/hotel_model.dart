class Hotel {
  final int hotelID;
  final int destinationID; // Add destinationID
  final String hotelName;
  final String hotelLocation;
  final String priceRange;
  final int age;
  final String openTime;
  final double duration;
  final List<String> roomFeatures;
  final List<String> propertyAmenities;
  final List<String> roomTypes;
  final List<String> hotelStyles;
  final List<String> hotelLanguages;
  final int star;
  final List<String> images;
  final String about;
  final double rating;
  final int reviewCount;
  final String website;
  final String email;
  final String hotelContact;

  static const String defaultImageUrl = 'https://experienceleaguecommunities.adobe.com/t5/image/serverpage/image-id/34749i7C7BB1DB5E28E527?v=v2';

  Hotel({
    required this.hotelID,
    required this.destinationID, // Initialize destinationID
    required this.hotelName,
    required this.hotelLocation,
    required this.priceRange,
    required this.age,
    required this.openTime,
    required this.duration,
    required this.roomFeatures,
    required this.propertyAmenities,
    required this.roomTypes,
    required this.hotelStyles,
    required this.hotelLanguages,
    required this.star,
    required this.images,
    required this.about,
    required this.rating,
    required this.reviewCount,
    required this.website,
    required this.email,
    required this.hotelContact,
  });
  factory Hotel.fromApi(Map<String, dynamic> apiData) {
    // Kiểm tra và xử lý danh sách ảnh
    List<String> imageUrls = (apiData['images'] as List<dynamic>? ?? [])
        .map((img) => img['url'] as String?)
        .where((url) => url != null && url.isNotEmpty)
        .map((url) => url!)
        .toList();

    // Nếu không có ảnh hợp lệ, thêm ảnh mặc định
    if (imageUrls.isEmpty) {
      imageUrls.add(Hotel.defaultImageUrl);
    }

    return Hotel(
      hotelID: apiData['hotel_id'] as int? ?? 0, // Giá trị mặc định là 0 nếu null
      destinationID: apiData['id'] as int? ?? 0, // Giá trị mặc định là 0 nếu null
      hotelName: apiData['name']?.toString() ?? 'Unknown Hotel',
      hotelLocation: '${apiData['address']?['ward'] ?? 'Unknown Ward'}, '
          '${apiData['address']?['district'] ?? 'Unknown District'}, '
          '${apiData['address']?['street'] ?? 'Unknown Street'}',
      priceRange: "From ${apiData['price_bottom']?.toString() ?? '0'} to ${apiData['price_top']?.toString() ?? '0'}",
      age: apiData['age'] as int? ?? 0,
      openTime: apiData['opentime']?.toString() ?? '00:00',
      duration: (apiData['duration'] as num?)?.toDouble() ?? 0.0,
      roomFeatures: (apiData['hotel']?['room_features']?.split(', ') ?? []).cast<String>(),
      propertyAmenities: (apiData['hotel']?['property_amenities']?.split(', ') ?? []).cast<String>(),
      roomTypes: (apiData['hotel']?['room_types']?.split(', ') ?? []).cast<String>(),
      hotelStyles: (apiData['hotel']?['hotel_styles']?.split(', ') ?? []).cast<String>(),
      hotelLanguages: (apiData['hotel']?['languages']?.split(', ') ?? []).cast<String>(),
      star: apiData['hotel']?['hotel_class'] as int? ?? 0,
      images: imageUrls, // Sử dụng danh sách ảnh đã xử lý
      about: apiData['description']?.toString() ?? '',
      rating: (apiData['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: apiData['numOfReviews'] as int? ?? 0,
      website: apiData['hotel']?['website']?.toString() ?? 'No website available',
      email: apiData['hotel']?['email']?.toString() ?? 'No email available',
      hotelContact: apiData['hotel']?['phone']?.toString() ?? 'No contact available',
    );
  }

}
