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

      // Ensure openTime is in HH:mm:ss format
      DateTime openTimeDateTime = DateFormat('HH:mm').parse(openTime);
      String formattedOpenTime =
          DateFormat('HH:mm:ss').format(openTimeDateTime);

      // Construct the URL with query parameters
      final Uri url =
          Uri.parse('$baseUrl/destination/').replace(queryParameters: {
        'user_id': userId.toString(),
        'name': name,
        'price_bottom': priceBottom.toString(),
        'price_top': priceTop.toString(),
        'age': age.toString(),
        'opentime': formattedOpenTime,
        'duration': duration.toString(),
        'description': description,
        'date_create': formattedDate,
        'district': district,
        'street': street,
        'ward': ward,
        'city_id': cityId.toString(),
      });

      http.Response response;

      if (images.isNotEmpty) {
        // If there are images, create a multipart request
        final request = http.MultipartRequest('POST', url);

        // Add image files
        for (File image in images) {
          request.files
              .add(await http.MultipartFile.fromPath('images', image.path));
        }

        // Send the request
        final streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        // If no images, send a regular POST request
        response = await http.post(url);
      }

      // Handle response
      if (response.statusCode == 200) {
        final destinationData = json.decode(response.body);

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
        print('Error creating destination: ${response.body}');
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
    // Create the hotel data as a JSON object
    final hotelData = {
      'destination_id': destinationId,
      'property_amenities': propertyAmenities,
      'room_features': roomFeatures,
      'room_types': roomTypes,
      'hotel_class': hotelClass,
      'hotel_styles': hotelStyles,
      'language': language,
      'phone': phone,
      'email': email,
      'website': website,
    };

    final hotelUrl = Uri.parse('$baseUrl/hotel/$destinationId');
    final headers = {
      "Content-Type": "application/json; charset=utf-8",
    };

    // Send the request with the JSON body
    final response = await http.post(
      hotelUrl,
      headers: headers,
      body: json.encode(hotelData),
    );

    // Check the response status code
    if (response.statusCode == 200) {
      print("Hotel created successfully.");
    } else {
      final responseBody = response.body;
      print('Error creating hotel: $responseBody');
      throw Exception('Failed to create hotel');
    }
  } catch (e) {
    print("Error creating hotel: $e");
  }
}

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
  // After destination and hotel creation, fetch the destination and hotel together
Future<Map<String, dynamic>?> getDestinationWithHotel(int destinationId) async {
  try {
    final destinationUrl = Uri.parse('$baseUrl/destination/$destinationId');
    final response = await http.get(destinationUrl, headers: {
      "Content-Type": "application/json; charset=utf-8",
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> destinationData = json.decode(response.body);
      
      // Ensure the destination data includes hotel information
      if (destinationData.containsKey('hotel') && destinationData['hotel'] != null) {
        print('Destination and Hotel data fetched successfully!');
        return destinationData;
      } else {
        print('Hotel data is missing for this destination');
        return null;
      }
    } else {
      print('Error fetching destination with hotel: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error fetching destination with hotel: $e');
    return null;
  }
}

}
