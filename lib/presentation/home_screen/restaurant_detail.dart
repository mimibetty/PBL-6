import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/review_widget.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../review_widget/models/review_widget_model.dart';
import '../review_widget/widgets/create_review.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    allReviews = mockReviews;
  }

  PageController pageController = PageController();
  int pageView = 0;
  List<ReviewWidgetModel> allReviews = mockReviews;

  Widget _buildContactInfo(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        children: [
          TextSpan(
              text: label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold)), // In đậm label
          TextSpan(
            text: ' $value',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebsiteInfo(String url) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
          children: [
            const TextSpan(
                text: 'Website: ',
                style: TextStyle(fontWeight: FontWeight.bold)), // In đậm label
            TextSpan(
              text: url,
              style: const TextStyle(
                color: Colors.blue, // Màu khác cho đường dẫn
                decoration: TextDecoration.underline, // Gạch chân
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(String label, String location) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        children: [
          TextSpan(
              text: label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold)), // In đậm label
          TextSpan(text: ' $location'), // Thêm địa điểm
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ReviewWidgetModel> filteredReviews = allReviews
        .where(
            (review) => review.destinationId == widget.restaurant.restaurantId)
        .toList();

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
                        destinationId: widget.restaurant.restaurantId,
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
                Icons.add_comment_rounded, // Thay thế biểu tượng yêu thích bằng dấu +
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
            // Image Carousel
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
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
                        widget.restaurant.images!.length,
                        (index) => Image.network(
                          widget.restaurant.images![index],
                          fit: BoxFit.cover,
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
                                image: widget.restaurant.images!.length - 1 !=
                                        pageView
                                    ? NetworkImage(
                                        widget.restaurant.images![pageView + 1],
                                      )
                                    : NetworkImage(
                                        widget.restaurant.images![0],
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
                                    widget.restaurant.images!.length,
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
                                      // Sử dụng Expanded để cho phép phần location chiếm không gian
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.restaurant.restaurantName,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start, // Đặt biểu tượng ở đầu
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                // Sử dụng Expanded để location có thể xuống dòng
                                                child: Text(
                                                  widget.restaurant
                                                      .restaurantLocation,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines:
                                                      4, // Giới hạn số dòng
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              color: Colors.amber[800],
                                              size: 25,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              widget.restaurant.rating
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '(${widget.restaurant.review} reviews)',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    )
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
                length: 3, // Số lượng tab (Overview, Review, Contact)
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
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: blueTextColor,
                        tabs: [
                          Tab(child: Text('Overview')),
                          Tab(child: Text('Review')),
                          Tab(child: Text('Contact')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Overview Tab
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              // Thêm SingleChildScrollView
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.restaurant.about,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildContactInfo("Price Range :",
                                      widget.restaurant.priceRange),
                                  const SizedBox(height: 10),
                                  _buildContactInfo("Cuisines :",
                                      widget.restaurant.cuisines.join(', ')),
                                  const SizedBox(height: 10),
                                  _buildContactInfo("Feature :",
                                      widget.restaurant.feature.join(', ')),
                                  const SizedBox(height: 10),
                                  _buildContactInfo("Meal :",
                                      widget.restaurant.cuisines.join(', ')),
                                  const SizedBox(height: 10),
                                  _buildContactInfo(
                                      "Open Time :", widget.restaurant.time),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),

                          // Review Tab
                          ReviewWidget(reviews: filteredReviews),
                          // Contact Tab
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildContactInfo('Contact Number:',
                                      widget.restaurant.contactNumber),
                                  const SizedBox(height: 10),
                                  _buildWebsiteInfo(widget.restaurant.website),
                                  const SizedBox(height: 10),
                                  _buildLocationInfo('Location:',
                                      widget.restaurant.restaurantLocation),
                                ],
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
}
