class TravelDestination {
  final String name;
  final Address address;
  final int priceBottom;
  final int priceTop;
  final DateTime dateCreate;
  final int age;
  final String openTime;
  final int duration;
  final int id;
  final int cityId;
  final int? hotelId;
  final int? restaurantId;
  final List<String> images; // List of image URLs
  final double rating;
  final int numOfReviews;
  final String location;
  final String description;

  TravelDestination({
    required this.name,
    required this.address,
    required this.priceBottom,
    required this.priceTop,
    required this.dateCreate,
    required this.age,
    required this.openTime,
    required this.duration,
    required this.id,
    required this.cityId,
    this.hotelId,
    this.restaurantId,
    required this.images,
    required this.rating,
    required this.numOfReviews,
    required this.location,
    required this.description,
  });

  factory TravelDestination.fromJson(Map<String, dynamic> json) {
    // Default image URL if none exists
    const String defaultImageUrl = 'https://experienceleaguecommunities.adobe.com/t5/image/serverpage/image-id/34749i7C7BB1DB5E28E527?v=v2';

    return TravelDestination(
      name: json['name'] ?? 'Unknown Destination', // Default if `name` is null
      address: Address.fromJson(json['address'] ?? {}),
      priceBottom: json['price_bottom'] ?? 0,
      priceTop: json['price_top'] ?? 0,
      dateCreate: DateTime.tryParse(json['date_create'] ?? '') ?? DateTime.now(),
      age: json['age'] ?? 0,
      openTime: json['opentime'] ?? '00:00',
      duration: json['duration'] ?? 0,
      id: json['id'] ?? 0,
      cityId: json['city_id'] ?? 0,
      hotelId: json['hotel_id'] ?? null,
      restaurantId: json['restaurant_id'] ?? null,
      images: json['images'] != null && json['images'].isNotEmpty 
          ? List<String>.from(
              json['images'].map((image) => image['url'] ?? defaultImageUrl)
            )
          : [defaultImageUrl], // Use default image if `images` is empty

      rating: (json['rating'] ?? 0).toDouble(),
      numOfReviews: json['numOfReviews'] ?? 0,
      location: json['district'] != null && json['district']['city_name'] != null
          ? '${json['district']['city_name']}'
          : 'Unknown Location',
      description: json['description'] ?? 'No description available',
    );
  }
}

class Address {
  final String district;
  final String street;
  final String ward;
  final int cityId;
  final int id;

  Address({
    required this.district,
    required this.street,
    required this.ward,
    required this.cityId,
    required this.id,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      district: json['district'] ?? 'Unknown District',
      street: json['street'] ?? 'Unknown Street',
      ward: json['ward'] ?? 'Unknown Ward',
      cityId: json['city_id'] ?? 0,
      id: json['id'] ?? 0,
    );
  }
}
