import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';

class ReviewWidget extends StatelessWidget {
  final List<ReviewWidgetModel> reviews;

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
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                color: const Color(0xFFF1F3F5), // Màu nền của card
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1B1B1B), // Màu nền avatar
                    child: Text(
                      review.context[0].toUpperCase(), // Lấy chữ cái đầu tiên của context làm avatar
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  title: Text(
                    review.context,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF1B1B1B)), // Màu chữ
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber[700],
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            review.rating.toString(),
                            style: const TextStyle(fontSize: 14, color: Color(0xFF1B1B1B)), // Màu chữ
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${review.dateCreated.toLocal()}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${review.likeCount} Likes',
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
