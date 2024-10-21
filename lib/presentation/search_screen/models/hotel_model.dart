
import 'dart:math';

Random random = Random();

class Hotel {
  final String hotelID; // ID của khách sạn //"hotel_id"
  final String hotelName; // Tên khách sạn //"name"
  final String hotelLocation; // Địa chỉ của khách sạn //"address"
  final double price; // Giá phòng (giá trung bình) //"price_top"
  final int age; // Độ tuổi vào khách sạn //"age"
  final String openTime; //Thời gian mở khách sạn // "opentime"
  final double duration; //Thời gian mở cửa khách sạn kể từ lúc mở "duration"
  final List<String> roomFeature; // Các tính năng phòng //"hotel"->"room_features"
  final List<String> propertyAmenities; // Các tiện nghi của khách sạn// "hotel" -> "property_amenities" 
  final List<String> roomTypes; // Danh sách phòng trong khách sạn "hotel" -> "room_types"
  final List<String> hotelStyle; // Thể loại khách hạn // "hotel" -> "hotel_styles"
  final List<String> hotelLanguage; // Ngôn ngữ dùng tại khách sạn // "hotel" -> "Languages"
  final int star; // Số sao của khách sạn "hotel" -> "hotel_class"
  final List<String> images; // hình ảnh khách sạn
  final String about; //description
  final double rating; // Đánh giá của khách sạn // 
  final int review;
  final String website; // Website của khách sạn
  final String email; // Email liên hệ
  final String hotelContact; // Thông tin liên lạc


  Hotel({
    required this.hotelID,
    required this.hotelName,
    required this.hotelLocation,
    required this.price,
    required this.age,
    required this.openTime,
    required this.duration,
    required this.roomFeature,
    required this.propertyAmenities,  
    required this.roomTypes,
    required this.hotelStyle,
    required this.hotelLanguage,
    required this.star,
    required this.images,
    required this.about,
    required this.rating,
    required this.review,
    required this.website,
    required this.email,
    required this.hotelContact,
  });
}

// Mock database cho các khách sạn ở Đà Nẵng
List<Hotel> mockHotels = [
  Hotel(
    hotelID: 'H001',
    hotelName: 'InterContinental Danang Sun Peninsula Resort',
    rating: 4.2,
    hotelContact: '+84 236 3888 888',
    hotelLocation: 'Bãi Bụt, Thọ Quang, Đà Nẵng',
    price: 250.0,
    age: 18,
    openTime: "00:00:00",
    duration : 24,
    hotelStyle: ["Luxury", "Modern"],
    hotelLanguage: ["English", "Vietnamese"],
    website: 'https://danang.intercontinental.com/',
    email: 'info@icdanang.com',
    roomFeature: ['Sea View', 'Free Wi-Fi', 'Breakfast Included'],
    propertyAmenities: ['Spa', 'Swimming Pool', 'Fitness Center', 'Restaurant'],
    roomTypes: ["Suite, Deluxe"],
    star: 5,
    images:[
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/09/14/cd/bai-bac-bay-villa-aerial.jpg?w=1400&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2c/8d/6e/bb/citron-buffet-spread.jpg?w=900&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/6c/9e/63/intercontinental-danang.jpg?w=1400&h=-1&s=1",
    ],
    review: random.nextInt(300) + 25,
    about:"Ocean Breeze Hotel là một điểm dừng chân lý tưởng cho những ai yêu thích sự yên bình và thiên nhiên. Nằm ở vị trí ven biển tuyệt đẹp tại Đà Nẵng, khách sạn cung cấp các phòng nghỉ tiện nghi với tầm nhìn ra đại dương. Chúng tôi có các dịch vụ spa, hồ bơi vô cực và nhà hàng phục vụ ẩm thực quốc tế. Hãy đến và trải nghiệm một kỳ nghỉ thư giãn bên bờ biển!"

  
  ),
  Hotel(
    hotelID: 'H002',
    hotelName: 'Novotel Danang Premier Han River',
    rating: 4.8,
    hotelContact: '+84 236 3929 888',
    hotelLocation: '36 Bach Dang, Hai Chau, Đà Nẵng',
    price: 150.0,
    age: 18,
    openTime: "00:00:00",
    duration : 24,
    hotelStyle: ["Luxury", "Modern"],
    hotelLanguage: ["English", "Vietnamese"],
    website: 'https://novotel-danang.com/',
    email: 'info@novotel-danang.com',
    roomFeature: ['Rooftop Bar', 'Infinity Pool'],
    propertyAmenities: ['Gym', 'Restaurant', 'Free Parking'],
    roomTypes: ["Suite, Deluxe"],
    star: 4,
    images:[
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/ab/6f/49/guest-room.jpg?w=1100&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/a6/ca/4d/meeting-room.jpg?w=1100&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/a6/ca/4e/breakfast-area.jpg?w=1100&h=-1&s=1",
    ],
    review: random.nextInt(300) + 25,
    about:"Tại Sunset Paradise, bạn sẽ được trải nghiệm sự sang trọng và thoải mái tối đa. Chúng tôi cung cấp các phòng nghỉ hiện đại với thiết kế tinh tế và các tiện nghi đẳng cấp. Tọa lạc gần các điểm tham quan nổi tiếng, khách sạn là lựa chọn hoàn hảo cho cả du khách và doanh nhân. Hãy tham gia các hoạt động giải trí và khám phá ẩm thực đa dạng tại nhà hàng của chúng tôi! "

  ),
  Hotel(
    hotelID: 'H003',
    hotelName: 'Sheraton Grand Danang Resort',
    rating: 5,
    hotelContact: '+84 236 3989 999',
    hotelLocation: 'Trường Sa, Hòa Hải, Đà Nẵng',
    price: 200.0,
    age: 18,
    openTime: "00:00:00",
    duration : 24,
    hotelStyle: ["Luxury", "Modern"],
    hotelLanguage: ["English", "Vietnamese"],
    website: 'https://sheratongranddanang.com/',
    email: 'info@sheratongranddanang.com',
    roomFeature: ['Private Beach', 'Luxury Amenities'],
    propertyAmenities: ['Spa', 'Water Sports', 'Restaurant'],
    roomTypes: ["Suite, Deluxe"],
    star: 5,
    images:[
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/20/46/5d/sheraton-grand-danang.jpg?w=1400&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/20/34/81/deluxe-plunge-pool-terrace.jpg?w=1400&h=-1&s=1",
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/20/45/fd/lobby.jpg?w=1400&h=-1&s=1"
    ],
    review: random.nextInt(300) + 25,
    about:"Green Haven Hotel là sự kết hợp hoàn hảo giữa thiên nhiên và sự hiện đại. Với các khu vườn xanh tươi, không gian yên tĩnh và các phòng nghỉ đầy đủ tiện nghi, khách sạn của chúng tôi là nơi lý tưởng để bạn thư giãn và nạp lại năng lượng. Tham gia các hoạt động thể thao dưới nước và khám phá vẻ đẹp của Đà Nẵng từ khách sạn của chúng tôi!",
  ),
];
