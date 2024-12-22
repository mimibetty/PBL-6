import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/common_views/circle_rating_widget_view.dart';
import 'package:travelappflutter/presentation/common_views/horizontal_rating_bar.dart';
import 'package:travelappflutter/presentation/common_views/selected_chip_widget.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';

class ReviewWidget extends StatelessWidget {
  final int destinationId;
  final List<ReviewModel> reviews;
  final Map<int, int> ratingCounts;
  const ReviewWidget({Key? key, required this.destinationId, required this.reviews,required this.ratingCounts}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // Tính toán số lượng review cho từng mức rating
    // Tổng số review
    int totalReviews = reviews.length;

    return SingleChildScrollView(
      // Bao quanh toàn bộ widget bằng SingleChildScrollView
     
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Truyền các giá trị vào RatingBarWidget
          RatingBarWidget(
            rating: calculateAverageRating(reviews),
            fiveStarCount: ratingCounts[5] ?? 0,
            fourStarCount: ratingCounts[4] ?? 0,
            threeStarCount: ratingCounts[3] ?? 0,
            twoStarCount: ratingCounts[2] ?? 0,
            oneStarCount: ratingCounts[1] ?? 0,
            totalReviews: totalReviews,
          ),
          const SizedBox(height: 10),

          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Reviews',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Hàng với nút filter và dropdown ngôn ngữ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút filter
                ElevatedButton(
                  onPressed: () {
                    // Hàm mở cửa sổ filter
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

                // Dropdown chọn ngôn ngữ
                DropdownButton<String>(
                  items: <String>[
                    'Korean',
                    'Japanese',
                    'English',
                    'Vienamese',
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
                    // Hàm xử lý thay đổi ngôn ngữ
                  },
                  hint: Text('Select Language'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Popular Mentions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SelectableChipWidget(
            labels: [
              'All reviews',
              'Cable car',
              'Bana hill',
              'Our tour guide',
              'Theme park',
              'day trip ',
              'Da Nang',
            ],
            onSelectionChanged: (selectedLabels) {},
          ),

          // Nếu không có review thì hiển thị thông báo
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
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                                  review.userId.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_alt_outlined,
                                  color: Colors.blueAccent,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${review.likeCount} Likes',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CircleRatingWidget(rating: review.rating, size: 15),
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
                        if (review.images!.isNotEmpty) ...[
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
    );
  }


  // Hàm mở cửa sổ filter
  void _showFilterDialog(BuildContext context) {
    int? selectedRating; // Lưu rating được chọn
    String? selectedTimeOfYear; // Lưu thời gian trong năm được chọn
    String? selectedTypeOfVisit; // Lưu loại chuyến đi được chọn

    // Các lựa chọn cố định
    final List<int> ratings = [1, 2, 3, 4, 5];
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
                    print("Reviews:  ${reviews.length}");
                    // Áp dụng bộ lọc
                    // Gọi applyFilter từ Controller khi bấm Apply
                    Get.find<ReviewWidgetController>().applyFilter(
                      destinationId: destinationId,
                      selectedRating: selectedRating?.toInt(),
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

  double calculateAverageRating(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return 0.0; // Nếu không có đánh giá, trả về 0.0
    
    // Tính tổng điểm rating
    double totalRating = reviews.fold(0, (sum, review) => sum + review.rating);
    
    // Tính trung bình và làm tròn đến 1 chữ số sau dấu thập phân
    double averageRating = totalRating / reviews.length;
    return double.parse(averageRating.toStringAsFixed(1));
  }

}


