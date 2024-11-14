  import '../controller/restaurant_search_controller.dart';
  import 'package:get/get.dart';

  class RestaurantBinding extends Bindings {
    @override
    void dependencies() {
      Get.lazyPut(() => RestaurantController());
    }
  }
