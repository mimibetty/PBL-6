import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:travelappflutter/presentation/common_views/image_picker_widget.dart';
import 'package:travelappflutter/presentation/common_views/selected_chip_widget.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';

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
  final controller = Get.find<ReviewWidgetController>();

  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  double _rating = 0;
  List<File> selectedImages = [];
  List<String> selectedCompanions = [];
  String selectedLanguage = 'English'; // Default language
  String reviewText = '';
  String reviewTitle = '';

  @override
  void dispose() {
    _contextController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Place', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tell us, how was your visit?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Image.network(
                    widget.destinationImageURL,
                    fit: BoxFit.cover,
                    height: 180, // Adjusted for better presentation
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${widget.destinationName}\n${widget.destinationAddress}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Select your language', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedLanguage,
              isExpanded: true,
              iconSize: 28,
              items: [
                'Korean', 'Japanese', 'English', 'Vietnamese', 'Thai', 'Chinese', 'French'
              ].map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue ?? 'English';
                });
              },
            ),
            SizedBox(height: 16),
            Text('Who did you go with?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
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
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    try {
                      // Call the createReview function to submit the review  
                      controller.createReview(
                        title: reviewTitle, // Pass title
                        content: reviewText, // Pass content
                        rating: _rating, // Pass rating
                        companion: selectedCompanions.join(','), // Pass companion(s)
                        language: selectedLanguage, // Pass language
                        destinationId: widget.destinationId, // Pass destination ID (converted to string)
                        userId: Get.find<AuthController>().userId.value, // Pass user ID (replace with actual user ID)
                        images: selectedImages.isNotEmpty ? selectedImages : null, // Only pass images if not empty
                      );
                      // Provide feedback to the user
                      Get.snackbar(
                        'Success',
                        'Review submitted successfully!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                      // Navigate back
                      Navigator.pop(context);
                    } catch (e) {
                      // Handle errors
                      Get.snackbar(
                        'Error',
                        e.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue.shade800,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Submit Review",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _contextController.clear();
                      _titleController.clear();
                      _rating = 0;
                      selectedCompanions.clear();
                      selectedImages.clear();
                    });
                    Get.snackbar("Reset", "Fields have been reset!",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.grey,
                        colorText: Colors.white);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Reset", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
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
