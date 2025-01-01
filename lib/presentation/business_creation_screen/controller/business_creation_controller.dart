import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class DestinationController extends ChangeNotifier {
  final String baseUrl =
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net';

  // Tạo Destination và trả về destinationId
  Future<int?> createDestination({
    required int userId,
    required String name,
    required String district,
    required String street,
    required String ward,
    required int cityId,
    required int priceBottom,
    required int priceTop,
    required DateTime dateCreate,
    required int age,
    required String openTime,
    required int duration,
    required String description,
    required List<File> images,
  }) async {
    try {
      // Định dạng lại ngày tháng trước khi gửi
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateCreate);

      // In ra dữ liệu trước khi gửi tới API
      print("Business Information before call api:");
      print("0. User ID: $userId");
      print("1. Name: $name");
      print(
          "2. Address: district: $district, street: $street, ward: $ward, cityId: $cityId");
      print("3. Price Bottom: $priceBottom");
      print("4. Price Top: $priceTop");
      print("5. Date Created: $formattedDate");
      print("6. Age: $age");
      print("7. Open Time: $openTime");
      print("8. Duration: $duration");
      print("9. City ID: $cityId");
      print("10. Description: $description");
      print("11. Images: ${images.map((file) => file.path).toList()}");

      final destinationUrl = Uri.parse('$baseUrl/destination/');

      var request = http.MultipartRequest('POST', destinationUrl);
      request.fields['user_id'] = userId.toString();
      request.fields['name'] = name;
      request.fields['price_bottom'] = priceBottom.toString();
      request.fields['price_top'] = priceTop.toString();
      request.fields['age'] = age.toString();
      request.fields['opentime'] = openTime;
      request.fields['duration'] = duration.toString();
      request.fields['description'] = description;
      request.fields['date_create'] = formattedDate;
      request.fields['district'] = district;
      request.fields['street'] = street;
      request.fields['ward'] = ward;
      request.fields['city_id'] = cityId.toString();

      // Thêm các tệp ảnh vào request
      for (var image in images) {
        request.files.add(await http.MultipartFile.fromPath(
            'images', image.path,
            filename: image.uri.pathSegments.last)); // Đảm bảo gửi tên tệp đúng
      }

      // Gửi yêu cầu
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final destinationData = json.decode(responseBody);

        // Kiểm tra dữ liệu trước khi truy cập
        if (destinationData != null &&
            destinationData is Map &&
            destinationData.containsKey('id')) {
          final destinationId = destinationData['id'];
          print("Destination created successfully. ID: $destinationId");
          return destinationId;
        } else {
          print("Error: No valid 'id' found in the response data.");
          throw Exception('Failed to find a valid ID in destination data');
        }
      } else {
        print('Error creating destination: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        print('Error creating destination: $responseBody');
        throw Exception('Failed to create destination');
      }
    } catch (e) {
      print("Error creating destination: $e");
      return null;
    }
  }

  // Tạo Hotel từ destinationId
  Future<void> createHotel({
    required int destinationId,
    required String propertyAmenities,
    required String roomFeatures,
    required String roomTypes,
    required String hotelClass,
    required String hotelStyles,
    required String language,
    required String phone,
    required String email,
    required String website,
  }) async {
    try {
      print("Creating hotel with destination ID: $destinationId");
      print("Property Amenities: $propertyAmenities");
      print("Room Features: $roomFeatures");
      print("Room Types: $roomTypes");
      print("Hotel Class: $hotelClass");
      print("Hotel Styles: $hotelStyles");
      print("Language: $language");
      print("Phone: $phone");
      print("Email: $email");
      print("Website: $website");

      final hotelUrl = Uri.parse('$baseUrl/hotel/$destinationId');
      var hotelRequest = http.MultipartRequest('POST', hotelUrl);
      hotelRequest.fields['property_amenities'] = propertyAmenities;
      hotelRequest.fields['room_features'] = roomFeatures;
      hotelRequest.fields['room_types'] = roomTypes;
      hotelRequest.fields['hotel_class'] = hotelClass;
      hotelRequest.fields['hotel_styles'] = hotelStyles;
      hotelRequest.fields['language'] = language;
      hotelRequest.fields['phone'] = phone;
      hotelRequest.fields['email'] = email;
      hotelRequest.fields['website'] = website;

      var hotelResponse = await hotelRequest.send();

      if (hotelResponse.statusCode == 200) {
        print("Hotel created successfully.");
      } else {
        final hotelResponseBody = await hotelResponse.stream.bytesToString();
        print('Error creating hotel: $hotelResponseBody');
        throw Exception('Failed to create hotel');
      }
    } catch (e) {
      print("Error creating hotel: $e");
    }
  }

  // Fetch list of cities (unchanged)
  Future<List<Map<String, dynamic>>> getCities() async {
    try {
      final cityUrl = Uri.parse('$baseUrl/city');
      final response = await http.get(
        cityUrl,
        headers: {"Content-Type": "application/json; charset=utf-8"},
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> cityList = json.decode(decodedResponse);
        return cityList.map((city) {
          return {
            'id': city['id'],
            'name': city['name'],
            'description': city['description'],
            'images': city['images']
          };
        }).toList();
      } else {
        print('Error fetching cities: ${response.body}');
        throw Exception('Failed to fetch cities');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }
}
