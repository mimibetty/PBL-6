import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelappflutter/presentation/common_views/image_picker_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';
import 'package:travelappflutter/routes/app_routes.dart';

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
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double _rating = 0;
  List<File> selectedImages = []; // Danh sách hình ảnh đã chọn

  late final destination = _getDestination();

  // Hàm lấy destination dựa vào modeType
  _getDestination() {
    if (widget.modeType == 1) {
      return restaurantList.firstWhere(
        (r) => r.restaurantId == widget.destinationId,
        orElse: () =>
            restaurantList[0], // Default to the first restaurant if not found
      );
    } else if (widget.modeType == 2) {
      return mockHotels.firstWhere(
        (h) => h.hotelID == widget.destinationId,
        orElse: () => mockHotels[0], // Default to the first hotel if not found
      );
    } else {
      return myDestination.firstWhere(
        (d) => d.id == widget.destinationId,
        orElse: () =>
            myDestination[0], // Default to the first destination if not found
      );
    }
  }

  void initState() {
    super.initState();
    // In ra destinationId khi khởi tạo
    print("Destination ID nè 1: ${widget.destinationId}");
  }

  @override
  void dispose() {
    _contextController.dispose();
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
            Text(
              'Tell us, how was your visit?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Hiển thị destinationId

            SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  Image.network(
                    destination.images != null && destination.images!.isNotEmpty
                        ? destination.images![0]
                        : 'https://example.com/default_image.jpg', // Fallback image
                    fit: BoxFit.cover,
                  ),
                  if (widget.modeType == 1)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${destination.restaurantName}\n${destination.restaurantLocation}',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (widget.modeType == 2)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${destination.hotelName}\n${destination.hotelLocation}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Text(
              'How would you rate your experience?',
              style: TextStyle(fontSize: 18),
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 16),
            // DropdownButton<String>(
            //   hint: Text('When did you go?'),
            //   items: <String>['January', 'February', 'March','April']
            //       .map((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (_) {},
            // ),
            SizedBox(height: 16),
            Text('Who did you go with?'),
            Wrap(
              spacing: 8.0,
              children: ['Business', 'Couples', 'Family', 'Friends', 'Solo']
                  .map((label) => ChoiceChip(
                        label: Text(label),
                        selected: false,
                        onSelected: (bool selected) {},
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              hint: Text('What were you here for?'),
              items: <String>['Business', 'Leisure'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              controller: _contextController,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Title your review',
                border: OutlineInputBorder(),
              ),
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
              mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các nút
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    // Hiển thị thông báo thành công
                    Get.snackbar(
                      "Success", // Tiêu đề thông báo
                      "Review submitted successfully!", // Nội dung thông báo
                      snackPosition: SnackPosition.BOTTOM, // Vị trí thông báo
                      duration:
                          Duration(seconds: 2), // Thời gian hiển thị thông báo
                      backgroundColor: Colors.green, // Màu nền của thông báo
                      colorText: Colors.white, // Màu chữ
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10, // Kích thước chiều dọc
                      horizontal: 15, // Kích thước chiều ngang
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kButtonColor,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Create a review",
                          style: TextStyle(
                            fontSize: 14, // Kích thước chữ
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10), // Khoảng cách giữa hai nút
                TextButton(
                  onPressed: () {
                    // Hành động cho nút reset
                    // Ví dụ: xóa thông tin đã nhập hoặc làm mới các trường
                    Get.snackbar(
                      "Reset", // Tiêu đề thông báo
                      "Fields have been reset!", // Nội dung thông báo
                      snackPosition: SnackPosition.BOTTOM, // Vị trí thông báo
                      duration:
                          Duration(seconds: 2), // Thời gian hiển thị thông báo
                      backgroundColor: Colors.red, // Màu nền của thông báo
                      colorText: Colors.white, // Màu chữ
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10, // Kích thước chiều dọc
                      horizontal: 15, // Kích thước chiều ngang
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red, // Màu nền cho nút reset
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh, // Biểu tượng cho nút reset
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Reset",
                          style: TextStyle(
                            fontSize: 14, // Kích thước chữ
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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
