import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày
import 'package:travelappflutter/presentation/common_views/circle_rating_widget_view.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';

class ReviewWidget extends StatelessWidget {
  final List<ReviewModel> reviews;
  const ReviewWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reviews.isEmpty
        ? const Center(
            child: Text(
              'No Reviews Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              String formattedDate = DateFormat('dd MMM yyyy')
                  .format(DateTime.parse(review.dateCreated)); // Định dạng ngày
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Sử dụng spaceBetween để phân bố không gian
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
                            // Đưa phần Likes vào một Row riêng bên phải
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
                      //Hiển thị travelTime và whoGoWith ở dòng tiếp theo
                      // Text(
                      //   '${review.travelTime} * ${review.companions}',
                      //   style: const TextStyle(
                      //     fontSize: 15,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      const SizedBox(height: 5),
                      Text(
                        review.title,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF1B1B1B),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        review.content,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),

                      const SizedBox(height: 5),
                      Text(
                        'Written $formattedDate',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      // Thêm phần thích (Likes) dưới đây nếu cần
                    ],
                  ),
                ),
              );
            },
          );
  }
}
