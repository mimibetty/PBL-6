class Trip {
  final String name;
  final String monthTime;
  final int duration;
  final int userId;
  final bool isAI;
  final int id;
  final List<TripDestination> tripDestinations;
  String? cityName; // City name associated with the trip
  String? imageUrl; // URL of the image representing the city

  Trip({
    required this.name,
    required this.monthTime,
    required this.duration,
    required this.userId,
    required this.isAI,
    required this.id,
    required this.tripDestinations,
    this.cityName,
    this.imageUrl,
  });

  // Factory constructor to parse JSON
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      name: json['name'],
      monthTime: json['month_time'],
      duration: json['duration'],
      userId: json['user_id'],
      isAI: json['isAI'],
      id: json['id'],
      tripDestinations: (json['trip_destinations'] as List)
          .map((destination) => TripDestination.fromJson(destination))
          .toList(),
    );
  }

  // Method to check if the trip is AI-generated
  bool checkIsAI() {
    return isAI;
  }
}

class TripDestination {
  final int destinationId;
  final int tripId;
  final int order;
  final int day;

  TripDestination({
    required this.destinationId,
    required this.tripId,
    required this.order,
    required this.day,
  });

  // Factory constructor to parse JSON
  factory TripDestination.fromJson(Map<String, dynamic> json) {
    return TripDestination(
      destinationId: json['destination_id'],
      tripId: json['trip_id'],
      order: json['order'],
      day: json['day'],
    );
  }
}
