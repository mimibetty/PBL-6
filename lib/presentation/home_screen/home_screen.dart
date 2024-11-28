import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  final TopicController topicController = Get.put(TopicController()); // Khởi tạo controller
  final ProfileController profileController = Get.put(ProfileController());

  // Gọi hàm lọc dựa trên `Topic`
  void filterDestinationsByTopic(String topic) {
    topicController.fetchDestinationsByTopic(topic); // Gọi API cho từng `Topic`
  }

  @override
  void initState() {
    super.initState();
    _fetchDestinations(); // Fetch destinations based on parameters
  }
Future<void> _fetchDestinations() async {
  if (widget.tag != null) {
    await topicController.fetchDestinationsByTopic(widget.tag!);
    homeController.myDestination.value = topicController.destinations.value;

  } else if (widget.cityID != null || widget.cityName != null) {
    await homeController.getDestinationByCityID(widget.cityID!, widget.cityName!);
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
List<TravelDestination> getThingsToDoDestinations(List<TravelDestination> destinations) {
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
        // tạm thời để trống, xử lý sau
        List<TravelDestination> popularDestinations = homeController.myDestination.value.toList();
        List<TravelDestination> recommendDestinations = homeController.myDestination.value.toList();

        // List<TravelDestination> popularDestinations = homeController.myDestination.value
        //     .where((destination) => destination.category == 'popular')
        //     .toList();

        // List<TravelDestination> recommendDestinations = homeController.myDestination.value
        //     .where((destination) => destination.category == 'recommend')
        //     .toList();

        // List<String> allImages = [
        //   ...homeController.myDestination.value
        //       .where((destination) =>
        //           destination.location.toLowerCase().contains(widget.cityName!))
        //       .expand((destination) => destination.images ?? []),
        //   ...Get.find<WelcomeController>().myCities.value
        //       .where((city) => city.name.toLowerCase().contains(widget.cityName!))
        //       .expand((city) => city.images!.cast<String>()),
        // ];
        // các địa điểm từ `myDestination` thỏa mãn điều kiện
          var destinations = homeController.myDestination.value
              .where((destination) =>
                  destination.address.district.contains(widget.cityName!))
              .toList();
          // các thành phố từ `myCities` thỏa mãn điều kiện
          var cities = Get.find<WelcomeController>().myCities.value
              .where((city) => city.name.contains(widget.cityName!))
              .toList();
          // Sau khi in, tạo `allImages` như trước:
          List<String> allImages = [
            ...destinations.expand((destination) => destination.images ?? []),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular place",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 14,
                      color: blueTextColor,
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
                  popularDestinations.length,
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommendation for you",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(
                      fontSize: 14,
                      color: blueTextColor,
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
                  recommendDestinations.length,
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
                      child: Recomendate(
                        destination: recommendDestinations[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(controller: homeController),
    );
  }

  AppBar headerParts() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[200], // Thay đổi màu nền sáng hơn
      leadingWidth: 500,//Tránh overflow
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
                      destinations: getThingsToDoDestinations(homeController.myDestination.value),),
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
                     hotelIDs: getHotelIDs(homeController.myDestination.value), // Directly fetching hotel IDs here
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
                     restaurantIDs: getRestaurantIDs(homeController.myDestination.value), // Directly fetching hotel IDs here
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