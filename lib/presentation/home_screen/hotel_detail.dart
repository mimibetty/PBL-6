import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/create_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';

class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;

  HotelDetailScreen({required this.hotel});

  // Hàm mở trang web
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Hàm hiển thị review của khách sạn với thiết kế tối giản và đẹp mắt hơn
  Widget HotelReview(Hotel hotel) {
    // Lọc review dựa trên hotelId
    final List<ReviewWidgetModel> reviews = mockReviews
        .where((review) => review.destinationId == hotel.hotelID)
        .toList();

    return reviews.isEmpty
        ? const Center(
            child: Text(
              'No Reviews Yet',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reviews.map((review) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên người review và ngày
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey[100],
                          child: Text(
                            review.context[0].toUpperCase(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userId,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${review.dateCreated.toLocal()}'.split(' ')[0],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Đánh giá sao
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber[600],
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Nội dung review
                    Text(
                      review.context,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    // Số lượt like
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${review.likeCount} Likes',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        IconButton(
                          icon: const Icon(Icons.thumb_up_alt_outlined,
                              color: Colors.blueGrey, size: 18),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 64,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Detail Page",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: false,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                    heightFactor: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ReviewFormPage(
                        destinationId: hotel.hotelID,
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: const Icon(
                Icons
                    .add_comment_rounded, // Thay thế biểu tượng yêu thích bằng dấu +
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Slide chuyển ảnh tự động
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true, // Tự động chuyển ảnh
                height: 250,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
              ),
              items: hotel.images.map((imageUrl) {
                return Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.hotelName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (int i = 1; i <= 5; i++)
                        Icon(
                          Icons.circle,
                          size: 25,
                          color: i <= hotel.rating.floor()
                              ? Color(0xFF13357B)
                              : (i == hotel.rating.floor() + 1 &&
                                      hotel.rating - hotel.rating.floor() >=
                                          0.5)
                                  ? Color(0xFF13357B).withOpacity(0.5)
                                  : Colors.grey,
                        ),
                      const SizedBox(width: 20),
                      Text(
                        "${hotel.rating.toString()} ★",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Hiển thị Address
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Address: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: hotel.hotelLocation,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Hiển thị Price
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Price: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "\$${hotel.price}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Hiển thị Website
                  GestureDetector(
                    onTap: () {
                      _launchURL(hotel.website);
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Website: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: hotel.website,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Hiển thị Features
                  Text(
                    "Features",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 4,
                    children: hotel.roomFeature
                        .map((feature) => Chip(label: Text(feature)))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // Hiển thị Amenities
                  Text(
                    "Amenities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 4,
                    children: hotel.propertyAmenities
                        .map((amenity) => Chip(label: Text(amenity)))
                        .toList(),
                  ),
                  const SizedBox(height: 20),

                  // Hiển thị Description
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(hotel.about),
                  const SizedBox(height: 20),

                  // Hiển thị Reviews
                  Text(
                    "Reviews",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  HotelReview(hotel), // Gọi hàm HotelReview để hiển thị review
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
