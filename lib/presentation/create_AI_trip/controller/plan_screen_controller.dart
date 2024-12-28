import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/search_screen/models/things_to_do_model.dart';

class PlanScreenController extends GetxController {
  var cityName = ''.obs;
  var cityId = 0.obs;
  var tripLength = 1.obs; // Observable variable for trip length
  var companionOption = ''.obs; // Observable variable for companion option
  var tagsSelected = <Tag>[].obs; // Observable list for selected tags
  var selectedPage = 0.obs; // Observable variable for selected page
  var monthTime = ''.obs;

  var hotelPlanScreen = <TravelDestination>[].obs;
  var restaurantPlanScreen = <TravelDestination>[].obs;
  var thingsToDoPlanScreen = <TravelDestination>[].obs;

  var dailyGroupedDestinations = <String, List<TravelDestination>>{}.obs;

  // Cho màn hình PlanScreen
  void setSelectedCity(String name, int id) {
    cityName.value = name;
    cityId.value = id;
  }

  void setTripLength(int length) {
    tripLength.value = length;
  }

  void setCompanionOption(String option) {
    companionOption.value = option;
  }

  void addTag(Tag tag) {
    if (!tagsSelected.contains(tag)) {
      tagsSelected.add(tag);
    }
  }

  void removeTag(Tag tag) {
    tagsSelected.remove(tag);
  }

  void clearAll() {
    cityName.value = '';
    cityId.value = 0;
    tripLength.value = 1;
    companionOption.value = '';
    tagsSelected.clear();
    selectedPage.value = 0;

    hotelPlanScreen.clear();
    restaurantPlanScreen.clear();
    thingsToDoPlanScreen.clear();

    dailyGroupedDestinations.clear();
  }

  void changePage(int index) {
    selectedPage.value = index;
  }

  Future<void> fetchDestinationsByCityAndTags() async {
    final String apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/by_tags?limit=80';
    try {
      final tagIds = tagsSelected.map((tag) => tag.id).toList();
      final queryParams = {
        'city_id': cityId.value.toString(),
      };

      final url = Uri.parse(apiUrl).replace(queryParameters: queryParams);
      final urlWithTags = url.toString() + tagIds.map((id) => '&tag_ids=$id').join('');
      print("URL call destination: " + urlWithTags);
      final response = await http.get(Uri.parse(urlWithTags));

      if (response.statusCode == 200) {
        List<dynamic> apiData = json.decode(utf8.decode(response.bodyBytes)); // Sử dụng utf8.decode
        List<TravelDestination> destinations = apiData.map((data) => TravelDestination.fromJson(data)).toList();

        hotelPlanScreen.clear();
        restaurantPlanScreen.clear();
        thingsToDoPlanScreen.clear();

        for (var destination in destinations) {
          if (destination.hotelId != null) {
            hotelPlanScreen.add(destination);
          } else if (destination.restaurantId != null) {
            restaurantPlanScreen.add(destination);
          } else {
            thingsToDoPlanScreen.add(destination);
          }
        }
      } else {
        print("Failed to load destinations: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching destinations: $e");
    }
  }


  // Fetch thông tin khách sạn
  Future<void> fetchHotels(List<int> hotelIds) async {
    hotelPlanScreen.clear();
    for (var id in hotelIds) {
      final detail = await fetchDestinationDetails(id);
      if (detail != null) {
        hotelPlanScreen.add(TravelDestination.fromJson(detail));
      }
    }
  }

  // Fetch danh sách địa điểm hàng ngày
Future<void> fetchDailyDestinations(Map<String, dynamic> dailySchedule) async {
  dailyGroupedDestinations.clear();
  for (var dayKey in dailySchedule.keys) {
    List<TravelDestination> destinationsForDay = [];
    for (var id in List<int>.from(dailySchedule[dayKey])) {
      final detail = await fetchDestinationDetails(id);
      if (detail != null) {
        destinationsForDay.add(TravelDestination.fromJson(detail));
      }
    }
    dailyGroupedDestinations[dayKey] = destinationsForDay;
  }
}


  // Fetch thông tin từng điểm đến
  Future<Map<String, dynamic>?> fetchDestinationDetails(int destinationId) async {
    try {
      final response = await http.get(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/$destinationId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)); // Sử dụng utf8.decode
      } else {
        print('Failed to fetch destination: $destinationId');
        return null;
      }
    } catch (e) {
      print('Error fetching destination $destinationId: $e');
      return null;
    }
  }

  // Build trip by AI and remove the last ID from each day
  Future<Map<String, dynamic>> buildTripAI({
    required int duration,
    required List<int> hotelIds,
    required List<int> thingToDoIds,
    required List<int> restaurantIds,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/build?trip_day=$duration'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'hotel_ids': hotelIds,
          'thingtodo_ids': thingToDoIds,
          'restaurant_ids': restaurantIds,
        }),
      );

      if (response.statusCode == 200) {
        final buildData = jsonDecode(utf8.decode(response.bodyBytes)); // Use utf8.decode

        // Process daily_schedule to remove last ID of each day
        Map<String, List<int>> adjustedSchedule = {};
        (buildData['daily_schedule'] as Map<String, dynamic>).forEach((dayKey, destinations) {
          List<int> destinationIds = List<int>.from(destinations);
          if (destinationIds.length > 1) {
            adjustedSchedule[dayKey] = destinationIds.sublist(0, destinationIds.length - 1); // Remove last ID
          } else {
            adjustedSchedule[dayKey] = destinationIds; // Keep if only one ID
          }
        });

        buildData['daily_schedule'] = adjustedSchedule; // Update daily_schedule
        return {'success': true, 'data': buildData};
      } else {
        final errorMessage = utf8.decode(response.bodyBytes); // Decode error message
        return {'success': false, 'message': 'Failed to build trip by AI: $errorMessage'};
      }
    } catch (error) {
      return {'success': false, 'message': 'Error occurred while building trip', 'error': error.toString()};
    }
  }
  
  Future<Map<String, dynamic>> saveTripAI({
    required String name,
    required String monthTime,
    required int duration,
    required int userId,
    required Map<String, dynamic> buildData,
  }) async {
    try {
      // 1. Create the trip
      final tripResponse = await http.post(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'month_time': monthTime,
          'duration': duration,
          'user_id': userId,
          'isAI': true,
        }),
      );

      if (tripResponse.statusCode != 200) {
        return {'success': false, 'message': 'Failed to create trip: ${tripResponse.body}'};
      }

      final tripData = jsonDecode(utf8.decode(tripResponse.bodyBytes)); // Use utf8.decode
      final tripId = tripData['id'];

      // 2. Prepare destinations array
      final List<Map<String, dynamic>> destinations = [];
      (buildData['daily_schedule'] as Map<String, List<int>>).forEach((dayKey, destinationsList) {
        destinationsList.asMap().forEach((order, destinationId) {
          destinations.add({
            'destination_id': destinationId,
            'trip_id': tripId,
            'order': order,
            'day': int.parse(dayKey.split('_').last), // Extract day number from key
          });
        });
      });

      (buildData['hotels'] as List<dynamic>).asMap().forEach((order, hotelId) {
        destinations.add({
          'destination_id': hotelId,
          'trip_id': tripId,
          'order': order,
          'day': 0,
        });
      });

      // 3. Add destinations to the trip
      for (final destination in destinations) {
        final destinationResponse = await http.post(
          Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/add_destination'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(destination),
        );

        if (destinationResponse.statusCode != 200) {
          return {'success': false, 'message': 'Failed to add destination: ${destinationResponse.body}'};
        }
      }

      return {'success': true, 'message': 'Trip created successfully', 'data': tripId};
    } catch (error) {
      return {'success': false, 'message': 'Error occurred while saving trip', 'error': error.toString()};
    }
  }

  @override
  void onInit() {
    super.onInit();
    clearAll(); // Clear all data when the controller is initialized
  }
  
}