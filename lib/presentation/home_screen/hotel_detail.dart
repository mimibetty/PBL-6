import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/common_views/geocoding_service.dart';
import 'package:travelappflutter/presentation/common_views/heart_icon_widget.dart';
import 'package:travelappflutter/presentation/map/map_screen.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/create_review.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/review_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;
  HotelDetailScreen({super.key,required this.hotel});


  @override
  _HotelDetailScreenState createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  final ReviewWidgetController controller = Get.put(ReviewWidgetController());
  bool isLiked = false;
  double? _latitude; // Lưu trữ vĩ độ
  double? _longitude; // Lưu trữ kinh độ


  @override
    void initState() {
      super.initState();
      controller.fetchReviewsByDestinationID(widget.hotel.destinationID);
      controller.fetchRatingDistribution(widget.hotel.destinationID);
      // Fetch coordinates for the address
      _getCoordinates(widget.hotel.hotelLocation);
    }

  void _getCoordinates(String FullAddress) async {
      var coordinates =
          await GeocodingService.getCoordinatesFromAddress(FullAddress);
      if (coordinates != null) {
        setState(() {
          _latitude = coordinates['latitude'];
          _longitude = coordinates['longitude'];
        });
        if (_latitude != null && _longitude != null) {
          print("IN ra: $_latitude,$_longitude");
        } else {
          print("Latitude hoặc Longitude chưa có giá trị.");
        }
      } else {
        print("Couldn't get coordinates.");
      }
    }
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Convert the string URL to a Uri object
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
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
          HeartIconWidget(
            isLiked: isLiked,
            onDoubleTap: () {
              setState(() {
                isLiked = !isLiked; // Thay đổi trạng thái nút tim
              });
            },
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReviewFormPage(
                      destinationId: widget.hotel.hotelID,
                      destinationName: widget.hotel.hotelName,
                      destinationAddress: widget.hotel.hotelLocation,
                      destinationImageURL: widget.hotel.images.first
                    ),
                ),
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
              items: widget.hotel.images.map((imageUrl) {
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
                    widget.hotel.hotelName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (int i = 1; i <= 5; i++)
                        Icon(
                          Icons.circle,
                          size: 25,
                          color: i <= widget.hotel.rating.floor()
                              ? Color(0xFF13357B)
                              : (i == widget.hotel.rating.floor() + 1 &&
                                      widget.hotel.rating -
                                              widget.hotel.rating.floor() >=
                                          0.5)
                                  ? Color(0xFF13357B).withOpacity(0.5)
                                  : Colors.grey,
                        ),
                      const SizedBox(width: 20),
                      Text(
                        "${widget.hotel.rating.toStringAsFixed(1)} ★",
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
                          text: widget.hotel.hotelLocation,
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
                          text: widget.hotel.priceRange,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display Open Time
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
                          text: widget.hotel.openTime,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display Duration
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
                          text: widget.hotel.duration.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display Age Requirement
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Age Requirement: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "${widget.hotel.age}+",
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
                      _launchURL(widget.hotel.website);
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
                            text: widget.hotel.website,
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
                  const SizedBox(height: 8),

                  // Hiển thị thông tin Contact
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Contact: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: widget.hotel.hotelContact,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Hiển thị số sao của Hotel
                  Row(
                    children: [
                      Text(
                        "Hotel Star: ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          widget.hotel.star,
                          (index) => Icon(
                            Icons.star,
                            color: Colors.amber[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Hiển thị Features
                  Text(
                    "Features",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 4,
                    children: widget.hotel.roomFeatures
                        .map((feature) => Chip(label: Text(feature)))
                        .toList(),
                  ),
                  const SizedBox(height: 12),

                  // Hiển thị Amenities
                  Text(
                    "Amenities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 4,
                    children: widget.hotel.propertyAmenities
                        .map((amenity) => Chip(label: Text(amenity)))
                        .toList(),
                  ),
                  const SizedBox(height: 12),

                  // Hiển thị Hotel Style
                  Text(
                    "Hotel Style",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 4,
                    children: widget.hotel.hotelStyles
                        .map((style) => Chip(label: Text(style)))
                        .toList(),
                  ),
                  const SizedBox(height: 12),

                  // Hiển thị Hotel Language
                  Text(
                    "Hotel Language",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 4,
                    children: widget.hotel.hotelLanguages
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
                  Text(widget.hotel.about),
                  const SizedBox(height: 20),
                  //Map
                   Text(
                    "Map",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20,),
                  _latitude != null && _longitude != null
                      ? Container(
                          height: 250,
                          child: MapScreen(
                            latitude: _latitude!,
                            longitude: _longitude!,
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                  // Hiển thị Reviews
                  Text(
                    "Reviews",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child:
                      // Tab Review
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ReviewWidget(destinationId: widget.hotel.destinationID ,
                                            reviews: controller.reviews, 
                                            ratingCounts: controller.ratingCounts);
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
