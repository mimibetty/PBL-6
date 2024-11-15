import '../controller/things_to_do_controller.dart';
import 'package:get/get.dart';

class ThingsToDoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ThingsToDoController());
  }
}
