import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/common_views/fullscrenn_image_viewer.dart';
import 'package:travelappflutter/presentation/common_views/geocoding_service.dart';
import 'package:travelappflutter/presentation/common_views/heart_icon_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/map/map_screen.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';
import 'package:travelappflutter/presentation/review_widget/controller/review_widget_controller.dart';
import 'package:travelappflutter/presentation/review_widget/widgets/review_widget.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../review_widget/widgets/create_review.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final ReviewWidgetController controller = Get.put(ReviewWidgetController());
  double? _latitude; // Lưu trữ vĩ độ
  double? _longitude; // Lưu trữ kinh độ

  @override
  void initState() {
    super.initState();
    controller.typeOfReview = "destination";
    controller.fetchReviews(id: widget.restaurant.destinationID);
    controller.fetchRatingDistribution(id: widget.restaurant.destinationID);
    _getCoordinates(widget.restaurant.restaurantLocation);
  }

  bool isLiked = false;
  PageController pageController = PageController();
  int pageView = 0;

  void _getCoordinates(String FullAddress) async {
    var coordinates =
        await GeocodingService.getCoordinatesFromAddress(FullAddress);

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
        final Uri uri =
            Uri.parse(url); // Convert the string URL to a Uri object
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
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
          "Detail Restaurant",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          HeartIconWidget(
            userId: Get.find<AuthController>().userId.value, // Add the userId argument
            destinationId: widget
                .restaurant.restaurantID, // Add the destinationId argument
            isLiked: isLiked, // Truyền trạng thái isLiked vào
            //size: 18,
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReviewFormPage(
                    destinationId: widget.restaurant.restaurantID,
                    destinationName: widget.restaurant.restaurantName,
                    destinationAddress: widget.restaurant.restaurantLocation,
                    destinationImageURL: widget.restaurant.images.first,
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
            // Image Carousel
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
                        widget.restaurant.images.length,
                        (index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageViewer(
                                  imageUrl: widget.restaurant.images[index],
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            widget.restaurant.images[index],
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
                                image: widget.restaurant.images.length - 1 !=
                                        pageView
                                    ? NetworkImage(
                                        widget.restaurant.images[pageView + 1],
                                      )
                                    : NetworkImage(
                                        widget.restaurant.images[0],
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
                                    widget.restaurant.images.length,
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
                                            widget.restaurant.restaurantName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: Text(
                                                  widget.restaurant
                                                      .restaurantLocation,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Rating and review count column on the right side
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
                                                  .toStringAsFixed(1)
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
                                      widget.restaurant.meal.join(', ')),
                                  const SizedBox(height: 10),
                                  _buildContactInfo("Open Time :",
                                      widget.restaurant.openTime.toString()),
                                  const SizedBox(height: 5),
                                  _buildContactInfo("The area :", ""),
                                  const SizedBox(height: 5),
                                  _latitude != null && _longitude != null
                                      ? Container(
                                          height: 250,
                                          child: MapScreen(
                                            coordinates: [
                                              LatLng(_latitude!,
                                                  _longitude!), // Đưa vào danh sách
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        )
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: SingleChildScrollView(
                              child:
                                  // Tab Review
                                  Obx(() {
                                if (controller.isLoading.value) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                print("Average raing: " +
                                    controller.averageRating.value.toString());
                                print("totals review: " +
                                    controller.totalReviews.value.toString());
                                return ReviewWidget(
                                    destinationId:
                                        widget.restaurant.destinationID,
                                    //reviews: controller.reviews,
                                    ratingCounts: controller.ratingCounts,
                                    UserId: Get.find<AuthController>().userId.value);
                              }),
                            ),
                          ),
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
