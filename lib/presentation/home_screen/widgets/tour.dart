import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/common_views/circle_rating_widget_view.dart';
import 'package:travelappflutter/presentation/home_screen/models/tour_model.dart';

class TourWidget extends StatelessWidget {
  final Tour tour;

  const TourWidget({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(157, 136, 226, 238), // Màu vàng cho lớp bọc bên ngoài
        borderRadius: BorderRadius.circular(20), // Bo góc cho lớp bọc
      ),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hình ảnh của tour
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                getFirstImageFromTour(tour), // Access the first image in the list
                height: 180,
                width: MediaQuery.of(context).size.width *
                    0.75, // Set a fixed width based on screen width
                fit: BoxFit.cover,
              ),
            ),

            // Phần thông tin của tour
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tour.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Giới hạn text dài
                    maxLines: 2, // Hiển thị tối đa 2 dòng
                  ),
                  const SizedBox(height: 3),
                  Text(
                    getDurationText(tour.duration),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const SizedBox(width: 1),
                      // Sử dụng CircleRatingWidget để hiển thị các hình tròn
                      CircleRatingWidget(rating: tour.rating, size: 16.0),
                      const SizedBox(width: 5),
                      
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "From \$${calculateTourBottomPrice(tour)} to \$${calculateTourTopPrice(tour)} ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "per adult (price varies by group size)",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         // Chức năng khi nhấn nút
                  //       },
                  //       child: const Text("Reserve"),
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.yellow,
                  //         foregroundColor: Colors.black,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
