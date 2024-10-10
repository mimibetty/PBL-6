import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/models/cities_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/popular_place.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/recomendate.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/routes/app_routes.dart';
import 'package:iconsax/iconsax.dart';

class ThingToDoScreen extends StatefulWidget {
  final List<TravelDestination> destinations;

  const ThingToDoScreen({super.key, required this.destinations});

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
  @override
  Widget build(BuildContext context) {
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
                    children: const [
                      Text(
                        "Thing to Do in Da Nang",
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: List.generate(
                9, // Tổng số button
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press here
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          [
                            Icons.sunny,
                            Icons.access_time,
                            Icons.park,
                            Icons.diamond,
                            Icons.sunny_snowing,
                            Icons.shopping_cart,
                            Icons.nightlight_round,
                            Icons.directions_walk,
                            Icons.history
                          ][index],
                          size: 24,
                          color: Colors.black, // Đặt màu icon là đen
                        ),
                        const SizedBox(
                            height: 8), // Khoảng cách giữa icon và text
                        Text(
                          [
                            "Day Trips",
                            "Half-day Tours",
                            "Theme Parks",
                            "Private & Luxury",
                            "Full-day Tours",
                            "Shopping Malls",
                            "Night Tours",
                            "Walking Tours",
                            "Historical Tours"
                          ][index],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black, // Màu chữ đen
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                            height: 4), // Khoảng cách giữa text và số
                        Text(
                          '(${(index + 1) * 5})', // Hiển thị số lượng giả định
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black, // Màu chữ đen
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
