import 'package:get/get.dart';

class BusinessCreationController extends GetxController {
  //<HomeModel> businessCreationModelObj = BusinessCreationModel().obs;
  var selectedPage = 0.obs;

  void changePage(int index) {
    selectedPage.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Lấy giá trị tab ban đầu từ arguments (nếu có)
    var initialPage = Get.arguments['selectedPage'] ?? 0;
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
}
