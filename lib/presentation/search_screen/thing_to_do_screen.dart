import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/common_views/see_all_widget.dart';
import 'package:travelappflutter/presentation/common_views/selectable_icon_button_widget.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/controller/tour_controller.dart';
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
  final int cityID;

  const ThingToDoScreen(
      {super.key, required this.destinations, required this.cityNames, required this.cityID});

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
  final ThingsToDoController thingsToDoController = Get.put(ThingsToDoController());
  final TourController tourController = Get.put(TourController());
  
  @override
  void initState() {
    super.initState();
    thingsToDoController.fetchTags();
    thingsToDoController.fetchAllThingsToDo(widget.cityID);
    tourController.fetchTourByCityID(widget.cityID);
  }

  @override
  Widget build(BuildContext context) {
    // List<TravelDestination> popularDestinations = widget.destinations.toList();
    List<TravelDestination> recommendDestinations =
        widget.destinations.toList();
    // Sắp xếp giảm dần theo rating
    recommendDestinations.sort((a, b) => b.rating.compareTo(a.rating));


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
          Obx(() {
            if (thingsToDoController.isLoadingForTags.value) {
              // Show loading indicator while tags are loading
              return const Center(child: CircularProgressIndicator());
            }
            if (thingsToDoController.tags.isEmpty) {
              // Display message if no tags are available
              return const Center(
                child: Text("No tags available."),
              );
            }
            return SelectableIconButtonWidget(
              buttonData: thingsToDoController.tags.map((tag) {
                return {
                  'label': tag.name,
                  'icon': _getIconForTag(tag.name),
                  'count' : tag.destinationCount,
                  //'count' : thingsToDoController.thingsToDoList.length,
                };
              }).toList(),
              onSelectionChanged: (selectedTagName) {
                final selectedTag = thingsToDoController.tags
                    .firstWhereOrNull((tag) => tag.name == selectedTagName);

                if (selectedTag != null) {
                  thingsToDoController.fetchThingsToDoByTag(
                    selectedTag.id,
                    widget.cityID,
                  );
                } else {
                  thingsToDoController.refreshThingsToDo(widget.cityID);
                  //Get.snackbar('Error', 'Tag not found');
                }
              },
            );
          }),
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
          const SizedBox(height: 12),
          Obx(() {
            if (tourController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (tourController.tours.isEmpty) {
              return const Center(child: Text("No tours available."));
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: List.generate(
                 tourController.tours.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 15, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TourDetailScreen(
                              tour:tourController.tours[index],
                              cityName: widget.cityNames,
                            ),
                          ),
                        );
                      },
                      child: TourWidget(
                        tour:tourController.tours[index],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
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