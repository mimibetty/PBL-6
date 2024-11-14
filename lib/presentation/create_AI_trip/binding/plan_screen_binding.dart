import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';
class PlanScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlanScreenController());
  }
}
