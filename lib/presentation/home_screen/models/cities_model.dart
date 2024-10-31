class CityModel {
  final int id;
  final String name;
  final String description;
  final List<ImageModel> images;
  final String region; // Thêm field region

  CityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.region,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    // Sử dụng dictionary cityRegionMap để lấy region từ id
    String region = cityRegionMap[json['id']] ?? 'Unknown';

    return CityModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      images: (json['images'] as List)
          .map((imageJson) => ImageModel.fromJson(imageJson))
          .toList(),
      region: region,
    );
  }
}

class ImageModel {
  final int id;
  final String url;

  ImageModel({
    required this.id,
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      url: json['url'],
    );
  }
}

final Map<int, String> cityRegionMap = {
  1: 'Northern Vietnam',
  2: 'Southern Vietnam',
  3: 'Central Vietnam',
  4: 'Northern Vietnam',
  5: 'Central Vietnam',
  6: 'Southern Vietnam',
  7: 'Central Vietnam',
  8: 'Northern Vietnam',
  9: 'Northern Vietnam',
  10: 'Southern Vietnam',
  11: 'Central Vietnam',
  12: 'Northern Vietnam',
  13: 'Northern Vietnam',
  14: 'Northern Vietnam',
  15: 'Northern Vietnam',
  16: 'Northern Vietnam',
  17: 'Northern Vietnam',
  18: 'Northern Vietnam',
  19: 'Central Vietnam',
  20: 'Central Vietnam',
  21: 'Central Vietnam',
  22: 'Central Vietnam',
  23: 'Central Vietnam',
  24: 'Central Vietnam',
  25: 'Central Vietnam',
  26: 'Central Vietnam',
  27: 'Central Vietnam',
  28: 'Central Vietnam',
  29: 'Central Vietnam',
  30: 'Central Vietnam',
  31: 'Southern Vietnam',
  32: 'Southern Vietnam',
  33: 'Southern Vietnam',
  34: 'Southern Vietnam',
  35: 'Southern Vietnam',
  36: 'Southern Vietnam',
  37: 'Southern Vietnam',
  38: 'Southern Vietnam',
  39: 'Southern Vietnam',
  40: 'Southern Vietnam',
  // Thêm các tỉnh còn lại
};