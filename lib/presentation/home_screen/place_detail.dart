import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:travelappflutter/presentation/common_views/geocoding_service.dart';
import 'package:travelappflutter/presentation/common_views/heart_icon_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/map/map_screen.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/review_widget.dart';
import 'package:travelappflutter/routes/app_routes.dart';
import '../review_widget/models/review_widget_model.dart';
import '../review_widget/widgets/create_review.dart';

class PlaceDetailScreen extends StatefulWidget {
  final TravelDestination destination;
  const PlaceDetailScreen({super.key, required this.destination});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  @override
  double? _latitude; // Lưu trữ vĩ độ
  double? _longitude; // Lưu trữ kinh độ
  String _address = '91 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội';

  void initState() {
    super.initState();
    allReviews = mockReviews; // Khởi tạo trong initState
    _getCoordinates();
  }

  PageController pageController = PageController();
  int pageView = 0;
  List<ReviewWidgetModel> allReviews =
      mockReviews; // Sử dụng mockReviews đã tạo trước đó
  bool isLiked = false; // Trạng thái nút tim
  void _getCoordinates() async {
    if (_address.isNotEmpty) {
      var coordinates =
          await GeocodingService.getCoordinatesFromAddress(_address);

      if (coordinates != null) {
        setState(() {
          _latitude = coordinates['latitude'];
          _longitude = coordinates['longitude'];
        });
        if (_latitude != null && _longitude != null) {
          print("IN ra: Latitude = $_latitude, Longitude = $_longitude");
        } else {
          print("Latitude hoặc Longitude chưa có giá trị.");
        }
      } else {
        print("Couldn't get coordinates.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final destinationId = widget.destination.id;
    List<ReviewWidgetModel> filteredReviews = allReviews
        .where((review) => review.destinationId == widget.destination.id)
        .toList();

    for (var review in filteredReviews) {
      print(
          'ID: ${review.destinationId}, Name: ${review.context}'); // In ra ID và Name
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReviewFormPage(
                    destinationId: destinationId,
                    modeType: 3,
                  ), // Truyền destinationId vào
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
                Icons.add_comment_rounded, // Biểu tượng thêm bình luận
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 5),
                    blurRadius: 7,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() {
                          pageView = value;
                        });
                      },
                      children: List.generate(
                        widget.destination.images!.length,
                        (index) => GestureDetector(
                          onDoubleTap: () {
                            setState(() {});
                          },
                          child: Image.network(
                            widget.destination.images![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Spacer(),
                        GestureDetector(
                          child: Container(
                            height: 100,
                            width: 100,
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: widget.destination.images!.length - 1 !=
                                        pageView
                                    ? NetworkImage(
                                        widget
                                            .destination.images![pageView + 1],
                                      )
                                    : NetworkImage(
                                        widget.destination.images![0],
                                      ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    widget.destination.images!.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        if (pageController.hasClients) {
                                          pageController.animateToPage(
                                            index,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        height: 5,
                                        width: 20,
                                        margin: const EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          color: pageView == index
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.destination.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  widget.destination.address
                                                      .district,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          size: 22,
                                          color: Colors.amber[800],
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          widget.destination.rating
                                              .toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: DefaultTabController(
                length: 2, // Số lượng tab
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const TabBar(
                        labelColor: blueTextColor,
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        unselectedLabelColor: Colors.black,
                        indicatorColor: blueTextColor,
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      4.0), // Tăng chiều cao của tab Overview
                              child: Text('Overview'),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      8.0), // Chiều cao bình thường cho tab Review
                              child: Text('Review'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Tab Overview
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              // Wrap the entire column in SingleChildScrollView
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Mô tả địa điểm
                                  Text(
                                    widget.destination.description,
                                    maxLines: 3,
                                    overflow: TextOverflow
                                        .ellipsis, // Ensures text is truncated if too long
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildAboutSection(),
                                  Text(
                                    "Map",
                                    overflow: TextOverflow
                                        .ellipsis, // Ensures text is truncated if too long
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      height: 1.5,
                                      fontWeight: FontWeight
                                          .bold, // Add a valid fontWeight value
                                    ),
                                  ),

                                  SizedBox(
                                    height: 30,
                                  ),
                                  //Bản đồ
                                  _latitude != null && _longitude != null
                                      ? Container(
                                          height: 250,
                                          child: MapScreen(
                                            latitude: _latitude!,
                                            longitude: _longitude!,
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator()),
                                ],
                              ),
                            ),
                          ),

                          // Tab Review
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: SingleChildScrollView(
                              child: ReviewWidget(
                                reviews:
                                    filteredReviews, // Truyền danh sách reviews đã lọc
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    final List<String> aboutLabels = [
      "Ages :",
      "Duration :",
      "Start time :",
      "Mobile ticket :",
      "Live guide :",
    ];

    final List<String> aboutDetails = [
      "1-99, max of 12 per group",
      "9h",
      "Check availability",
      "Yes",
      "English",
    ];

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(aboutLabels.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Text(
                  aboutLabels[index], // Label
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  aboutDetails[index], // Content to be dynamically filled
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
