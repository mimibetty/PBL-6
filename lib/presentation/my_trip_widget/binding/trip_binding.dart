import 'package:get/get.dart';
import 'package:travelappflutter/presentation/my_trip_widget/controller/trip_controller.dart';
class TripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TripController());
  }
}
