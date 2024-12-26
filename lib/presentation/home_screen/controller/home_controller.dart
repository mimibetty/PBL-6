import 'dart:convert';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/home_screen/models/home_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  Rx<HomeModel> homeModelObj = HomeModel().obs;
  var selectedPage = 0.obs;
  Rx<List<TravelDestination>> myDestination = Rx<List<TravelDestination>>([]);
  Rx<List<TravelDestination>> popularDestinations = Rx<List<TravelDestination>>([]); // For popular destinations
  Rx<List<TravelDestination>> recommendationDestinations = Rx<List<TravelDestination>>([]); // For recommendations

  void changePage(int index) {
    selectedPage.value = index;
  }

  @override
  void onInit() {
    super.onInit();

    // Kiểm tra nếu Get.arguments có giá trị và chứa 'selectedPage'
    var initialPage = Get.arguments != null ? Get.arguments['selectedPage'] ?? 0 : 0;
    selectedPage.value = initialPage;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Fetch popular destinations by city ID
  Future<void> getPopularDestinations(int cityID, String cityName) async {
    try {
      final url = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?city_id=$cityID';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(utf8.decode(response.bodyBytes));

        // Ánh xạ JSON thành danh sách các điểm đến
        popularDestinations.value = (decodedResponse as List).map((json) {
          return TravelDestination.fromJson({
            ...json, // Dữ liệu JSON hiện có
            'city_name': cityName, // Thêm tên thành phố
          });
        }).toList();
      } else {
        throw Exception('Failed to load popular destinations with status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      // In lỗi chi tiết với stack trace để dễ dàng debug hơn
      print("Error fetching popular destinations: $e\nStack trace: $stackTrace");
    }
  }

  /// Fetch recommendation destinations by user ID and city ID
Future<void> getRecommendationDestinations(int userID, int cityID, String cityName) async {
  try {
    // Gửi yêu cầu để lấy danh sách ID
    final url =
        'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/recommendations_bylikes/$userID?city_id=$cityID&limit=20';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      // Danh sách các ID
      final List<int> destinationIDs = List<int>.from(decodedResponse);

      // Dùng Future.wait để gửi nhiều yêu cầu HTTP song song
      final List<TravelDestination> destinations = await Future.wait(
        destinationIDs.map((id) async {
          final destinationUrl =
              'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/$id';

          final destinationResponse = await http.get(Uri.parse(destinationUrl));
          if (destinationResponse.statusCode == 200) {
            final destinationData = json.decode(utf8.decode(destinationResponse.bodyBytes));
            return TravelDestination.fromJson({
              ...destinationData, // Dữ liệu JSON hiện có
              'city_name': cityName, // Thêm tên thành phố
            });
          } else {
            throw Exception(
                'Failed to load destination with ID: $id, status code: ${destinationResponse.statusCode}');
          }
        }),
      );

      // Lưu vào mảng recommendationDestinations
      recommendationDestinations.value = destinations;
    } else {
      throw Exception('Failed to load recommendation IDs with status code: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    // In lỗi chi tiết với stack trace để dễ dàng debug hơn
    print("Error fetching recommendation destinations: $e\nStack trace: $stackTrace");
  }
}

  // Method to combine two lists of TravelDestination// Method to combine two lists of TravelDestination
  List<TravelDestination> combineDestinations(
    List<TravelDestination> list1,
    List<TravelDestination> list2,
  ) {
    // Sử dụng Set để lưu trữ các ID đã tồn tại
    final Set<int> seenIds = {};
    
    // Kết hợp hai danh sách và lọc các phần tử trùng lặp dựa trên ID
    return [...list1, ...list2].where((destination) {
      if (seenIds.contains(destination.id)) {
        return false; // Bỏ qua nếu ID đã tồn tại
      } else {
        seenIds.add(destination.id); // Thêm ID mới vào Set
        return true; // Giữ lại nếu ID chưa tồn tại
      }
    }).toList();
  }

}
