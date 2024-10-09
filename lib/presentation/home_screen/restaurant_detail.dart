import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/review_widget.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';
import 'package:travelappflutter/routes/app_routes.dart';
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
    allReviews = mockReviews; // Khởi tạo trong initState
  }

  PageController pageController = PageController();
  int pageView = 0;
  List<ReviewWidgetModel> allReviews =
      mockReviews; // Sử dụng mockReviews đã tạo trước đó

  @override
  Widget build(BuildContext context) {
    List<ReviewWidgetModel> filteredReviews = allReviews
        .where(
            (review) => review.destinationId == widget.restaurant.restaurantId)
        .toList();

    print("Filtered Reviews:");
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
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black12,
              ),
            ),
            child: const Icon(
              Icons.favorite_border_sharp,
              size: 30,
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
              height: MediaQuery.of(context).size.height * 0.5,
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
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              widget.restaurant.about,
                              maxLines: 3,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                          ReviewWidget(
                            reviews:
                                filteredReviews, // Pass the filtered reviews list
                          ), // Chỉ có 2 widget con, do đó loại bỏ Center
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 110,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Price",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                // Get.toNamed(AppRoutes.createReviewScreen, arguments: {
                //   'destinationId': widget
                //       .destination.id, // Truyền id của destination nếu cần
                // });
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
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kButtonColor),
                child: const Row(
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Create a review",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
