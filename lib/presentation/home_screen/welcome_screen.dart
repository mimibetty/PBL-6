import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/home_screen.dart';
import 'package:travelappflutter/presentation/home_screen/models/cities_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/topic_model.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/city.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/recomendate_city.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/topic.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/routes/app_routes.dart';
import 'package:iconsax/iconsax.dart';
import './models/travel_model.dart'; // add this package first for icon

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _TravelWelcomeScreenState();
}

class _TravelWelcomeScreenState extends State<WelcomeScreen> {
  int selectedPage = 0;
  bool showCarousel = true; // Biến để theo dõi hiển thị CarouselSlider

  List<Topic> topics = TopicModel.getTopics(); // Get topics list
  List<TravelDestination> daNangDestinations = myDestination
      .where((element) => element.location == "Da Nang , Viet Nam")
      .toList();
  List<TravelDestination> popular =
      myDestination.where((element) => element.category == "popular").toList();

  List<City> popularCities =
      myCities.where((element) => element.rating >= 3.0).toList();

  List<TravelDestination> filterDestinationsByTopic(String topicTag) {
    return myDestination.where((destination) {
      return destination.tag.contains(topicTag);
    }).toList();
  }

  void navigateToProfile() {
    Get.toNamed(AppRoutes.searchScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: headerParts(),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Awesome topic",
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
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              children: List.generate(
                topics.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () {
                      // In ra console khi người dùng nhấn vào một topic
                      print("User clicked on topic: ${topics[index].name}");

                      // Lọc danh sách địa điểm dựa trên tag của topic
                      List<TravelDestination> filteredDestinations =
                          filterDestinationsByTopic(topics[index].name);

                      // In ra danh sách các địa điểm đã lọc
                      print(
                          "Filtered destinations for ${topics[index].name}:");
                      filteredDestinations.forEach((destination) {
                        print(
                            "Destination: ${destination.name}, Location: ${destination.location}");
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HomeScreen(destinations: filteredDestinations,show:false),
                        ),
                      );
                    },
                    child: TopicWidget(
                      topics[index], // Pass topic object to TopicWidget
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Cities",
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
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Sử dụng Expanded cho danh sách thành phố nổi bật
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: List.generate(
                popularCities.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                    onTap: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HomeScreen(destinations: daNangDestinations,show:true),
                        ),
                      );
                    },
                    child: RecomendateCity(
                      myCities: popularCities[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
          controller: HomeController()), // Thay thế bằng CustomBottomNavBar
    );
  }

  AppBar headerParts() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: 180,
      leading: const Row(
        children: [
          SizedBox(width: 15),
          Icon(
            Iconsax.location,
            color: Colors.black,
          ),
          SizedBox(width: 5),
          Text(
            "Da Nang",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 30,
            color: Colors.black26,
          ),
        ],
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.black12,
            ),
          ),
          padding: const EdgeInsets.all(7),
          child: const Stack(
            children: [
              Icon(
                Iconsax.notification,
                color: Colors.black,
                size: 30,
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }
}
