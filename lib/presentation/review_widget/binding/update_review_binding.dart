import 'package:get/get.dart';
import 'package:travelappflutter/presentation/review_widget/controller/update_review_controller.dart';

class UpdateReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateReviewController());
  }
}
