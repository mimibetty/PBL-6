import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:travelappflutter/presentation/common_views/image_picker_widget.dart';
import 'package:travelappflutter/presentation/common_views/selected_chip_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/review_widget/controller/update_review_controller.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';

class UpdateReviewFormPage extends StatefulWidget {
  final int destinationId;
  final int reviewId;
  final double destinationRating;
  final List<ReviewImage> destinationSelectedImages;
  final String destinationLanguage;
  final String destinationCompanions;
  final String destinationTitle;
  final String destinationContent;

  UpdateReviewFormPage(
      {Key? key, required this.reviewId, required this.destinationRating, required this.destinationSelectedImages, required this.destinationLanguage, required this.destinationCompanions, required this.destinationTitle, required this.destinationContent, required this.destinationId})
      : super(key: key);

  @override
  _ReviewFormPageState createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<UpdateReviewFormPage> {
  // Create a new review instance with the data
  final controller = Get.put(UpdateReviewController());

  late TextEditingController _contextController = TextEditingController();
  late TextEditingController _titleController = TextEditingController();

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
  // Các biến để lưu giá trị đã chọn
  List<String> selectedCompanions = []; // Biến lưu Companions
  late String selectedLanguage = widget.destinationLanguage; // Biến lưu trữ ngôn ngữ đã chọn
  String reviewText = '';
  String reviewTitle = '';
  late List<ReviewImage> existingImage = widget.destinationSelectedImages;
  List<int> existingImageIdsToRemove = [];

  String destinationName = 'Default Name'; 
  String destinationAddress = 'Default Address'; 
  String destinationImageURL = 'https://experienceleaguecommunities.adobe.com/t5/image/serverpage/image-id/34749i7C7BB1DB5E28E527?v=v2'; 

  Future<void> loadDestinationInfo() async {
    // Gọi API để lấy thông tin địa điểm
    final info = await controller.fetchInfoDestination(widget.destinationId);
    setState(() {
      destinationName = info['name']!;
      destinationAddress = info['address']!;
      destinationImageURL = info['image']!;
    });
  }

  @override
  void initState() {
    super.initState();
    _contextController = TextEditingController(text: widget.destinationContent);
    _titleController = TextEditingController(text: widget.destinationTitle);
    reviewText = widget.destinationTitle;
    reviewTitle = widget.destinationContent;
    selectedCompanions = widget.destinationCompanions.split(',');
    _rating = widget.destinationRating;
    selectedLanguage = widget.destinationLanguage;
    // Gọi hàm load dữ liệu
    loadDestinationInfo();
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
            Text('Update your thoughts about your visit!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  Image.network(
                    destinationImageURL,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${destinationName}\n${destinationAddress}',  // Nối tên với địa chỉ
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
              initialRating: widget.destinationRating,
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
              initialSelectedLabels: widget.destinationCompanions.split(','),
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
            SizedBox(height: 4),
            ImagePickerWidget(
              selectedImages: selectedImages, // Ảnh mới (List<File>)
              onImagesPicked: (images) {
                setState(() {
                  selectedImages = images; // Cập nhật ảnh mới
                });
              },
              action: "update", // Chỉ định hành động
              existingImages: existingImage, // Ảnh cũ đã tải từ server (List<File>)
              onImagesRemoved: (removedIds) {
                setState(() {
                  existingImageIdsToRemove = removedIds; // Cập nhật ảnh cũ bị xóa
                  print('Removed Image IDs: $removedIds'); // In ra ID của ảnh bị xóa
                });
              },
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
                        controller.updateReview(
                          id: widget.destinationId, // Pass destination
                          reviewId: widget.reviewId, // Pass review ID       
                          title: reviewTitle, // Pass title
                          content: reviewText, // Pass content
                          rating: _rating, // Pass rating
                          companion: selectedCompanions.join(','), // Pass companion(s)
                          language: selectedLanguage, // Pass language
                          newImages: selectedImages, // Pass selected images
                          imageIdsToRemove: existingImageIdsToRemove, // Pass empty list for image IDs to remove
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
                        Text("Update review",
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

