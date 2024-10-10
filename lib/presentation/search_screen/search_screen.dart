import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';
import 'package:travelappflutter/presentation/home_screen/restaurant_detail.dart' as detail;
import 'package:travelappflutter/presentation/home_screen/widgets/popular_place.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/recomendate.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/search_screen/models/restaurant_model.dart';
import 'package:travelappflutter/presentation/search_screen/restaurant_search_screen.dart' as search;


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
  if (!_tabController.indexIsChanging) {
    if (_tabController.index == 3) {
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => search.RestaurantSearchScreen(), // Điều hướng đến trang RestaurantSearchScreen
          ),
        );
      });
    }
  }
});

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách các địa điểm phổ biến và được đề xuất
    List<TravelDestination> popularDestinations = myDestination
        .where((destination) => destination.category == 'popular')
        .toList();
    List<TravelDestination> recommendDestinations = myDestination
        .where((destination) => destination.category == 'recomend')
        .toList();
    List<Restaurant> restaurants =
        restaurantList // Danh sách cho Special Offers
            .where((destination) => destination.rating > 3.5)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Where to?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            Tab(icon: Icon(Icons.search), text: "Search All"),
            Tab(icon: Icon(Icons.hotel), text: "Hotels"),
            Tab(icon: Icon(Icons.event), text: "Things to Do"),
            Tab(icon: Icon(Icons.restaurant), text: "Restaurants"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Thêm khoảng cách giữa TabBar và Search bar
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Phần tìm kiếm
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Places to go, things to do, hotels...',
                        suffixIcon: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              // Add search logic here
                            },
                            child: Text("Search",
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              primary: Colors.black,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Vùng hiển thị ảnh
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Image.network(
                      'https://media.istockphoto.com/id/827263174/photo/travel-planning-on-computer.jpg?s=612x612&w=0&k=20&c=jb2zUVSEygvRed_4Nns-8YLqQUFo5H5XaQzceIMrSuI=',
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 20),
                  // Section for Popular Places
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Destination Spotlight",
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
                  // Hiển thị các địa điểm phổ biến
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

                  const SizedBox(height: 20),
                  // Section for Recommended Places
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "More to explore",
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
                  // Hiển thị các địa điểm được đề xuất
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

                  // Thêm một phần mới cho Special Offers
                  // Hiển thị các nhà hàng đặc biệt từ danh sách restaurant
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "You may like these",
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
// Hiển thị các nhà hàng với ảnh từ cơ sở dữ liệu
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Row(
                      children: List.generate(
                        restaurants.length, // Sử dụng danh sách nhà hàng
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => detail.RestaurantDetailScreen(
                                    // Thay vì destination, dùng nhà hàng
                                    restaurant: restaurants[
                                        index], // Chuyển restaurant vào PlaceDetailScreen
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                // Hiển thị ảnh nhà hàng
                                Container(
                                  width: 200, // Kích thước ảnh
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          restaurants[index].images[0]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Hiển thị tên nhà hàng
                                Text(
                                  restaurants[index].restaurantName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                // Hiển thị rating với 5 ô tròn và số bài review
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 1; i <= 5; i++)
                                      Icon(
                                        Icons.circle,
                                        size: 12,
                                        color: i <=
                                                restaurants[index]
                                                    .rating
                                                    .floor()
                                            ? Color(
                                                0xFF13357B) // Màu chính: 13357B
                                            : (i ==
                                                        restaurants[index]
                                                                .rating
                                                                .floor() +
                                                            1 &&
                                                    restaurants[index].rating -
                                                            restaurants[index]
                                                                .rating
                                                                .floor() >=
                                                        0.5)
                                                ? Color(0xFF13357B).withOpacity(
                                                    0.5) // Màu nửa cho rating lẻ
                                                : Colors
                                                    .grey, // Màu xám cho phần còn lại
                                      ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${restaurants[index].rating.toString()} ★",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "(${restaurants[index].review} reviews)", // Số lượng reviews từ restaurant.review
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5),

                                // Hiển thị các features (tính năng) của nhà hàng
                                Wrap(
                                  spacing: 4,
                                  children: restaurants[index]
                                      .feature
                                      .map((feature) => Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 3),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                              feature,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      // Thanh điều hướng
      bottomNavigationBar: CustomBottomNavBar(controller: HomeController()),
    );
  }
}