import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/models/cities_model.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/search_screen/hotel_search_screen.dart';
import 'package:travelappflutter/presentation/search_screen/restaurant_search_screen.dart';
import 'package:travelappflutter/presentation/search_screen/thing_to_do_screen.dart';
import 'package:travelappflutter/routes/app_routes.dart';
import './widgets/recomendate.dart';
import 'package:iconsax/iconsax.dart';
import './widgets/popular_place.dart';
import './models/travel_model.dart';

class HomeScreen extends StatefulWidget {
  final List<TravelDestination> destinations;
  final bool show;

  const HomeScreen({super.key, required this.destinations, this.show = true});

  @override
  State<HomeScreen> createState() => _TravelHomeScreenState();
}

class _TravelHomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var cityDescription = myCities
        .firstWhere(
          (city) => city.name.toLowerCase().contains("da nang"),
        )
        .description;

    List<TravelDestination> popularDestinations = widget.destinations
        .where((destination) => destination.category == 'popular')
        .toList();

    List<TravelDestination> recommendDestinations = widget.destinations
        .where((destination) => destination.category == 'recomend')
        .toList();

    List<String> allImages = [
      ...widget.destinations
          .where((destination) =>
              destination.location.toLowerCase().contains("da nang"))
          .expand((destination) => destination.image ?? []),
      ...myCities
          .where((city) => city.name.toLowerCase().contains("da nang"))
          .expand((city) => city.images ?? []),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: headerParts(),
      body: ListView(
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
          if (widget.show)
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Padding trái phải
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Canh lề trái
                children: [
                  Text(
                    'Da Nang', // Tên thành phố
                    style: TextStyle(
                      fontSize: 24, // Kích thước chữ lớn
                      fontWeight: FontWeight.bold, // Chữ in đậm
                      color: Colors.black, // Màu chữ đen
                    ),
                  ),
                  SizedBox(
                      height: 8), // Khoảng cách giữa tên thành phố và mô tả
                  Text(
                    cityDescription, // Hiển thị mô tả của thành phố
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5, // Điều chỉnh khoảng cách dòng
                    ),
                    maxLines: 100, // Giới hạn số dòng mô tả
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left, // Căn đều văn bản
                    softWrap: true, // Tự động xuống dòng nếu văn bản quá dài
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
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
      ),
      bottomNavigationBar: CustomBottomNavBar(controller: HomeController()),
    );
  }

  AppBar headerParts() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[200], // Thay đổi màu nền sáng hơn
      leadingWidth: 180,
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
            const Text(
              "Da Nang",
              style: TextStyle(
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
                      destinations: myDestination,
                    ),
                  ),
                );
                break;
              case 'Hotels':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelSearchScreen(),
                  ),
                );
                break;
              case 'Restaurants':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantSearchScreen(),
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
