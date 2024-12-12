import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/common_views/selectable_icon_button_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/models/tour_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/popular_place.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/recomendate.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/tour.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/tour_detail_screen.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:travelappflutter/presentation/search_screen/controller/things_to_do_controller.dart';

class ThingToDoScreen extends StatefulWidget {
  final List<TravelDestination> destinations;
  final String cityNames;

  const ThingToDoScreen(
      {super.key, required this.destinations, required this.cityNames});

  @override
  State<ThingToDoScreen> createState() => _ThingToDoScreenState();
}

Widget experienceButton(String label, int count, IconData icon) {
  return OutlinedButton.icon(
    onPressed: () {
      // Handle button press
    },
    icon: Icon(icon, color: Colors.black),
    label: Text(
      "$label ($count)",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      side: const BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    ),
  );
}

class _ThingToDoScreenState extends State<ThingToDoScreen> {
  final ThingsToDoController thingsToDoController =
      Get.put(ThingsToDoController());

  @override
  void initState() {
    super.initState();
    // thingsToDoController.fetchTags();
    // thingsToDoController.fetchAllThingsToDo();
  }

  @override
  Widget build(BuildContext context) {
    // List<TravelDestination> popularDestinations = widget.destinations.toList();
    List<TravelDestination> recommendDestinations =
        widget.destinations.toList();
    final List<Tour> daNangTours =
        mockTours.where((tour) => tour.location == "Đà Nẵng").toList();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: headerParts(),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/33/f3/cf/caption.jpg?w=1200&h=900&s=1',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Things to Do in ${widget.cityNames}",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Discover the best activities to do in the beautiful coastal city of Da Nang.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
            child: const Text(
              "Explore popular experiences",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, left: 8.0, right: 8.0, bottom: 20.0),
            child: Text(
              "See what other travelers like to do, based on ratings and number of bookings.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          SelectableIconButtonWidget(
            buttonData: thingsToDoController.tags
                .map((tag) => {
                      'label': tag.name,
                      'icon': _getIconForTag(
                          tag.name), // Trả về IconData thay vì Icon
                    })
                .toList(),
            onSelectionChanged: (selectedTag) {
              // Khi người dùng chọn tag, load dữ liệu tương ứng
              final selectedTagId = thingsToDoController.tags
                  .firstWhere((tag) => tag.name == selectedTag)
                  .id;
              thingsToDoController.fetchThingsToDoByTag(selectedTagId);
            },
          ),

          const SizedBox(height: 15),
          // Hiển thị danh sách điểm đến tương ứng khi nhấn tag
          Obx(() {
            if (thingsToDoController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (thingsToDoController.thingsToDoList.isEmpty) {
              return const Center(child: Text("No activities found."));
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                children: List.generate(
                  thingsToDoController.thingsToDoList.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailScreen(
                              destination:
                                  thingsToDoController.thingsToDoList[index],
                            ),
                          ),
                        );
                      },
                      child: PopularPlace(
                        destination: thingsToDoController.thingsToDoList[index],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tours",
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
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Căn giữa các phần tử trong Row
              mainAxisSize: MainAxisSize
                  .min, // Đảm bảo Row không chiếm toàn bộ chiều ngang
              children: List.generate(
                daNangTours.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(
                      bottom: 15, right: 10), // Căn lề phải giữa các phần tử
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TourDetailScreen(
                            tour: daNangTours[index],
                          ),
                        ),
                      );
                    },
                    child: TourWidget(
                      tour: daNangTours[index],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(controller: HomeController()),
    );
  }

  AppBar headerParts() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: 180,
      leading: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 5),
            const Icon(
              Iconsax.location,
              color: Colors.black,
            ),
            const SizedBox(width: 5),
            const Text(
              "Da Nang",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 30,
              color: Colors.black26,
            ),
          ],
        ),
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

IconData _getIconForTag(String tagName) {
  switch (tagName) {
    case 'Food & Drink':
      return Icons.restaurant;
    case 'Cultural Heritage':
      return Icons.museum;
    case 'Historic Sites':
      return Icons.history;
    case 'Theaters & Art Galleries':
      return Icons.theater_comedy;
    case 'Natural & Wildlife':
      return Icons.nature;
    case 'Private & Luxury':
      return Icons.security;
    case 'Nightlife':
      return Icons.nightlife;
    case 'Landmarks':
      return Icons.landscape;
    case 'Shopping':
      return Icons.shopping_cart;
    case 'Outdoor Activities':
      return Icons.directions_run;
    case 'General':
      return Icons.language;
    default:
      return Icons.tag; // Mặc định là icon tag nếu không tìm thấy tên tương ứng
  }
}