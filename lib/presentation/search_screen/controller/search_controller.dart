import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/home_screen/home_screen.dart';
import 'package:travelappflutter/presentation/home_screen/hotel_detail.dart';
import 'dart:convert';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';
import 'package:travelappflutter/presentation/home_screen/restaurant_detail.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';

class SearchDestinationController extends GetxController {
  final String apiUrl =
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?limit=10&page_size=10';

  RxList<TravelDestination> destinations = <TravelDestination>[].obs;
  RxList<TravelDestination> spotlightDestinations = <TravelDestination>[].obs;
  RxList<TravelDestination> moreExploreDestinations = <TravelDestination>[].obs;
  RxList<TravelDestination> searchRecommendations = <TravelDestination>[].obs;
  RxList<dynamic> searchResults = <dynamic>[].obs;
  Timer? _debounce;
  RxString errorMessage = ''.obs;

  RxBool isLoading = false.obs;

  /// Fetch tất cả các địa điểm từ API
  Future<void> fetchAllDestinations() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> apiData = json.decode(utf8.decode(response.bodyBytes));
        destinations.value = apiData.map((data) => TravelDestination.fromJson(data)).toList();

        // Gọi các hàm liên quan
        getDestinationSpotlightAll();
        getMoreExploreAll();
        getSearchRecommendation(Get.find<AuthController>().userId.value); // Sử dụng id từ ProfileController
      } else {
        print('Failed to fetch destinations: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching destinations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Lấy 5 địa điểm đầu tiên cho Spotlight
  void getDestinationSpotlightAll() {
    spotlightDestinations.value = destinations.take(5).toList();
  }

  /// Lấy 5 địa điểm tiếp theo cho More Explore
  void getMoreExploreAll() {
    moreExploreDestinations.value = destinations.skip(5).take(5).toList();
  }

  /// Hàm để lấy gợi ý tìm kiếm từ id
  Future<void> getSearchRecommendation(int id) async {
    try {
      final Uri recommendationUrl = Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/recommendationsIDS_bylikes/$id?limit=7');
      final recommendationResponse = await http.get(recommendationUrl);

      if (recommendationResponse.statusCode == 200) {
        List<dynamic> recommendations = json.decode(utf8.decode(recommendationResponse.bodyBytes));

        // Gọi API chi tiết song song để tối ưu hiệu năng
        final List<Future<TravelDestination>> futures = recommendations.map((recommendation) async {
          final int destinationId = recommendation;

          // Gọi API lấy thông tin chi tiết của từng destination theo ID
          final Uri detailUrl = Uri.parse(
              'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/$destinationId');
          final detailResponse = await http.get(detailUrl);

          if (detailResponse.statusCode == 200) {
            final Map<String, dynamic> detailData = json.decode(utf8.decode(detailResponse.bodyBytes));
            return TravelDestination.fromJson(detailData);
          } else {
            print('Failed to fetch details for destination ID: $destinationId');
            throw Exception('Failed to fetch details');
          }
        }).toList();

        // Đợi tất cả API hoàn thành
        searchRecommendations.value = await Future.wait(futures);
      } else {
        print('Failed to fetch recommendations: ${recommendationResponse.statusCode}');
      }
    } catch (e) {
      print('Error in getSearchRecommendation: $e');
    }
  }

  /// Gọi API tìm kiếm dựa trên từ khóa
  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) return; // Không thực hiện nếu không có từ khóa
    isLoading.value = true;
    errorMessage.value = '';


    try {
      final Uri searchUrl = Uri.parse(
          'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/dashboard/search?text=$query');
      final searchResponse = await http.get(searchUrl);

      if (searchResponse.statusCode == 200) {
        final data = json.decode(utf8.decode(searchResponse.bodyBytes));
        searchResults.value = [
          ...data['cities'].map((city) => {...city, 'type': 'city'}).toList(),
          ...data['destinations']
              .map((destination) => {...destination, 'type': 'destination'}).toList(),
        ];
      } else {
         errorMessage.value = "Error: ${searchResponse.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// Gọi hàm này mỗi khi người dùng nhập liệu
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchSearchResults(query);
    });
  }

Future<void> handleResultClick(dynamic item, BuildContext context) async {
  if (item['type'] == 'city') {
    // Nếu là City
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          cityID: item['id'],
          cityName: item['name'],
          tag: null,
          show: true,
        ),
      ),
    );
  } else if (item['type'] == 'destination') {
    // Nếu là Destination
    final Uri detailUrl = Uri.parse(
        'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/${item['id']}');
    final detailResponse = await http.get(detailUrl);

    if (detailResponse.statusCode == 200) {
      final detailData = json.decode(utf8.decode(detailResponse.bodyBytes));

      if (detailData['hotel_id'] != null) {
        // Gọi API cho hotel nếu có hotel_id
        final Uri hotelUrl = Uri.parse(
            'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/hotel/${detailData['hotel_id']}');
        final hotelResponse = await http.get(hotelUrl);

        if (hotelResponse.statusCode == 200) {
          final hotel = Hotel.fromApi(json.decode(utf8.decode(hotelResponse.bodyBytes)));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HotelDetailScreen(hotel: hotel),
            ),
          );
        } else {
          print("Failed to fetch hotel details: ${hotelResponse.statusCode}");
        }
      } else if (detailData['restaurant_id'] != null) {
        // Gọi API cho restaurant nếu có restaurant_id
        final Uri restaurantUrl = Uri.parse(
            'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/restaurant/${detailData['restaurant_id']}');
        final restaurantResponse = await http.get(restaurantUrl);

        if (restaurantResponse.statusCode == 200) {
          final restaurant = Restaurant.fromApi(json.decode(utf8.decode(restaurantResponse.bodyBytes)));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
            ),
          );
        } else {
          print("Failed to fetch restaurant details: ${restaurantResponse.statusCode}");
        }
      } else {
        // Nếu không có cả hotel_id và restaurant_id
        final destination = TravelDestination.fromJson(detailData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(destination: destination),
          ),
        );
      }
    } else {
      print("Failed to fetch destination details: ${detailResponse.statusCode}");
    }
  }
}



  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
}

  @override
  void onInit() {
    super.onInit();
    fetchAllDestinations(); // Gọi API khi khởi tạo controller
  }
}

