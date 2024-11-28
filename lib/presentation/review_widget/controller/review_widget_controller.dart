import 'dart:io';
import 'package:get/get.dart';

class ReviewWidgetController extends GetxController {
  var destinationId = 0.obs;
  var modeType = 0.obs; // 0 for normal, 1 for special, etc. (consider using an enum)
  var rating = 0.0.obs;
  var selectedMonthYear = ''.obs;
  var selectedPurpose = ''.obs;
  var selectedCompanions = <String>[].obs;
  var reviewText = ''.obs;
  var reviewTitle = ''.obs;
  var selectedImages = <File>[].obs;

  void setReviewData({
    required int destinationId,
    // required int type,
    required double rating,
    required String context,
    required String purpose,
    required List<String> companions,
    required String text,
    required String title,
    required List<File> images,                     
  }) {
    if (rating < 0 || rating > 5) {
      throw ArgumentError("Rating must be between 0 and 5.");
    }

    this.destinationId.value = destinationId;
    // modeType.value = type;
    this.rating.value = rating;
    // selectedMonthYear.value = monthYear;
    selectedPurpose.value = purpose;
    selectedCompanions.assignAll(companions);
    reviewText.value = text;
    reviewTitle.value = title;
    selectedImages.assignAll(images);
  }

  /// Resets all review data to initial state.
  void resetData() {
    rating.value = 0.0;
    selectedMonthYear.value = '';
    selectedPurpose.value = '';
    selectedCompanions.clear();
    reviewText.value = '';
    reviewTitle.value = '';
    selectedImages.clear();
  }

  // Getter methods for encapsulation
  int get getDestinationId => destinationId.value;
  int get getModeType => modeType.value;
  double get getRating => rating.value;
  String get getSelectedMonthYear => selectedMonthYear.value;
  String get getSelectedPurpose => selectedPurpose.value;
  List<String> get getSelectedCompanions => selectedCompanions.toList();
  String get getReviewText => reviewText.value;
  String get getReviewTitle => reviewTitle.value;
  List<File> get getSelectedImages => selectedImages.toList();
}
