import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/trip_controller.dart';
class TripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TripController());
  }
}
