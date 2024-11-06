import 'package:get/get.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';

class ReviewWidgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReviewWidgetController());
  }
}
