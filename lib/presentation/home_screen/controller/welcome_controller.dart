import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/home_screen/models/cities_model.dart';

class WelcomeController extends GetxController {
  Rx<List<CityModel>> myCities = Rx<List<CityModel>>([]);

  Future<void> fetchCities() async {
    try {
      final response = await http.get(Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/city/'));

      if (response.statusCode == 200) {
        // Decode the response with UTF-8 handling
        final decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        myCities.value = (decodedResponse as List)
            .map((json) => CityModel.fromJson(json))
            .toList();
        
        // Log cities information for verification
        myCities.value.forEach((city) {
          city.images.forEach((image) {
          });
        });
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      print('Error: $e');
      // Handle network or JSON errors
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
