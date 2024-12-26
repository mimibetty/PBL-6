
import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';

class Tour {
  final int id;
  final String name;
  final String description;
  final int duration;
  final int userId;
  final int cityId;
  final List<TravelDestination> destinations;
  final double rating;
  final int numOfReviews;

  Tour({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.userId,
    required this.cityId,
    required this.destinations,
    required this.rating,
    required this.numOfReviews,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      duration: json['duration'] ?? 0,
      userId: json['user_id'] ?? 0,
      cityId: json['city_id'] ?? 0,
      destinations: (json['destinations'] as List<dynamic>)
          .map((destination) =>
              TravelDestination.fromJson(destination as Map<String, dynamic>))
          .toList(),
      rating: (json['rating'] ?? 0).toDouble(),
      numOfReviews: json['numOfReviews'] ?? 0,
    );
  }
}

/// Get all unique images from a tour
List<String> getImagesFromTour(Tour tour) {
  final Set<String> images = {};
  for (var destination in tour.destinations) {
    images.addAll(destination.images);
  }
  return images.toList();
}

/// Get the first non-null image from a tour
String getFirstImageFromTour(Tour tour) {
  for (var destination in tour.destinations) {
    if (destination.images.isNotEmpty) {
      return destination.images.first;
    }
  }
  // Default image if no images are found
  return 'https://experienceleaguecommunities.adobe.com/t5/image/serverpage/image-id/34749i7C7BB1DB5E28E527?v=v2';
}

/// Generate a readable duration text from an integer duration in hours
String getDurationText(int duration) {
  int days = duration ~/ 24; // Whole days
  double fraction = (duration % 24) / 24; // Fraction of a day

  String result = days > 0 ? (days == 1 ? 'One Day' : '${_numberToWords(days)} Days') : '';
  if (fraction > 0.5) {
    result += result.isNotEmpty ? ' and Half' : 'Half';
  }

  return result.isNotEmpty ? result : 'Less than a day'; // Handle zero duration
}

/// Convert small numbers to words (up to 10)
String _numberToWords(int number) {
  const words = [
    'Zero',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten'
  ];
  return number >= 0 && number <= 10 ? words[number] : number.toString();
}

/// Calculate the total bottom price of all destinations in a tour
int calculateTourBottomPrice(Tour tour) {
  return tour.destinations.fold(0, (sum, destination) => sum + (destination.priceBottom ?? 0));
}

/// Calculate the total top price of all destinations in a tour
int calculateTourTopPrice(Tour tour) {
  return tour.destinations.fold(0, (sum, destination) => sum + (destination.priceTop ?? 0));
}

/// Get the earliest open time from all destinations in a tour
String getMinOpenTime(Tour tour) {
  // Filter and parse valid open times, then find the earliest
  List<TimeOfDay> openTimes = tour.destinations
      .map((destination) {
        try {
          List<String> parts = destination.openTime.split(':');
          return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        } catch (e) {
          return null; // Skip invalid open times
        }
      })
      .where((time) => time != null)
      .cast<TimeOfDay>()
      .toList();

  if (openTimes.isEmpty) {
    return '00:00'; // Default value if no valid open times are found
  }

  // Sort open times to get the earliest
  openTimes.sort((a, b) {
    int hourComparison = a.hour.compareTo(b.hour);
    return hourComparison != 0 ? hourComparison : a.minute.compareTo(b.minute);
  });

  // Convert the earliest time back to a string
  TimeOfDay earliest = openTimes.first;
  return '${earliest.hour.toString().padLeft(2, '0')}:${earliest.minute.toString().padLeft(2, '0')}';
}

/// Get the minimum age requirement across all destinations in a tour
int getMinAge(Tour tour) {
  // Filter valid ages and find the minimum
  List<int> ages = tour.destinations
      .map((destination) => destination.age)
      .where((age) => age > 0)
      .toList();

  if (ages.isEmpty) {
    return 0; // Default value if no valid ages are found
  }

  return ages.reduce((min, current) => current < min ? current : min);
}



// final List<Tour> mockTours = [
//   Tour(
//     id: 1,
//     name: "Hanoi Adventure",
//     description: "Khám phá Hà Nội với chuyến đi đầy thú vị.",
//     duration: 48,
//     userId: 1,
//     cityId: 3,
//     rating: 4.0,
//     numOfReviews: 5,
//     destinations: [
//       TravelDestination(
//         name: "Hoan Kiem Lake",
//         address: Address(
//           district: "Hoan Kiem",
//           street: "Dinh Tien Hoang Street",
//           ward: "Trang Tien",
//           cityId: 1,
//           id: 1,
//         ),
//         priceBottom: 0,
//         priceTop: 100000,
//         dateCreate: DateTime.now(),
//         age: 12,
//         openTime: "06:00",
//         duration: 24,
//         id: 101,
//         cityId: 1,
//         hotelId: 10,
//         restaurantId: 20,
//         images: [
//            "https://tripstoragepbl6.blob.core.windows.net/travel-image/destinations/336.png",
//            "https://tripstoragepbl6.blob.core.windows.net/travel-image/destinations/337.png"
//         ],
//         rating: 4.5,
//         numOfReviews: 150,
//         location: "Dinh Tien Hoang Street, Trang Tien, Hoan Kiem, Hanoi",
//         description: "Hồ Gươm là trái tim của Hà Nội.",
//       ),
//       TravelDestination(
//         name: "Temple of Literature",
//         address: Address(
//           district: "Dong Da",
//           street: "Van Mieu Street",
//           ward: "Van Chuong",
//           cityId: 1,
//           id: 2,
//         ),
//         priceBottom: 30000,
//         priceTop: 50000,
//         dateCreate: DateTime.now(),
//         age: 10,
//         openTime: "08:00",
//         duration: 36,
//         id: 102,
//         cityId: 1,
//         hotelId: null,
//         restaurantId: null,
//         images: [
//           "https://tripstoragepbl6.blob.core.windows.net/travel-image/destinations/188.png",
//           "https://tripstoragepbl6.blob.core.windows.net/travel-image/destinations/189.png",
//           "https://tripstoragepbl6.blob.core.windows.net/travel-image/destinations/190.png"
//         ],
//         rating: 4.8,
//         numOfReviews: 200,
//         location: "Van Mieu Street, Van Chuong, Dong Da, Hanoi",
//         description: "Văn Miếu Quốc Tử Giám, biểu tượng văn hóa ngàn năm.",
//       ),
//     ],
//   ),
//   Tour(
//     id: 2,
//     name: "Da Nang Highlights",
//     description: "Khám phá thành phố Đà Nẵng với những điểm đến tuyệt vời.",
//     duration: 24,
//     userId: 2,
//     cityId: 3,
//     rating: 4.5,
//     numOfReviews: 10,
//     destinations: [
//       TravelDestination(
//         name: "Golden Bridge",
//         address: Address(
//           district: "Hoa Vang",
//           street: "Ba Na Hills",
//           ward: "Hoa Ninh",
//           cityId: 2,
//           id: 3,
//         ),
//         priceBottom: 500000,
//         priceTop: 700000,
//         dateCreate: DateTime.now(),
//         age: 5,
//         openTime: "07:00",
//         duration: 48,
//         id: 201,
//         cityId: 2,
//         hotelId: 15,
//         restaurantId: null,
//         images: [
//           "https://tripstoragepbl6.blob.core.windows.net/travel-image/destinations/192.png",
//           "https://tripstoragepbl6.blob.core.windows.net/travel-image/destinations/193.png"
//         ],
//         rating: 4.9,
//         numOfReviews: 500,
//         location: "Ba Na Hills, Hoa Ninh, Hoa Vang, Da Nang",
//         description: "Cầu Vàng, điểm đến biểu tượng của Đà Nẵng.",
//       ),
//       TravelDestination(
//         name: "Dragon Bridge",
//         address: Address(
//           district: "Hai Chau",
//           street: "Nguyen Van Linh Street",
//           ward: "Hoa Cuong",
//           cityId: 2,
//           id: 4,
//         ),
//         priceBottom: 0,
//         priceTop: 0,
//         dateCreate: DateTime.now(),
//         age: 0,
//         openTime: "00:00",
//         duration: 12,
//         id: 202,
//         cityId: 2,
//         hotelId: null,
//         restaurantId: null,
//         images: [
//           "https://tripstoragepbl6.blob.core.windows.net/travel-image/destinations/dragon_bridge.jpg",
//         ],
//         rating: 4.7,
//         numOfReviews: 300,
//         location: "Nguyen Van Linh Street, Hoa Cuong, Hai Chau, Da Nang",
//         description: "Cầu Rồng, nơi diễn ra màn trình diễn lửa và nước hấp dẫn.",
//       ),
//     ],
//   ),
// ];


