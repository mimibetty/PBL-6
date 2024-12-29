import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/create_AI_trip/model/city_data.dart';
import 'package:travelappflutter/presentation/create_AI_trip/model/trip_model.dart';

class TripController extends GetxController {
  // Observable to store trips
  var trips = <Trip>[].obs;

  // Observable to store a specific trip
  var tripDetail = Rxn<Trip>();

  // Observable to indicate loading state
  var isLoading = false.obs;

  // Method to fetch trips by user ID
// Method to fetch trips by user ID
Future<void> getTripByUserId(int userId) async {
  isLoading.value = true;
  try {
    final url = Uri.parse(
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/?user_id=$userId',
    );

    final response = await http.get(
      url,
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes)); // Use utf8.decode

      // Parse JSON into Trip objects
      trips.value = jsonData.map((trip) => Trip.fromJson(trip)).toList();
    } else {
      Get.snackbar(
        'Error',
        'Failed to fetch trips: ${response.statusCode}',
      );
    }
  } catch (e) {
    print('Error fetching trips: $e');
    Get.snackbar('Error', 'Something went wrong: $e');
  } finally {
    isLoading.value = false;
  }
}

  // // Method to fetch city_id by destination ID
  // Future<int?> _getCityIdByDestinationId(int destinationId) async {
  //   try {
  //     final url = Uri.parse(
  //       'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/$destinationId',
  //     );

  //     final response = await http.get(
  //       url,
  //       headers: {'accept': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       final destinationData = json.decode(utf8.decode(response.bodyBytes)); // Use utf8.decode
  //       return destinationData['address']['city_id'];
  //     } else {
  //       print('Failed to fetch destination details: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching destination details: $e');
  //   }
  //   return null; // Return null in case of failure
  // }

  // Method to delete a trip by its ID
  Future<void> deleteTripByID(int tripID) async {
    isLoading.value = true;
    try {
      final url = Uri.parse(
        'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/$tripID',
      );

      final response = await http.delete(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final result = int.parse(response.body);
        if (result == 1) {
          trips.removeWhere((trip) => trip.id == tripID);
          Get.snackbar('Success', 'Trip deleted successfully');
        } else {
          Get.snackbar('Error', 'Trip not found or deletion failed');
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete trip: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error deleting trip: $e');
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}