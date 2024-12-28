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
        final buildData = jsonDecode(utf8.decode(response.bodyBytes));
        buildData['daily_schedule'] = _removeLastDestination(buildData['daily_schedule']);
        return {'success': true, 'data': buildData};
      } else {
        return {'success': false, 'message': _decodeError(response)};
      }
    } catch (error) {
      return _handleException(error);
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
      final jsonPayload = {
        "trip_name": name,
        "month_time": monthTime,
        "user_id": userId,
        "isAI": true,
        "trip_day": duration,
        "list_day": buildData['daily_schedule'],
        "list_hotel": List<int>.from(buildData['hotels']),
      };

      final response = await http.post(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/create-complete-trip'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonPayload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return {'success': true, 'data': responseData};
      } else {
        return {'success': false, 'message': _decodeError(response)};
      }
    } catch (error) {
      return _handleException(error);
    }
  }

  Future<Map<String, dynamic>> buildTripNoAI({
    required String name,
    required int userId,
    required Map<String, dynamic> buildData,
  }) async {
    try {
      final tripResponse = await http.post(
        Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'month_time': monthTime.value,
          'duration': tripLength.value,
          'user_id': userId,
          'isAI': false,
        }),
      );

      if (tripResponse.statusCode != 200) {
        return {'success': false, 'message': _decodeError(tripResponse)};
      }

      final tripData = jsonDecode(utf8.decode(tripResponse.bodyBytes));
      final int tripID = tripData['id'];
      final List<int> allDestinations = [
        ...List<int>.from(buildData['hotels']),
        ...List<int>.from(buildData['restaurants']),
        ...List<int>.from(buildData['things_to_do']),
      ];

      for (final destinationID in allDestinations) {
        final destinationResponse = await http.post(
          Uri.parse('https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/trip/add_destination'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'destination_id': destinationID,
            'trip_id': tripID,
            'order': 0,
            'day': 0,
          }),
        );

        if (destinationResponse.statusCode != 200) {
          return {
            'success': false,
            'message': 'Failed to add destination ID $destinationID: ${_decodeError(destinationResponse)}',
          };
        }
      }

      return {'success': true, 'message': 'Trip saved successfully!', 'trip_id': tripID};
    } catch (error) {
      return _handleException(error);
    }
  }

  // Helper to remove last destinations from daily_schedule
  Map<String, List<int>> _removeLastDestination(Map<String, dynamic> dailySchedule) {
    return dailySchedule.map((key, destinations) {
      final List<int> destinationIds = List<int>.from(destinations);
      return MapEntry(key, destinationIds.length > 1 ? destinationIds.sublist(0, destinationIds.length - 1) : destinationIds);
    });
  }

  // Helper to decode error
  String _decodeError(http.Response response) {
    return utf8.decode(response.bodyBytes);
  }

  // Helper to handle exceptions
  Map<String, dynamic> _handleException(dynamic error) {
    return {'success': false, 'message': 'An error occurred', 'error': error.toString()};
  }

  @override
  void onInit() {
    super.onInit();
    clearAll(); // Clear all data when the controller is initialized
  }
}