import 'package:get/get.dart';

class PlanScreenController extends GetxController {
  var selectedPage = 0.obs;

  void changePage(int index) {
    selectedPage.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  
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
