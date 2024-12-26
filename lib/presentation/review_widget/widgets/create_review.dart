import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:travelappflutter/presentation/common_views/image_picker_widget.dart';
import 'package:travelappflutter/presentation/common_views/selected_chip_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';

class ReviewFormPage extends StatefulWidget {
  final int destinationId;
  final String destinationName;
  final String destinationImageURL;
  final String destinationAddress;

  ReviewFormPage(
      {Key? key, required this.destinationId, required this.destinationName, required this.destinationImageURL, required this.destinationAddress})
      : super(key: key);

  @override
  _ReviewFormPageState createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  // Create a new review instance with the data
  final controller = Get.find<ReviewWidgetController>();

  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _rating = 0;
  List<File> selectedImages = [];
  //List<String> monthYearList = [];
  List<String> languageOptions = [
    'Korean',
    'Japanese',
    'English',
    'Vietnamese',
    'Thai',
    'Chinese',
    'French',
  ];
  // Các biến để lưu giá trị
  //String? selectedMonthYear;
  //String selectedPurpose = '';
  List<String> selectedCompanions = [];
   String selectedLanguage = 'English'; // Biến lưu trữ ngôn ngữ đã chọn
  String reviewText = '';
  String reviewTitle = '';


  @override
  void initState() {
    super.initState();
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
                    widget.destinationImageURL,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.destinationName}\n${widget.destinationAddress}',  // Nối tên với địa chỉ
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
            SizedBox(height: 14),
            Text('Select your language', style: TextStyle(fontSize: 17)),
            SizedBox(height: 1),
            DropdownButton<String>(
              value: selectedLanguage,
              isExpanded: true,
              items: languageOptions.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue ?? 'English'; // Cập nhật ngôn ngữ đã chọn
                });
              },
            ),

            SizedBox(height: 9),
            Text('Who did you go with ?',
                style: TextStyle(fontSize: 17)),
            SizedBox(height: 3),
            SelectableChipWidget(
              initialSelectedLabels: [],
              labels: ['Business', 'Couples', 'Family', 'Friends', 'Solo'],
              onSelectionChanged: (selectedLabels) {
                setState(() {
                  selectedCompanions = selectedLabels;
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
              action: "create",
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Submit the review
                    try {
                      // Call the createReview function to submit the review  
                        controller.createReview(
                          title: reviewTitle, // Pass title
                          content: reviewText, // Pass content
                          rating: _rating, // Pass rating
                          companion: selectedCompanions.join(','), // Pass companion(s)
                          language: selectedLanguage, // Pass language
                          destinationId: widget.destinationId, // Pass destination ID (converted to string)
                          userId: Get.find<ProfileController>().profileModelObj.value.id, // Pass user ID (replace with actual user ID)
                          images: selectedImages.isNotEmpty ? selectedImages : null, // Only pass images if not empty
                        );
                      // Provide feedback to the user
                      Get.snackbar(
                        'Success',
                        'Review submitted successfully!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      // Navigate back
                      Navigator.pop(context);
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
                      //selectedMonthYear = null;
                      //selectedPurpose = '';
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

