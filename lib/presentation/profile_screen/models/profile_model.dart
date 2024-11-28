class ProfileModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final String status;
  final UserInfo? userInfo; // Allows nullable UserInfo

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.status,
    this.userInfo,
  });

  // copyWith method
  ProfileModel copyWith({
    int? id,
    String? username,
    String? email,
    String? role,
    String? status,
    UserInfo? userInfo,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
    );
  }

  // Factory to create ProfileModel from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final userInfoJson = json['user_info'];

    return ProfileModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      userInfo: userInfoJson != null
          ? UserInfo.fromJson(userInfoJson)
          : UserInfo.empty(), // Use default empty UserInfo
    );
  }
}

class UserInfo {
  final int id;
  final String description;
  final String phoneNumber;
  final String? imageUrl;
  final Address address;

  UserInfo({
    required this.id,
    required this.description,
    required this.phoneNumber,
    this.imageUrl,
    required this.address,
  });

  // copyWith method
  UserInfo copyWith({
    int? id,
    String? description,
    String? phoneNumber,
    String? imageUrl,
    Address? address,
  }) {
    return UserInfo(
      id: id ?? this.id,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
    );
  }

  // Factory to create UserInfo from JSON
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      imageUrl: json['image']?['url'], // Safe navigation
      address: Address.fromJson(json['address'] ?? {}),
    );
  }

  // Default empty UserInfo
  factory UserInfo.empty() {
    return UserInfo(
      id: 0,
      description: '',
      phoneNumber: '',
      imageUrl: null,
      address: Address.empty(),
    );
  }
}

class Address {
  final String street;
  final String district;
  final String ward;
  final int cityId;

  Address({
    required this.street,
    required this.district,
    required this.ward,
    required this.cityId,
  });

  // copyWith method
  Address copyWith({
    String? street,
    String? district,
    String? ward,
    int? cityId,
  }) {
    return Address(
      street: street ?? this.street,
      district: district ?? this.district,
      ward: ward ?? this.ward,
      cityId: cityId ?? this.cityId,
    );
  }

  // Factory to create Address from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      cityId: json['city_id'] ?? 0,
    );
  }

  // Default empty Address
  factory Address.empty() {
    return Address(
      street: '',
      district: '',
      ward: '',
      cityId: 0,
    );
  }

  // Method to format the address as a string
  String formattedAddress() {
    return [street, district, ward]
        .where((element) => element.isNotEmpty)
        .join(', ');
  }
}
