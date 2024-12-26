import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';

class BusinessCreationController extends GetxController {
  var selectedPage = 0.obs;
  RxList<TravelDestination> destinations = <TravelDestination>[].obs;
  RxBool isLoading = false.obs;

  final String baseUrl =
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/';

  @override
  void onInit() {
    super.onInit();

    // Lấy giá trị tab ban đầu từ arguments (nếu có)
    var initialPage = Get.arguments['selectedPage'] ?? 0;
    selectedPage.value = initialPage;

    // Gọi fetch data ngay khi khởi tạo controller
    fetchDestinations();
  }

  void changePage(int index) {
    selectedPage.value = index;
  }

  Future<void> fetchDestinations({int limit = 15, int pageSize = 10}) async {
    isLoading.value = true; // Hiển thị trạng thái loading

    try {
      final int userId = Get.find<ProfileController>().profileModelObj.value.id;
      final Uri url = Uri.parse('$baseUrl?user_id=$userId&limit=$limit&page_size=$pageSize');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        destinations.value = jsonResponse
            .map((data) => TravelDestination.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to load destinations: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false; // Ẩn trạng thái loading
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
