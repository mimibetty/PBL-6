import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StarRatingWidget extends StatelessWidget {
  final Function(double) onRatingUpdate;

  const StarRatingWidget({Key? key, required this.onRatingUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Rating:',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 10),
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Container(
            width: 20, // Điều chỉnh độ rộng của sao
            height: 20, // Điều chỉnh độ cao của sao
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF13357B), // Màu hình tròn được thay bằng mã màu 13357B
            ),
          ),
          onRatingUpdate: onRatingUpdate, // Gọi hàm callback để cập nhật giá trị
        ),
      ],
    );
  }
}
