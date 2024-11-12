import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:travelappflutter/presentation/common_views/image_picker_widget.dart';
import 'package:travelappflutter/presentation/common_views/selected_chip_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';

class ReviewFormPage extends StatefulWidget {
  final int destinationId;
  final int modeType;

  ReviewFormPage(
      {Key? key, required this.destinationId, required this.modeType})
      : super(key: key);

  @override
  _ReviewFormPageState createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _rating = 0;
  List<File> selectedImages = [];
  List<String> monthYearList = [];

  // Các biến để lưu giá trị
  String? selectedMonthYear;
  String selectedPurpose = '';
  List<String> selectedCompanions = [];
  String reviewText = '';
  String reviewTitle = '';

  late final destination = _getDestination();

  @override
  void initState() {
    super.initState();
    _generateMonthYearList();
  }

  // Hàm lấy destination dựa vào modeType
  _getDestination() {
    if (widget.modeType == 1) {
      return restaurantList.firstWhere(
        (r) => r.restaurantId == widget.destinationId,
        orElse: () => restaurantList[0],
      );
    } else if (widget.modeType == 2) {
      return mockHotels.firstWhere(
        (h) => h.hotelID == widget.destinationId,
        orElse: () => mockHotels[0],
      );
    } else {
      return danangDestinations.firstWhere(
        (d) => d.id == widget.destinationId,
        orElse: () => danangDestinations[0],
      );
    }
  }

  void _generateMonthYearList() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('MMMM/yyyy');

    for (int i = 0; i < 12; i++) {
      DateTime month = DateTime(now.year, now.month - i, 1);
      monthYearList.add(formatter.format(month));
    }
  }

  @override
  void dispose() {
    _contextController.dispose();
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Place'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tell us, how was your visit?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  Image.network(
                    destination.images != null && destination.images!.isNotEmpty
                        ? destination.images![0]
                        : 'https://example.com/default_image.jpg',
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.modeType == 1
                          ? '${destination.restaurantName}\n${destination.restaurantLocation}'
                          : widget.modeType == 2
                              ? '${destination.hotelName ?? destination.name}\n${destination.hotelLocation ?? destination.location}'
                              : '${destination.name}\n${destination.location}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('How would you rate your experience?',
                style: TextStyle(fontSize: 17)),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              hint: Text('When did you go?'),
              value: selectedMonthYear,
              items: monthYearList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMonthYear = newValue;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Who did you go with ?',
                style: TextStyle(fontSize: 17)),
            SizedBox(height: 10),
            SelectableChipWidget(
              labels: ['Business', 'Couples', 'Family', 'Friends', 'Solo'],
              onSelectionChanged: (selectedLabels) {
                setState(() {
                  selectedCompanions = selectedLabels;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              hint: Text('What were you here for?'),
              value: selectedPurpose.isNotEmpty ? selectedPurpose : null,
              items: <String>['Business', 'Leisure'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPurpose = newValue ?? '';
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contextController,
              decoration: InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              onChanged: (value) {
                reviewText = value;
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title your review',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                reviewTitle = value;
              },
            ),
            SizedBox(height: 16),
            ImagePickerWidget(
              selectedImages: selectedImages,
              onImagesPicked: (images) {
                setState(() {
                  selectedImages = images;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Create a new review instance
                    ReviewWidgetModel newReview = ReviewWidgetModel(
                      destinationId: widget.destinationId,
                      title: reviewTitle,
                      context: reviewText,
                      rating: _rating,
                      travelTime: selectedMonthYear ?? '',
                      purpose: selectedPurpose,
                      images: selectedImages
                          .map((file) => file.path)
                          .toList(), // Convert File to String
                      companions: selectedCompanions,
                      dateCreated: DateTime.now(),
                      reviewId:
                          '1', // Consider using a unique ID generator for reviewId
                      userId: '1', // Consider using the actual user's ID
                    );

                    // Get an instance of ReviewWidgetController
                    final controller = Get.find<ReviewWidgetController>();

                    // Submit the review
                    try {
                      // Safely map the List<String>? to List<File>
                      List<File> imageFiles = newReview.images
                              ?.map((imagePath) => File(imagePath))
                              .toList() ??
                          [];

                      controller.setReviewData(
                        destinationId: newReview.destinationId,
                        rating: newReview.rating,
                        context: newReview.context,
                        monthYear: newReview.travelTime,
                        purpose: newReview.purpose,
                        companions: newReview.companions,
                        text: newReview
                            .context, // Ensure this aligns with your logic
                        title: newReview.title,
                        images: imageFiles, // Pass the List<File>
                      );

                      // Provide feedback to the user
                      Get.snackbar(
                        'Success',
                        'Review submitted successfully!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } catch (e) {
                      // Handle errors
                      Get.snackbar(
                        'Error',
                        e.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kButtonColor,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.confirmation_number_outlined,
                            color: Colors.white),
                        SizedBox(width: 5),
                        Text("Create a review",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _contextController.clear();
                      _titleController.clear();
                      _rating = 0;
                      selectedMonthYear = null;
                      selectedPurpose = '';
                      selectedCompanions.clear();
                      selectedImages.clear();
                    });
                    Get.snackbar("Reset", "Fields have been reset!",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: Colors.white),
                        SizedBox(width: 5),
                        Text("Reset",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
