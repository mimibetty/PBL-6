class ThingsToDoModel {
  final String name;
  final int id;
  final int priceBottom;
  final int priceTop;
  final DateTime dateCreate;
  final int age;
  final String openTime;
  final double duration;
  final String description;
  final List<Tag> tags;
  final Address address;
  final List<String> images;
  final double rating;
  final int numOfReviews;

  ThingsToDoModel({
    required this.name,
    required this.id,
    required this.priceBottom,
    required this.priceTop,
    required this.dateCreate,
    required this.age,
    required this.openTime,
    required this.duration,
    required this.description,
    required this.tags,
    required this.address,
    required this.images,
    required this.rating,
    required this.numOfReviews,
  });

  // Factory constructor to create a ThingsToDoModel object from JSON
  factory ThingsToDoModel.fromApi(Map<String, dynamic> apiData) {
    // Parse address
    Address address = Address(
      district: apiData['address']['district'],
      street: apiData['address']['street'],
      ward: apiData['address']['ward'],
      cityId: apiData['address']['city_id'],
      id: apiData['address']['id'],
    );

    // Parse tags
    List<Tag> tags = (apiData['tags'] as List<dynamic>)
        .map((tag) => Tag(name: tag['name'], id: tag['id']))
        .toList();

    // Parse images and provide a default image if the URL is empty or null
    List<String> images = (apiData['images'] as List<dynamic>).map((img) {
      String imageUrl = img['url'] as String? ?? '';
      // Use default image if the URL is empty
      return imageUrl.isEmpty
          ? 'https://experienceleaguecommunities.adobe.com/t5/image/serverpage/image-id/34749i7C7BB1DB5E28E527?v=v2'
          : imageUrl;
    }).toList();

    return ThingsToDoModel(
      name: apiData['name'] ?? 'Unknown Place',
      id: apiData['id'] ?? 0,
      priceBottom: apiData['price_bottom'] ?? 0,
      priceTop: apiData['price_top'] ?? 0,
      dateCreate: DateTime.parse(apiData['date_create'] ?? DateTime.now().toIso8601String()),
      age: apiData['age'] ?? 0,
      openTime: apiData['opentime'] ?? '00:00',
      duration: (apiData['duration'] ?? 0).toDouble(),
      description: apiData['description'] ?? 'No description available',
      tags: tags,
      address: address,
      images: images,
      rating: (apiData['average_rating'] ?? 0).toDouble(),
      numOfReviews: apiData['review_count'] ?? 0,
    );
  }
}

// Supporting classes
class Tag {
  final String name;
  final int id;

  Tag({
    required this.name,
    required this.id,
  });

  // Factory constructor to create a Tag object from JSON
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'] ?? 'Unknown', // Gán giá trị mặc định nếu 'name' bị thiếu
      id: json['id'] ?? 0, // Gán giá trị mặc định nếu 'id' bị thiếu
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
}
