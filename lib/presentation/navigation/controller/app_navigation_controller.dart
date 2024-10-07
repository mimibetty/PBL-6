import 'package:get/get.dart';

class AppController extends GetxController {
  var selectedPage = 0.obs;

  void changePage(int index) {
    selectedPage.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Nếu bạn muốn khởi tạo với một trang cụ thể
    selectedPage.value = 0; // Ví dụ, khởi tạo với tab Home
  }
}
