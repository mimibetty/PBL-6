
import 'dart:math';

Random random = Random();

class Hotel {
  final String hotelID; // ID của khách sạn
  final String hotelName; // Tên khách sạn
  final double rating; // Đánh giá của khách sạn
  final String hotelContact; // Thông tin liên lạc
  final String hotelLocation; // Địa chỉ của khách sạn
  final double price; // Giá phòng (giá trung bình)
  final String website; // Website của khách sạn
  final String email; // Email liên hệ
  final List<String> roomFeature; // Các tính năng phòng
  final List<String> propertyAmenities; // Các tiện nghi của khách sạn
  final List<Room> rooms; // Danh sách phòng trong khách sạn
  final int star; // Số sao của khách sạn
  final List<String> images;
  final String about;
  final review;


  Hotel({
    required this.hotelID,
    required this.hotelName,
    required this.rating,
    required this.hotelContact,
    required this.hotelLocation,
    required this.price,
    required this.website,
    required this.email,
    required this.roomFeature,
    required this.propertyAmenities,
    required this.rooms,
    required this.star,
    required this.images,
    required this.review,
    required this.about,
  });

  // Phương thức để kiểm tra xem có phòng trống không tại một thời điểm nhất định
  bool isRoomAvailable(DateTime checkIn, DateTime checkOut) {
    for (var room in rooms) {
      if (room.isAvailable(checkIn, checkOut)) {
        return true; // Có ít nhất một phòng trống
      }
    }
    return false; // Không có phòng nào trống
  }
}

class Room {
  final String roomID; // ID của phòng
  final String roomType; // Loại phòng
  final double price; // Giá phòng
  final List<String> features; // Các tính năng của phòng
  final List<Booking> bookings; // Danh sách đặt phòng

  Room({
    required this.roomID,
    required this.roomType,
    required this.price,
    required this.features,
    required this.bookings,
  });

  // Phương thức để kiểm tra tính khả dụng của phòng
  bool isAvailable(DateTime checkIn, DateTime checkOut) {
    for (var booking in bookings) {
      if (booking.isConflict(checkIn, checkOut)) {
        return false; // Phòng không khả dụng do có xung đột
      }
    }
    return true; // Phòng trống
  }
}

class Booking {
  final String bookingID; // ID của đặt phòng
  final DateTime checkIn; // Ngày nhận phòng
  final DateTime checkOut; // Ngày trả phòng

  Booking({
    required this.bookingID,
    required this.checkIn,
    required this.checkOut,
  });

  // Phương thức để kiểm tra xung đột đặt phòng
  bool isConflict(DateTime newCheckIn, DateTime newCheckOut) {
    return (newCheckIn.isBefore(checkOut) && newCheckOut.isAfter(checkIn));
  }
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
    website: 'https://danang.intercontinental.com/',
    email: 'info@icdanang.com',
    roomFeature: ['Sea View', 'Free Wi-Fi', 'Breakfast Included'],
    propertyAmenities: ['Spa', 'Swimming Pool', 'Fitness Center', 'Restaurant'],
    rooms: [
      Room(
        roomID: 'R001',
        roomType: 'Deluxe Room',
        price: 250.0,
        features: ['Ocean View', 'King Size Bed'],
        bookings: [],
      ),
      Room(
        roomID: 'R002',
        roomType: 'Suite',
        price: 500.0,
        features: ['Private Pool', 'Balcony'],
        bookings: [
          Booking(bookingID: 'B001', checkIn: DateTime(2024, 10, 15), checkOut: DateTime(2024, 10, 20)),
        ],
      ),
    ],
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
    website: 'https://novotel-danang.com/',
    email: 'info@novotel-danang.com',
    roomFeature: ['Rooftop Bar', 'Infinity Pool'],
    propertyAmenities: ['Gym', 'Restaurant', 'Free Parking'],
    rooms: [
      Room(
        roomID: 'R003',
        roomType: 'Superior Room',
        price: 150.0,
        features: ['City View', 'Double Bed'],
        bookings: [],
      ),
      Room(
        roomID: 'R004',
        roomType: 'Executive Room',
        price: 300.0,
        features: ['Lounge Access', 'Complimentary Drinks'],
        bookings: [
          Booking(bookingID: 'B002', checkIn: DateTime(2024, 10, 10), checkOut: DateTime(2024, 10, 12)),
        ],
      ),
    ],
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
    website: 'https://sheratongranddanang.com/',
    email: 'info@sheratongranddanang.com',
    roomFeature: ['Private Beach', 'Luxury Amenities'],
    propertyAmenities: ['Spa', 'Water Sports', 'Restaurant'],
    rooms: [
      Room(
        roomID: 'R005',
        roomType: 'Ocean View Room',
        price: 200.0,
        features: ['Ocean View', 'Balcony'],
        bookings: [],
      ),
      Room(
        roomID: 'R006',
        roomType: 'Family Suite',
        price: 400.0,
        features: ['Two Bedrooms', 'Living Room'],
        bookings: [
          Booking(bookingID: 'B003', checkIn: DateTime(2024, 10, 20), checkOut: DateTime(2024, 10, 25)),
        ],
      ),
    ],
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
