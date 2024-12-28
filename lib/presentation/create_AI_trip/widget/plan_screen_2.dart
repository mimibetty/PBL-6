import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_3.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/search_screen/controller/search_controller.dart';

class PlanScreen2 extends StatefulWidget {
  @override
  _PlanScreen2State createState() => _PlanScreen2State();
}

class _PlanScreen2State extends State<PlanScreen2> with SingleTickerProviderStateMixin {
  final SearchDestinationController searchController = Get.put(SearchDestinationController());
  final PlanScreenController planScreenController = Get.put(PlanScreenController());
  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Where do you want to go?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchTextController,
                  onChanged: (query) {
                    searchController.fetchSearchResults(query);
                  },
                  decoration: InputDecoration(
                    hintText: 'Places to go, things to do, hotels...',
                    hintStyle: TextStyle(color: Colors.black),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          searchController.fetchSearchResults(searchTextController.text);
                        },
                        child: Text("Search", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'City/Town',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (searchController.isLoading.value) {
                return Center(child: CircularProgressIndicator(color: Colors.blue));
              } else if (searchController.searchResults.isEmpty) {
                return Center(child: Text('No results found', style: TextStyle(color: Colors.black)));
              } else {
                // Filter the search results to only include cities
                final cityResults = searchController.searchResults
                    .where((item) => item['type'] == 'city')
                    .toList();
                return ListView.builder(
                  itemCount: cityResults.length,
                  itemBuilder: (context, index) {
                    final item = cityResults[index];
                    return ListTile(
                      title: Text(item['name'], style: TextStyle(color: Colors.black)),
                      onTap: () {
                        planScreenController.setSelectedCity(item['name'], item['id']);
                        searchTextController.clear();
                        searchController.searchResults.clear();
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Selected city: ${item['name']}'),
                        //     backgroundColor: Colors.blue,
                        //   ),
                        // );
                      },
                    );
                  },
                );
              }
            }),
          ),
          Obx(() {
            if (planScreenController.cityName.isNotEmpty) {
              return Column(
                children: [
                  Text(
                    'Selected City: ${planScreenController.cityName.value}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlanScreen3()),
                      );
                    },
                    child: Text("Next", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(controller: HomeController()),
    );
  }
}