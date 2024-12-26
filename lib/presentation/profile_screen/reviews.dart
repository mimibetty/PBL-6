import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày
import 'package:travelappflutter/presentation/common_views/circle_rating_widget_view.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';

class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final ReviewWidgetController reviewController = Get.put<ReviewWidgetController>(ReviewWidgetController());
  String _sortOrder = 'Newest First'; // Mặc định là "Mới nhất"

  @override
  Widget build(BuildContext context) {
    List<ReviewModel> reviews = reviewController.reviews; // Lấy danh sách review từ controller
    // Sắp xếp lại danh sách review theo lựa chọn
    if (_sortOrder == 'Newest First') {
      reviews.sort((a, b) => DateTime.parse(b.dateCreated).compareTo(DateTime.parse(a.dateCreated)));
    } else {
      reviews.sort((a, b) => DateTime.parse(a.dateCreated).compareTo(DateTime.parse(b.dateCreated)));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100], // Màu xám cho app bar
        title: const Text('Reviews'),
      ),
      backgroundColor: Colors.white, // Màu trắng cho background của toàn bộ trang
      body: SingleChildScrollView(
        // Bao quanh toàn bộ widget bằng SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Thêm Filter Section ở dưới AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort By:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _sortOrder,
                    onChanged: (String? newValue) {
                      setState(() {
                        _sortOrder = newValue!;
                      });
                    },
                    items: <String>['Newest First', 'Oldest First']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (reviews.isEmpty)
              const Center(
                child: Text(
                  'No Reviews Yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              )
            else
              // Đảm bảo danh sách review không gây overflow
              Column(
                children: reviews.map((review) {
                  DateTime date = DateTime.parse(review.dateCreated);
                  String formattedDate = DateFormat('dd MMM yyyy').format(date); // Định dạng ngày
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    color: const Color(0xFFF1F3F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFF1B1B1B),
                                    radius: 20,
                                    child: Text(
                                      review.content[0].toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    review.userName.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                    tooltip: 'Edit Review',
                                    onPressed: () {
                                      // Logic chỉnh sửa reviews
                                      print('Edit Review: ${review.id}');
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    tooltip: 'Delete Review',
                                    onPressed: () {
                                      // Logic xóa reviews
                                      print('Delete Review: ${review.id}');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          CircleRatingWidget(rating: review.rating, size: 18),
                          const SizedBox(height: 10),
                          Text(
                            '${review.dateCreated} * ${review.companion}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            review.title,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xFF1B1B1B),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            review.content,
                            style: const TextStyle(
                                fontSize: 16, color: Color(0xFF1B1B1B)),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Written $formattedDate',
                            style:
                                const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          const SizedBox(height: 5),
                          // Hiển thị danh sách ảnh
                          if (review.images.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: review.images.map((image) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    image.url,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
