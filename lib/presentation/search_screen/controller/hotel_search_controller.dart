import 'package:get/get.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelController extends GetxController {
  RxList<Hotel> hotels = <Hotel>[].obs; // Đổi thành RxList<Hotel>
  var isLoading = false.obs; // Trạng thái tải dữ liệu

  final String api1Url = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?id=';
  final String api2Url = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/hotel/';

  Future<void> fetchHotelData(String hotelID) async {
    isLoading.value = true;

    try {
      final response1 = await http.get(Uri.parse('${api1Url}$hotelID&sort_by_reviews=true&get_rating=false'));
      final response2 = await http.get(Uri.parse('$api2Url$hotelID'));

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        // Giả định rằng api1 trả về một danh sách và chúng ta lấy phần tử đầu tiên
        List<dynamic> api1Data = json.decode(utf8.decode(response1.bodyBytes));
        if (api1Data.isNotEmpty) {
          Map<String, dynamic> hotelData = api1Data[0]; // Lấy phần tử đầu tiên
          Map<String, dynamic> api2Data = json.decode(utf8.decode(response2.bodyBytes));
          // Tạo một đối tượng Hotel mới
          Hotel newHotel = Hotel.fromApis(hotelData, api2Data);
          hotels.add(newHotel); // Thêm vào danh sách khách sạn
        } else {
          print('No data found in API 1.');
        }
      } else {
        Get.snackbar("Error", "Failed to load hotel data");
        print('Failed to load hotel data. Status code: ${response1.statusCode}, ${response2.statusCode}');
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching data: $e");
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
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
