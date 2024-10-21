import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.hotelName),
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
                  // Hiển thị Age
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Age: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "${hotel.age}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                                    // Hiển thị Open Time
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Open Time: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: hotel.openTime,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Hiển thị Duration
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Duration: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                            //text: "${hotel.duration} hours",
                            text: "${hotel.duration.toString().replaceAll(".0", "")} hours",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Hiển thị Phone
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Phone: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: hotel.hotelContact,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Hiển thị Email
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Email: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: hotel.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Hiển thị Website và có thể nhấp vào
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
                  const SizedBox(height: 10),
      
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
                  const SizedBox(height: 10),

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
                  const SizedBox(height: 10),
                  
                  // Hiển thị Hotel Style
                  Text(
                    "Hotel Style",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 4,
                    children: hotel.hotelStyle
                        .map((style) => Chip(label: Text(style)))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  
                  // Hiển thị Hotel Language
                  Text(
                    "Hotel Language",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 4,
                    children: hotel.hotelLanguage
                        .map((language) => Chip(label: Text(language)))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  // Hiển thị Description
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(hotel.about),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
