import 'dart:convert';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';
import 'package:travelappflutter/presentation/home_screen/models/home_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  Rx<HomeModel> homeModelObj = HomeModel().obs;
  var selectedPage = 0.obs;
  var role = ''.obs; // Observable to store user role
  Rx<List<TravelDestination>> myDestination = Rx<List<TravelDestination>>([]);

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

  // Tạo hàm theo tag (4 topic)

  ///
Future<void> getDestinationByCityID(int cityID, String cityName) async {
  try {
    final url = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?city_id=$cityID&sort_by_reviews=true&get_rating=true';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(utf8.decode(response.bodyBytes));

      // Ánh xạ JSON thành danh sách các điểm đến
      myDestination.value = (decodedResponse as List).map((json) {
        return TravelDestination.fromJson({
          ...json, // Dữ liệu JSON hiện có
          'city_name': cityName, // Thêm tên thành phố
        });
      }).toList();

      // In thông tin chi tiết của các điểm đến
      print('Danh sách điểm đến:');
      myDestination.value.forEach((destination) {
        print('Tên điểm đến: ${destination.name}');
        print('Tên thành phố: ${destination.address}');
        print('Địa chỉ: ${destination.address.district} - ${destination.address.street}');
        print('Giá cả: ${destination.priceBottom} - ${destination.priceTop}');
        print('Số lượng đánh giá: ${destination.numOfReviews}');
        print('Đánh giá: ${destination.rating}');
        print('Ảnh : ${destination.images}');
        print('-------------------------');
      });
    } else {
      throw Exception('Failed to load destinations with status code: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    // In lỗi chi tiết với stack trace để dễ dàng debug hơn
    print("Error fetching destinations: $e\nStack trace: $stackTrace");
  }
}

}
