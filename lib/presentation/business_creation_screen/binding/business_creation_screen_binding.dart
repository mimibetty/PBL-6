import 'package:get/get.dart';
import 'package:travelappflutter/presentation/business_creation_screen/controller/business_creation_screen_controller.dart';
class BusinessCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessCreationController());
  }
}
