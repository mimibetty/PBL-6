import 'package:get/get.dart';
import 'package:travelappflutter/presentation/home_screen/controller/tour_controller.dart';

class TourBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TourController());
  }
}
