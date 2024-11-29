class Hotel {
  final int hotelID;
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

  // URL ảnh mặc định
  static const String defaultImageUrl = 'https://experienceleaguecommunities.adobe.com/t5/image/serverpage/image-id/34749i7C7BB1DB5E28E527?v=v2';

  Hotel({
    required this.hotelID,
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
    // Kiểm tra và thay thế ảnh rỗng bằng ảnh mặc định
    List<String> imageUrls = (apiData['images'] as List<dynamic>)
        .map((img) => img['url'] as String)
        .map((url) => url.isEmpty ? defaultImageUrl : url) // Thay thế ảnh rỗng
        .toList();

    return Hotel(
      hotelID: apiData['id'] as int,
      hotelName: apiData['name'] ?? 'Unknown Hotel',
      hotelLocation: '${apiData['address']['ward']}, ${apiData['address']['district']}, ${apiData['address']['street']}',
      priceRange: "From ${apiData['price_bottom']?.toString() ?? '0'} to ${apiData['price_top']?.toString() ?? '0'}",
      age: apiData['age'] ?? 0,
      openTime: apiData['opentime'] ?? '00:00',
      duration: (apiData['duration'] ?? 0).toDouble(),
      roomFeatures: (apiData['hotel']['room_features']?.split(', ') ?? []).cast<String>(),
      propertyAmenities: (apiData['hotel']['property_amenities']?.split(', ') ?? []).cast<String>(),
      roomTypes: (apiData['hotel']['room_types']?.split(', ') ?? []).cast<String>(),
      hotelStyles: (apiData['hotel']['hotel_styles']?.split(', ') ?? []).cast<String>(),
      hotelLanguages: (apiData['hotel']['Languages']?.split(', ') ?? []).cast<String>(),
      star: apiData['hotel']['hotel_class'] ?? 0,
      images: imageUrls,
      about: apiData['description'] ?? '',
      rating: (apiData['rating'] ?? 0).toDouble(),
      reviewCount: apiData['numOfReviews'] ?? 0,
      website: apiData['hotel']['website'] ?? 'No website available',
      email: apiData['hotel']['email'] ?? 'No email available',
      hotelContact: apiData['hotel']['phone'] ?? 'No contact available',
    );
  }
}


// Mock database cho các khách sạn ở Đà Nẵng
List<Hotel> mockHotels = [
  Hotel(
    hotelID: 1,
    hotelName: 'InterContinental Danang Sun Peninsula Resort',
    rating: 4.2,
    hotelContact: '+84 236 3888 888',
    hotelLocation: 'Bãi Bụt, Thọ Quang, Đà Nẵng',
    priceRange: "250",
    age: 18,
    openTime: "00:00:00",
    duration : 24,
    hotelStyles: ["Luxury", "Modern"],
    hotelLanguages: ["English", "Vietnamese"],
    website: 'https://danang.intercontinental.com/',
    email: 'info@icdanang.com',
    roomFeatures: ['Sea View', 'Free Wi-Fi', 'Breakfast Included'],
    propertyAmenities: ['Spa', 'Swimming Pool', 'Fitness Center', 'Restaurant'],
    roomTypes: ["Suite, Deluxe"],
    star: 5,
    images:[
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/09/14/cd/bai-bac-bay-villa-aerial.jpg?w=1400&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2c/8d/6e/bb/citron-buffet-spread.jpg?w=900&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/6c/9e/63/intercontinental-danang.jpg?w=1400&h=-1&s=1",
    ],
    reviewCount: 25,
    about:"Ocean Breeze Hotel là một điểm dừng chân lý tưởng cho những ai yêu thích sự yên bình và thiên nhiên. Nằm ở vị trí ven biển tuyệt đẹp tại Đà Nẵng, khách sạn cung cấp các phòng nghỉ tiện nghi với tầm nhìn ra đại dương. Chúng tôi có các dịch vụ spa, hồ bơi vô cực và nhà hàng phục vụ ẩm thực quốc tế. Hãy đến và trải nghiệm một kỳ nghỉ thư giãn bên bờ biển!"

  
  ),
  Hotel(
    hotelID: 2,
    hotelName: 'Novotel Danang Premier Han River',
    rating: 4.8,
    hotelContact: '+84 236 3929 888',
    hotelLocation: '36 Bach Dang, Hai Chau, Đà Nẵng',
    priceRange: "250",
    age: 18,
    openTime: "00:00:00",
    duration : 24,
    hotelStyles: ["Luxury", "Modern"],
    hotelLanguages: ["English", "Vietnamese"],
    website: 'https://novotel-danang.com/',
    email: 'info@novotel-danang.com',
    roomFeatures: ['Rooftop Bar', 'Infinity Pool'],
    propertyAmenities: ['Gym', 'Restaurant', 'Free Parking'],
    roomTypes: ["Suite, Deluxe"],
    star: 4,
    images:[
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/ab/6f/49/guest-room.jpg?w=1100&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/a6/ca/4d/meeting-room.jpg?w=1100&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/a6/ca/4e/breakfast-area.jpg?w=1100&h=-1&s=1",
    ],
    reviewCount: 25,
    about:"Tại Sunset Paradise, bạn sẽ được trải nghiệm sự sang trọng và thoải mái tối đa. Chúng tôi cung cấp các phòng nghỉ hiện đại với thiết kế tinh tế và các tiện nghi đẳng cấp. Tọa lạc gần các điểm tham quan nổi tiếng, khách sạn là lựa chọn hoàn hảo cho cả du khách và doanh nhân. Hãy tham gia các hoạt động giải trí và khám phá ẩm thực đa dạng tại nhà hàng của chúng tôi! "

  ),
  Hotel(
    hotelID: 3,
    hotelName: 'Sheraton Grand Danang Resort',
    rating: 5,
    hotelContact: '+84 236 3989 999',
    hotelLocation: 'Trường Sa, Hòa Hải, Đà Nẵng',
    priceRange: "250",
    age: 18,
    openTime: "00:00:00",
    duration : 24,
    hotelStyles: ["Luxury", "Modern"],
    hotelLanguages: ["English", "Vietnamese"],
    website: 'https://sheratongranddanang.com/',
    email: 'info@sheratongranddanang.com',
    roomFeatures: ['Private Beach', 'Luxury Amenities'],
    propertyAmenities: ['Spa', 'Water Sports', 'Restaurant'],
    roomTypes: ["Suite, Deluxe"],
    star: 5,
    images:[
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/20/46/5d/sheraton-grand-danang.jpg?w=1400&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/20/34/81/deluxe-plunge-pool-terrace.jpg?w=1400&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/20/45/fd/lobby.jpg?w=1400&h=-1&s=1"
    ],
    reviewCount: 25,
    about:"Green Haven Hotel là sự kết hợp hoàn hảo giữa thiên nhiên và sự hiện đại. Với các khu vườn xanh tươi, không gian yên tĩnh và các phòng nghỉ đầy đủ tiện nghi, khách sạn của chúng tôi là nơi lý tưởng để bạn thư giãn và nạp lại năng lượng. Tham gia các hoạt động thể thao dưới nước và khám phá vẻ đẹp của Đà Nẵng từ khách sạn của chúng tôi!",
  ),
];