import 'package:get/get.dart';

class AppController extends GetxController {
    var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Nếu bạn muốn khởi tạo với một trang cụ thể
    currentIndex.value = 0; // Ví dụ, khởi tạo với tab Home
  }
}
