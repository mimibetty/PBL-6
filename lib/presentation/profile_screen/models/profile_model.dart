class ProfileModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final String status;
  final String name;
  final String contactNumber;
  final Address address; // Now uses Address model
  final String description;
  final String? imageUrl;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.status,
    required this.name,
    required this.contactNumber,
    required this.address,
    required this.description,
    this.imageUrl,
  });

  // copyWith method
  ProfileModel copyWith({
    int? id,
    String? username,
    String? email,
    String? role,
    String? status,
    String? name,
    String? contactNumber,
    Address? address,
    String? description,
    String? imageUrl,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      name: name ?? this.name,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Factory to create ProfileModel from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final userInfo = json['user_info'] ?? {};
    final addressJson = userInfo['address'] ?? {};

    return ProfileModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      name: json['username'] ?? '',
      contactNumber: userInfo['phone_number'] ?? '',
      address: Address.fromJson(addressJson),
      description: userInfo['description'] ?? '',
      imageUrl: userInfo['image'] != null ? userInfo['image']['url'] : null,
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

  // Phương thức copyWith
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

  // Factory để tạo Address từ JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      district: json['district'] ?? '',
      ward: json['ward'] ?? '',
      cityId: json['city_id'] ?? 0,
    );
  }

  // Phương thức để trả về chuỗi địa chỉ có định dạng nếu cần thiết
  String formattedAddress() {
    return [street, district, ward].where((element) => element.isNotEmpty).join(', ');
  }
}

