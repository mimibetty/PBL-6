import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/create_AI_trip/model/trip_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';

class TripController extends GetxController {
  // Observable to store trips
  var trips = <Trip>[].obs;

  // Filtered list based on filter criteria
  var filteredTrips = <Trip>[].obs;

  // Observable to store a specific trip
  var tripDetail = Rxn<Trip>();

  // Observable to indicate loading state
  var isLoading = false.obs;

  // Observable to store 3 types of TravelDestination
  var hotelList = <TravelDestination>[].obs;
  var restaurantList = <TravelDestination>[].obs;
  var thingsToDoList = <TravelDestination>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize filteredTrips with all trips
    ever(trips, (_) {
      filteredTrips.value = trips;
    });
  }

  // Method to fetch trips by user ID
  Future<void> getTripByUserId(int userId) async {
    isLoading.value = true;
    try {
      final url = Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/?user_id=$userId');

      final response = await http.get(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData =
            json.decode(utf8.decode(response.bodyBytes)); // Use utf8.decode
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

  // Method to delete a trip by its ID
  Future<void> deleteTripByID(int tripID) async {
    isLoading.value = true;
    try {
      final url = Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/$tripID');

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

 Future<Map<String, dynamic>> fetchDestinationByTripID(int tripID) async {
  isLoading.value = true;
  try {
    final tripResponse = await http.get(
      Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/$tripID'),
    );

    if (tripResponse.statusCode == 200) {
      final tripData = json.decode(utf8.decode(tripResponse.bodyBytes));
      tripDetail.value = Trip.fromJson(tripData);

      final List<TravelDestination> tempHotelList = [];
      final List<TravelDestination> tempRestaurantList = [];
      final List<TravelDestination> tempThingsToDoList = [];

      List<dynamic> tripDestinations = tripData['trip_destinations'] ?? [];
      final allDestinationIDs =
          tripDestinations.map((d) => d['destination_id']).toList();

      if (allDestinationIDs.isEmpty) {
        hotelList.clear();
        restaurantList.clear();
        thingsToDoList.clear();
        return {
          'daily_schedule': {},
          'hotels': [],
        };
      }

      // Fetch all destinations in parallel
      final destinationResponses = await Future.wait(
        allDestinationIDs.map((id) => http.get(
              Uri.parse(
                  'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/$id'),
            )),
      );

      Map<String, List<int>> dailySchedule = {};

      for (var i = 0; i < destinationResponses.length; i++) {
        final response = destinationResponses[i];
        final destinationId = allDestinationIDs[i];

        if (response.statusCode == 200) {
          final destinationData =
              json.decode(utf8.decode(response.bodyBytes));
          final destination = TravelDestination.fromJson(destinationData);

          if (destinationData['hotel_id'] != null &&
              destinationData['restaurant_id'] == null) {
            tempHotelList.add(destination);
          } else if (destinationData['restaurant_id'] != null &&
              destinationData['hotel_id'] == null) {
            tempRestaurantList.add(destination);
          } else {
            tempThingsToDoList.add(destination);
          }

          final day = tripDestinations.firstWhere(
              (d) => d['destination_id'] == destinationId)['day'];
          if (day != null) {
            final dayKey = 'day_$day';
            dailySchedule.putIfAbsent(dayKey, () => []);
            dailySchedule[dayKey]!.add(destinationId);
          }
        } else {
          print('Failed to fetch destination details for ID $destinationId');
        }
      }

      hotelList.assignAll(tempHotelList);
      restaurantList.assignAll(tempRestaurantList);
      thingsToDoList.assignAll(tempThingsToDoList);

      return {
        'daily_schedule': dailySchedule,
        'hotels': hotelList.map((hotel) => hotel.id).toList(),
      };
    } else {
      throw Exception('Failed to fetch trip: ${tripResponse.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching destinations by trip ID: $e');
  } finally {
    isLoading.value = false;
  }
}

  void filterTrips(String filter) {
    if (filter == 'All') {
      filteredTrips.value = trips;
    } else if (filter == 'With Itinerary') {
      filteredTrips.value =
          trips.where((trip) => trip.isAI == true).toList();
    } else if (filter == 'Without Itinerary') {
      filteredTrips.value =
          trips.where((trip) => trip.isAI == false).toList();
    }
    update();
  }

  void sortTrips(String sortBy) {
    if (sortBy == 'Duration') {
      filteredTrips.sort((a, b) => b.duration.compareTo(a.duration));
    } else if (sortBy == 'MonthTime') {
      const monthOrder = {
        'January': 1,
        'February': 2,
        'March': 3,
        'April': 4,
        'May': 5,
        'June': 6,
        'July': 7,
        'August': 8,
        'September': 9,
        'October': 10,
        'November': 11,
        'December': 12,
      };

      filteredTrips.sort((a, b) {
        final monthA = monthOrder[a.monthTime] ?? 0;
        final monthB = monthOrder[b.monthTime] ?? 0;
        return monthA.compareTo(monthB);
      });
    }
    update();
  }
}
