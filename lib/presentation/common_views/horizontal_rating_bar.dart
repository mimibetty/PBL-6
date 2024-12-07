import 'package:flutter/material.dart';

class RatingBarWidget extends StatelessWidget {
  final int fiveStarCount; // Số lượng review cho 5 sao
  final int fourStarCount; // Số lượng review cho 4 sao
  final int threeStarCount; // Số lượng review cho 3 sao
  final int twoStarCount; // Số lượng review cho 2 sao
  final int oneStarCount; // Số lượng review cho 1 sao
  final int totalReviews; // Tổng số review

  const RatingBarWidget({
    Key? key,
    required this.fiveStarCount,
    required this.fourStarCount,
    required this.threeStarCount,
    required this.twoStarCount,
    required this.oneStarCount,
    required this.totalReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tìm số lượng đánh giá lớn nhất
    int maxReviewCount = [
      fiveStarCount,
      fourStarCount,
      threeStarCount,
      twoStarCount,
      oneStarCount,
    ].reduce((a, b) => a > b ? a : b); // Lấy số lớn nhất trong các tham số

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('5.0',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold)), // Thêm 5.0 ở đầu
            const SizedBox(width: 8),
            ...List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.blue, // Màu xanh dương cho tất cả các hình tròn
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('$totalReviews reviews',
                style: TextStyle(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 20),
        // Hiển thị thanh đánh giá cho từng mức sao
        _buildRatingBar("Excellent", 5, fiveStarCount, maxReviewCount),
        _buildRatingBar("Good", 4, fourStarCount, maxReviewCount),
        _buildRatingBar("Average", 3, threeStarCount, maxReviewCount),
        _buildRatingBar("Poor", 2, twoStarCount, maxReviewCount),
        _buildRatingBar("Terrible", 1, oneStarCount, maxReviewCount),
      ],
    );
  }

  Widget _buildRatingBar(String label, int rating, int count, int maxReviewCount) {
    // Tính tỷ lệ phần trăm của thanh sao so với sao có nhiều review nhất
    double percentage = maxReviewCount > 0 ? count / maxReviewCount : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label: "Excellent", "Good", etc.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              // Rating Bar
              Container(
                height: 8, // Chiều cao của thanh
                width: 250, // Đặt chiều rộng cố định của thanh
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Màu nền của thanh rating (màu xám)
                  borderRadius: BorderRadius.circular(5), // Góc bo tròn
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage, // Tỉ lệ rating đã tô (màu xanh dương)
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue, // Màu thanh khi có review (xanh dương)
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Số lượng review cho mỗi mức sao
          Text(
            '$count',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
