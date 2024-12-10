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


const descriptionConst =
    'Travel places offer a wide array of experiences, each with its own unique charm and appeal. From stunning natural landscapes to historic landmarks, there is something for every traveler. Coastal TravelDestinations like tropical beaches invite relaxation with crystal-clear waters, while mountainous regions offer adventurous hiking trails and breathtaking views.';


    /////// DATABASE GIẢ TẠM THỜI 
    ///
    ///
   List<TravelDestination> danangDestinations = [
    TravelDestination(
      name: 'Bãi biển Mỹ Khê',
      address: Address(
        district: 'Quận Sơn Trà',
        street: 'Lê Đức Thọ',
        ward: 'Phường An Hải Tây',
        cityId: 1,
        id: 1,
      ),
      priceBottom: 100000,
      priceTop: 500000,
      dateCreate: DateTime(2022, 1, 1),
      age: 0,
      openTime: '8:00 - 18:00',
      duration: 2,
      id: 1,
      cityId: 1,
      hotelId: 1,
      restaurantId: 1,
      images: [
      "https://banahills.sunworld.vn/wp-content/uploads/2018/08/cap-treo-01-1-768x508.jpg",
      "https://upload.wikimedia.org/wikipedia/commons/2/27/Kali_Gandaki_Valley%2C_Road%2C_Mustang%2C_Nepal%2C_Himalaya.jpg",
      ],
      rating: 4.5,
      numOfReviews: 100,
      location: 'Quận Sơn Trà, Đà Nẵng',
      description: descriptionConst,
    ),
    TravelDestination(
      name: 'Chùa Linh Ứng',
      address: Address(
        district: 'Quận Sơn Trà',
        street: 'Lê Đức Thọ',
        ward: 'Phường An Hải Tây',
        cityId: 1,
        id: 2,
      ),
      priceBottom: 50000,
      priceTop: 200000,
      dateCreate: DateTime(2022, 1, 1),
      age: 0,
      openTime: '8:00 - 18:00',
      duration: 1,
      id: 2,
      cityId: 1,
      hotelId: 2,
      restaurantId: 2,
      images: [
      "https://upload.wikimedia.org/wikipedia/commons/0/0c/Han_River_Bridge_Apr08.jpg",
      "https://halotravel.vn/wp-content/uploads/2021/07/cau-quay-song-han-1.jpg",
      ],
      rating: 4.2,
      numOfReviews: 50,
      location: 'Quận Sơn Trà, Đà Nẵng',
      description: descriptionConst,
    ),
    // Thêm nhiều điểm đến khác tại Đà Nẵng
  ];
