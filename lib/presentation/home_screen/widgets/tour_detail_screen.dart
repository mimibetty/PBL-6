import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/models/tour_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/tour_overview_screen.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/create_review.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/other_info_widget.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/review_widget.dart';
import 'package:travelappflutter/routes/app_routes.dart';

class TourDetailScreen extends StatefulWidget {
  final Tour tour;
  const TourDetailScreen({super.key, required this.tour});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
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
    final destinationId = widget.tour.id;
    List<ReviewWidgetModel> filteredReviews = allReviews
        .where((review) => review.destinationId == widget.tour.id)
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
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReviewFormPage(
                    destinationId: destinationId,
                    modeType: 4,
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
                        widget.tour.images!.length,
                        (index) => Image.network(
                          widget.tour.images![index],
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
                                image: widget.tour.images.length - 1 != pageView
                                    ? NetworkImage(
                                        widget.tour.images[pageView + 1],
                                      )
                                    : NetworkImage(
                                        widget.tour.images[0],
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
                                    widget.tour.images!.length,
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
                                            widget.tour.name,
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
                                                  widget.tour.location,
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
                                          widget.tour.rating.toString(),
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
                length: 3, // Số lượng tab
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                'Overview',
                                style: const TextStyle(
                                    fontSize: 12.0), // Giảm kích thước chữ
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                'Other info',
                                style: const TextStyle(
                                    fontSize: 12.0), // Giảm kích thước chữ
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Review',
                                style: const TextStyle(
                                    fontSize: 12.0), // Giảm kích thước chữ
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Hiển thị mô tả tour
                                  Text(
                                    widget.tour.about,
                                    maxLines: 3,
                                    overflow: TextOverflow
                                        .ellipsis, // Cắt văn bản nếu vượt quá 3 dòng
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),

                                  // TourOverviewWidget hiển thị chi tiết tour
                                  TourOverviewWidget(),
                                ],
                              ),
                            ),
                          ),
                          //truyen interface của tour vào
                          TourOptionsScreen(),
                          ReviewWidget(
                            reviews: filteredReviews,
                          ),
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
    );
  }
}
