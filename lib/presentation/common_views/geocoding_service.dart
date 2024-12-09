import 'dart:convert';
import 'dart:async'; // Import this for TimeoutException
import 'package:http/http.dart' as http;

class GeocodingService {
  static Future<Map<String, double>?> getCoordinatesFromAddress(
      String address) async {
    String api_key = 'ArPlUISaEBAdJFTABi9dcNGcue8WQ4cOAuGcNoBE';

    final String encodedAddress = Uri.encodeComponent(address); // Mã hóa địa chỉ
    print("Encoded Address: $encodedAddress");
    final String url =
        'https://rsapi.goong.io/geocode?address=$encodedAddress&api_key=$api_key';

    try {
      // Gửi yêu cầu HTTP GET tới Goong API với thời gian chờ
      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 30)); // Giảm timeout xuống 30 giây

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        // Xử lý dữ liệu trả về từ API
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          // In dữ liệu trả về để kiểm tra
          print("Data from API: ${data['results'][0]}");

          // Kiểm tra sự tồn tại của 'geometry' và 'location'
          var geometry = data['results'][0]['geometry'];
          if (geometry != null) {
            var location = geometry['location'];
            if (location != null) {
              final lat = location['lat'];
              final lng = location['lng'];

              if (lat != null && lng != null) {
                print('Latitude: $lat, Longitude: $lng');

                // Trả về một map với lat và lng
                return {
                  'latitude': lat,
                  'longitude': lng,
                };
              } else {
                print("Latitude or Longitude is null.");
              }
            } else {
              print("Location is null.");
            }
          } else {
            print("Geometry is null.");
          }
        } else {
          print("No results found for the address");
        }
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } on http.ClientException catch (e) {
      print("Error in HTTP request: $e");
    } on TimeoutException catch (_) {
      print('Request timeout.');
    } catch (e) {
      print("Error getting coordinates: $e");
    }
    return null;
  }
}
