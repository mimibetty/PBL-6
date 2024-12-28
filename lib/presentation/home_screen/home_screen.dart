import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelappflutter/presentation/common_views/see_all_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/controller/topic_controller.dart';
import 'package:travelappflutter/presentation/home_screen/controller/welcome_controller.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';
import 'package:travelappflutter/presentation/search_screen/hotel_search_screen.dart';
import 'package:travelappflutter/presentation/search_screen/restaurant_search_screen.dart';
import 'package:travelappflutter/presentation/search_screen/thing_to_do_screen.dart';
import './widgets/recomendate.dart';
import 'package:iconsax/iconsax.dart';
import './widgets/popular_place.dart';
import './models/travel_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final int? cityID;
  final String? cityName;
  final String? tag;
  final bool show;

  const HomeScreen({
    super.key,
    this.cityID,
    this.cityName,
    this.tag,
    this.show = true,
  });

  @override
  State<HomeScreen> createState() => _TravelHomeScreenState();
}

class _TravelHomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final TopicController topicController =
      Get.put(TopicController()); // Khởi tạo controller
  final ProfileController profileController = Get.put(ProfileController());

  // Gọi hàm lọc dựa trên `Topic`
  void filterDestinationsByTopic(String topic) {
    topicController.fetchDestinationsByTopic(topic); // Gọi API cho từng `Topic`
  }

  Future<bool> _initializeIsLiked(String destinationId) async {
  final String baseUrl =
      "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net";
  final String userId = Get.find<ProfileController>().profileModelObj.value.id.toString();

  try {
    // Tạo URL request
    final Uri url = Uri.parse('$baseUrl/user/$userId/has_liked/$destinationId');

    // Gửi request GET
    final response = await http.get(url);

    // Kiểm tra trạng thái HTTP response
    if (response.statusCode == 200) {
      // Parse kết quả trả về
      final bool likeStatus = response.body.toLowerCase() == 'true';
      return likeStatus; // Trả về giá trị true/false
    } else {
      // Xử lý khi API trả về mã lỗi
      debugPrint('Failed to fetch like status: ${response.statusCode}');
      return false; // Trả về false nếu có lỗi
    }
  } catch (e) {
    // Xử lý lỗi nếu có
    debugPrint('Error checking like status: $e');
    return false; // Trả về false nếu có lỗi
  }
}



  @override
  void initState() {
    super.initState();
    _fetchDestinations(); // Fetch destinations based on parameters
  }

Future<void> _fetchDestinations() async {
  if (widget.tag != null) {
    // Nếu `tag` không null, lấy dữ liệu theo chủ đề
    await topicController.fetchDestinationsByTopic(widget.tag!);
    homeController.myDestination.value = topicController.destinations;
  } else if (widget.cityID != null && widget.cityName != null) {
    // Nếu `cityID` và `cityName` không null, gọi cả hai hàm
    await Future.wait([
      homeController.getPopularDestinations(widget.cityID!, widget.cityName!),
      homeController.getRecommendationDestinations(profileController.profileModelObj.value.id,widget.cityID!, widget.cityName!),
    ]);
  }
}


// Chuyển đổi danh sách điểm đến thành danh sách hotelId
  List<int> getHotelIDs(List<TravelDestination> destinations) {
    return destinations
        .where((destination) => destination.hotelId != null)
        .map((destination) => destination.hotelId!)
        .toList();
  }

// Chuyển đổi danh sách điểm đến thành danh sách restaurantId
  List<int> getRestaurantIDs(List<TravelDestination> destinations) {
    return destinations
        .where((destination) => destination.restaurantId != null)
        .map((destination) => destination.restaurantId!)
        .toList();
  }

// Chuyển đổi danh sách điểm đến thành danh sách TravelDestination nếu cả hotelId và restaurantId đều null
  List<TravelDestination> getThingsToDoDestinations(
      List<TravelDestination> destinations) {
    return destinations
        .where((destination) =>
            destination.hotelId == null && destination.restaurantId == null)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: headerParts(),
      body: Obx(() {
        List<TravelDestination> popularDestinations;
        List<TravelDestination> recommendDestinations;

        if (widget.tag != null) {
          // Chia đôi danh sách nếu widget.tag != null
          List<TravelDestination> allDestinations = homeController.myDestination.value.toList();
          int midIndex = (allDestinations.length / 2).ceil();

          popularDestinations = allDestinations.sublist(0, midIndex); // Nửa đầu danh sách
          recommendDestinations = allDestinations.sublist(midIndex); // Nửa sau danh sách
        } else {
          // Lấy từ controller nếu widget.tag == null
          popularDestinations = homeController.popularDestinations.value;
          recommendDestinations = homeController.recommendationDestinations.value;

        }

        var cities = Get.find<WelcomeController>()
            .myCities
            .value
            .where((city) => city.name.contains(widget.cityName!))
            .toList();
        // Sau khi in, tạo `allImages` như trước:
        List<String> allImages = [
          ...homeController.popularDestinations.value.expand((destination) => destination.images),
          ...cities.expand((city) => city.images.map((image) => image.url)),
        ];

        return ListView(
          children: [
            const SizedBox(height: 20),
            // Show slider only if widget.show is true
            if (widget.show) ...[
              // Section for Image Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 1500),
                  viewportFraction: 1,
                ),
                items: allImages.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
            // Section for Popular places
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular Places",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: popularDestinations.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SeeAllScreen(
                                  title: "Popular Places",
                                  destinations: popularDestinations,
                                ),
                              ),
                            );
                          }
                        : null, // Vô hiệu hóa nếu không có dữ liệu
                    child: const Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 14,
                        color: blueTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                children: List.generate(
                  popularDestinations.length <= 8 ? popularDestinations.length : 8,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailScreen(
                              destination: popularDestinations[index],
                            ),
                          ),
                        );
                      },
                      child: PopularPlace(
                        destination: popularDestinations[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Section for Recommendations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recommendation for you",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: recommendDestinations.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SeeAllScreen(
                                  title: "Recommended for You",
                                  destinations: recommendDestinations,
                                ),
                              ),
                            );
                          }
                        : null, // Vô hiệu hóa nếu danh sách rỗng
                    child: const Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 14,
                        color: blueTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: List.generate(
                  recommendDestinations.length <= 8 ? recommendDestinations.length : 8,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailScreen(
                              destination: recommendDestinations[index],
                            ),
                          ),
                        );
                      },
                      child: FutureBuilder<bool>(
                        future: _initializeIsLiked(recommendDestinations[index].id.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Recomendate(
                              destination: recommendDestinations[index],
                              isLiked: snapshot.data ?? false,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  AppBar headerParts() {
    
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[200], // Thay đổi màu nền sáng hơn
      leadingWidth: 500, //Tránh overflow
      leading: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.black), // Màu biểu tượng back
              onPressed: () {
                Navigator.pop(context); // Quay lại trang trước đó
              },
            ),
            const SizedBox(width: 5),
            const Icon(
              Iconsax.location,
              color: Colors.black, // Màu biểu tượng location
            ),
            const SizedBox(width: 5),
            Text(
              widget.cityName ?? 'Unknown City', // Tên thành phố hien tại
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black87, // Màu chữ tối hơn
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 30,
              color: Colors.black26, // Màu mũi tên
            ),
          ],
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu,
              color: Colors.black, size: 30), // Màu biểu tượng menu
          onSelected: (value) {
            // Xử lý sự kiện khi chọn một mục trong menu
            switch (value) {
              case 'Things to do':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThingToDoScreen(
                      cityNames: widget.cityName!,
                      destinations: getThingsToDoDestinations(homeController.combineDestinations(homeController.popularDestinations.value, homeController.recommendationDestinations.value)),
                      cityID: widget.cityID!,
                    )
                  ),
                );
                break;
              case 'Hotels':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelSearchScreen(
                      cityNames: widget.cityName!,
                      cityID: widget.cityID!,
                      hotelIDs: getHotelIDs(homeController.combineDestinations(homeController.popularDestinations.value, homeController.recommendationDestinations.value)), // Directly fetching hotel IDs here
                    ),
                  ),
                );
                break;
              case 'Restaurants':
                Navigator.push(
                context,
                
                MaterialPageRoute(
                  builder: (context) => RestaurantSearchScreen(
                     cityNames: widget.cityName!,
                     cityID: widget.cityID!,
                     restaurantIDs: getRestaurantIDs(homeController.combineDestinations(homeController.popularDestinations.value, homeController.recommendationDestinations.value)), // Directly fetching hotel IDs here
                  ),
                ),
              );
                break;
            }
          },
          // Thay đổi màu nền và màu chữ của menu
          color: Colors.white, // Màu nền của menu
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'Things to do',
                child: Text(
                  'Things to do',
                  style: TextStyle(color: Colors.black), // Màu chữ
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Hotels',
                child: Text(
                  'Hotels',
                  style: TextStyle(color: Colors.black), // Màu chữ
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Restaurants',
                child: Text(
                  'Restaurants',
                  style: TextStyle(color: Colors.black), // Màu chữ
                ),
              ),
            ];
          },
        ),
        const SizedBox(width: 15),
      ],
    );
  }
}
