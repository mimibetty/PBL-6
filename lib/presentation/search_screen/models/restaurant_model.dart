class Restaurant {
  final String restaurantName;
  final int destinationID;
  final int restaurantID;
  final String contactNumber;
  final String website;
  final String openTime;
  final double duration;
  final int age;
  final double rating;
  final List<String> cuisines;
  final List<String> meal;
  final List<String> feature;
  final String about;
  final List<String> images;
  final String restaurantLocation;
  final int review;
  final String priceRange;

  static const String defaultImageUrl = 'https://example.com/default_image.jpg';

  Restaurant({
    required this.restaurantName,
    required this.destinationID,
    required this.restaurantID,
    required this.contactNumber,
    required this.website,
    required this.openTime,
    required this.duration,
    required this.age,
    required this.rating,
    required this.cuisines,
    required this.meal,
    required this.feature,
    required this.about,
    required this.images,
    required this.restaurantLocation,
    required this.review,
    required this.priceRange,
  });

  factory Restaurant.fromApi(Map<String, dynamic> apiData) {
    String priceRange =
        "From ${apiData['price_bottom']?.toString() ?? '0'} to ${apiData['price_top']?.toString() ?? '0'}";

    String restaurantLocation = '${apiData['address']?['ward'] ?? 'Unknown Ward'}, '
        '${apiData['address']?['district'] ?? 'Unknown District'}, '
        '${apiData['address']?['street'] ?? 'Unknown Street'}';

    List<String> images = (apiData['images'] as List<dynamic>? ?? [])
        .map((img) => img['url'] as String? ?? defaultImageUrl)
        .map((url) => url.isEmpty ? defaultImageUrl : url)
        .toList();

    if (images.isEmpty) {
      images.add(defaultImageUrl);
    }

    return Restaurant(
      restaurantName: apiData['name'] ?? 'Unknown Restaurant',
      destinationID: apiData['id'] as int? ?? 0,
      restaurantID: apiData['restaurant_id'] as int? ?? 0,
      contactNumber: apiData['restaurant']?['phone']?.toString() ?? 'No contact available',
      website: apiData['restaurant']?['website']?.toString() ?? 'No website available',
      openTime: apiData['opentime']?.toString() ?? '00:00',
      duration: (apiData['duration'] as num?)?.toDouble() ?? 0.0,
      age: apiData['age'] as int? ?? 0,
      rating: (apiData['average_rating'] as num?)?.toDouble() ?? 0.0,
      cuisines: (apiData['restaurant']?['cuisine']?.split(', ') ?? []).cast<String>(),
      meal: (apiData['restaurant']?['special_diet']?.split(', ') ?? []).cast<String>(),
      feature: (apiData['restaurant']?['feature']?.split(', ') ?? []).cast<String>(),
      about: apiData['description']?.toString() ?? 'No description available',
      images: images,
      restaurantLocation: restaurantLocation,
      review: apiData['review_count'] as int? ?? 0,
      priceRange: priceRange,
    );
  }
}
