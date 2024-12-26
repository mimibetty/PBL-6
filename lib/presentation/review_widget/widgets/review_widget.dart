import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/common_views/circle_rating_widget_view.dart';
import 'package:travelappflutter/presentation/common_views/fullscrenn_image_viewer.dart';
import 'package:travelappflutter/presentation/common_views/horizontal_rating_bar.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';
// import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/update_review.dart';

class ReviewWidget extends StatelessWidget {
  final int destinationId;
  final int UserId;
  //final List<ReviewModel> reviews;
  final Map<int, int> ratingCounts;
  final ReviewWidgetController controller = Get.put(ReviewWidgetController());


  ReviewWidget({
    Key? key,
    required this.destinationId,
    required this.UserId,
    //required this.reviews,
    required this.ratingCounts,
  }) : super(key: key);


  @override

  Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Truyền các giá trị vào RatingBarWidget
        RatingBarWidget(
          rating: controller.averageRating.value,
          fiveStarCount: ratingCounts[5] ?? 0,
          fourStarCount: ratingCounts[4] ?? 0,
          threeStarCount: ratingCounts[3] ?? 0,
          twoStarCount: ratingCounts[2] ?? 0,
          oneStarCount: ratingCounts[1] ?? 0,
          totalReviews: controller.totalReviews.value,
        ),
        const SizedBox(height: 10),

        // Thanh filter và dropdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showFilterDialog(context);
                },
                child: Text('Filter'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Obx(
                () {
                   print('Dropdown selected language: ${controller.selectedLanguage.value}');
                  return DropdownButton<String>(
                    value: controller.selectedLanguage.value.isEmpty ? null : controller.selectedLanguage.value,
                    items: <String>[
                      'Korean',
                      'Japanese',
                      'English',
                      'Vietnamese',
                      'Thai',
                      'Chinese',
                      'French'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedLanguage.value = newValue;
                        print('Updated Language: ${controller.selectedLanguage.value}');
                        // Call filterReviewsByLanguage from the controller
                        controller.filterReviewsByLanguage(
                          destinationId: destinationId,
                          language: newValue,
                        );
                      }
                    },
                    hint: const Text('Select Language'),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Phần danh sách đánh giá
        Obx(() {
          if (controller.isLoading.value) {
            print("isLoading state: " + controller.isLoading.value.toString());
            // Hiển thị spinner khi đang tải dữ liệu
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.reviews.isEmpty) {
            // Hiển thị thông báo khi không có đánh giá nào
            return const Center(
              child: Text(
                'No Reviews Yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          } else {
            print("isLoading state: " + controller.isLoading.value.toString());
            // Hiển thị danh sách đánh giá
            return Column(
              children: controller.reviews.map((review) {
                DateTime date = DateTime.parse(review.dateCreated);
                String formattedDate = DateFormat('dd MMM yyyy').format(date);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  color: const Color(0xFFF1F3F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thông tin người dùng
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFF1B1B1B),
                                  radius: 20,
                                  backgroundImage: NetworkImage(review.userAvatarUrl!),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  review.userName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (UserId == review.userId) ...[
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                    tooltip: 'Edit Review',
                                    onPressed: () {
                                      // Logic chỉnh sửa reviews
                                      Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UpdateReviewFormPage(
                                          destinationId: destinationId,
                                          reviewId: review.id,
                                          destinationRating: review.rating,
                                          destinationLanguage: review.language,
                                          destinationSelectedImages: review.images,
                                          destinationCompanions: review.companion,
                                          destinationTitle: review.title,
                                          destinationContent: review.content,
                                        ),
                                      ),
                                    );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    tooltip: 'Delete Review',
                                    onPressed: () {
                                      // Hiển thị hộp thoại xác nhận
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirm Delete"),
                                            content: const Text("Are you sure you want to delete this review?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Đóng hộp thoại
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop(); // Đóng hộp thoại
                                                  // Gọi hàm deleteReview
                                                  await controller.deleteReview(review.id, destinationId);
                                                },
                                                child: const Text(
                                                  "Confirm",
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Đánh giá
                        CircleRatingWidget(rating: review.rating, size: 21),
                        const SizedBox(height: 4),
                        // Ngày và Companion
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[100], // Màu nền nhẹ
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.group,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    review.companion,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),

                        // Tiêu đề và nội dung đánh giá
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Title: ',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xFF1B1B1B),
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                review.title,
                                style: const TextStyle(
                                    fontSize: 19,
                                    color: Color(0xFF1B1B1B),
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis, // Cắt bớt nếu tiêu đề quá dài
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Content: ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF1B1B1B),
                                  fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: Text(
                                review.content,
                                style: const TextStyle(
                                    fontSize: 16, color: Color(0xFF1B1B1B)),
                                overflow: TextOverflow.ellipsis, // Cắt bớt nếu nội dung quá dài
                                maxLines: 3, // Hiển thị tối đa 3 dòng
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Danh sách ảnh
                        if (review.images.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: review.images.map((image) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullScreenImageViewer(imageUrl: image.url),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    image.url,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
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
            );
          }
        }),
      ],
    ),
  );
}

  // Hàm mở cửa sổ filter

  void _showFilterDialog(BuildContext context) {
    String? selectedRating; // Lưu rating được chọn
    String? selectedTimeOfYear; // Lưu thời gian trong năm được chọn
    String? selectedTypeOfVisit; // Lưu loại chuyến đi được chọn

    // Các lựa chọn cố định
    final List<String> ratings = ["1", "2", "3" , "4" , "5", "All"];
    final List<String> timesOfYear = ['Mar-May', 'Jun-Aug', 'Sep-Nov', 'Dec-Feb'];
    final List<String> typesOfVisit = ['Families', 'Couples', 'Friends', 'Solo','Business'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Filter Reviews',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bộ lọc Rating
                    const Text(
                      'Rating',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: ratings.map((rating) {
                        return ChoiceChip(
                          label: Text('$rating ★'),
                          selected: selectedRating == rating,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedRating = selected ? rating : null;
                            });
                          },
                          selectedColor: Colors.blue.shade100,
                          backgroundColor: Colors.grey.shade200,
                        );
                      }).toList(),
                    ),
                    const Divider(height: 20),

                    // Bộ lọc Time of the Year
                    const Text(
                      'Time of the Year',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text('Select Time'),
                      items: timesOfYear.map((time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTimeOfYear = value;
                        });
                      },
                      value: selectedTimeOfYear,
                    ),
                    const Divider(height: 20),

                    // Bộ lọc Type of Visit
                    const Text(
                      'Type of Visit',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text('Select Type'),
                      items: typesOfVisit.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTypeOfVisit = value;
                        });
                      },
                      value: selectedTypeOfVisit,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    //print("Reviews:  ${reviews.length}");
                    // Áp dụng bộ lọc
                    // Gọi applyFilter từ Controller khi bấm Apply
                    Get.find<ReviewWidgetController>().applyFilter(
                      destinationId: destinationId,
                      selectedRating: selectedRating?.toString(),
                      selectedSeason: selectedTimeOfYear,
                      selectedCompanion: selectedTypeOfVisit,
                    );
                    print("selected rating : ${selectedRating}  selectedTimeOfYear : ${selectedTimeOfYear} selectedTypeOfVisit : ${selectedTypeOfVisit}");

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}


