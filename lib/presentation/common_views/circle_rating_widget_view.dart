import 'package:flutter/material.dart';

class CircleRatingWidget extends StatelessWidget {
  final double rating;
  final double size; // Kích thước hình tròn

  const CircleRatingWidget({Key? key, required this.rating, this.size = 25.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++) 
          if (i <= rating.floor()) // Hình tròn đầy đủ
            Icon(
              Icons.circle,
              size: size, // Sử dụng size từ tham số
              color: const Color(0xFF13357B),
            )
          else if (i == rating.floor() + 1 && rating - rating.floor() >= 0.5) // Hình tròn nửa
            Icon(
              Icons.circle,
              size: size,
              color: const Color(0xFF13357B).withOpacity(0.5), // Nửa hình tròn
            )
          else // Hình tròn rỗng
            Icon(
              Icons.circle,
              size: size,
              color: Colors.grey,
            ),
        const SizedBox(width: 20),
        Text(
          "${rating.toString()} ★",
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }
}
