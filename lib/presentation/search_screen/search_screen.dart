import 'package:flutter/material.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/place_detail.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/popular_place.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/recomendate.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/search_screen/controller/search_controller.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final SearchDestinationController searchController = Get.put(SearchDestinationController());
  
  @override
  void initState() {
    super.initState();
    // Gọi API khi khởi tạo màn hình
    searchController.fetchAllDestinations();
    _tabController = TabController(length: 4, vsync: this);
    // _tabController.addListener(() {
    //   if (!_tabController.indexIsChanging) {
    //     if (_tabController.index == 3) {
    //       Future.microtask(() {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (_) => search
    //                 .RestaurantSearchScreen(), // Điều hướng đến trang RestaurantSearchScreen
    //           ),
    //         );
    //       });
    //     }
    //   }
    //   if (!_tabController.indexIsChanging) {
    //     if (_tabController.index == 2) {
    //       Future.microtask(() {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (_) => ThingToDoScreen(
    //                 destinations:
    //                     daNangDestinations), // Điều hướng đến trang RestaurantSearchScreen
    //           ),
    //         );
    //       });
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                  // Phần tìm kiếm
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (query) => searchController.onSearchChanged(query), // Gọi debounce trong controller
                          decoration: InputDecoration(
                            hintText: 'Places to go, things to do, hotels...',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search, color: Colors.white),
                              onPressed: () {
                                // Nếu muốn thêm hành động khi nhấn nút Search
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          if (searchController.isLoading.value) {
                            return CircularProgressIndicator(); // Hiển thị spinner khi đang tải
                          }

                          if (searchController.searchResults.isEmpty) {
                            return Text('No results found.', style: TextStyle(color: Colors.grey));
                          }

                          return SizedBox(
                            height: 200, // Giới hạn chiều cao để cuộn
                            child: ListView.builder(
                              itemCount: searchController.searchResults.length,
                              itemBuilder: (context, index) {
                                final item = searchController.searchResults[index];

                                return ListTile(
                                  title: Text(item['name']),
                                  subtitle: Text(item['type'] == 'city' ? "City" : "Destination"),
                                  onTap: () {
                                    searchController.handleResultClick(item, context); // Xử lý khi click vào kết quả
                                  },
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),
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
                  // Destination Spotlight Section
                  Obx(() {
                    if (searchController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (searchController.spotlightDestinations.isEmpty) {
                      return const Center(
                        child: Text("No destinations found."),
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Row(
                        children: List.generate(
                          searchController.spotlightDestinations.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlaceDetailScreen(
                                      destination: searchController.spotlightDestinations[index],
                                    ),
                                  ),
                                );
                              },
                              child: PopularPlace(
                                destination: searchController.spotlightDestinations[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

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
                  // More to Explore Section
                  Obx(() {
                    // Kiểm tra trạng thái danh sách
                    if (searchController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (searchController.moreExploreDestinations.isEmpty) {
                      return const Center(
                        child: Text("Không có địa điểm để hiển thị."),
                      );
                    }

                    // Nếu có dữ liệu, hiển thị danh sách
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: List.generate(
                          searchController.moreExploreDestinations.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlaceDetailScreen(
                                      destination: searchController.moreExploreDestinations[index],
                                    ),
                                  ),
                                );
                              },
                              child: Recomendate(
                                destination: searchController.moreExploreDestinations[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
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

                  // Thêm một phần mới cho Special Offers
                  // Hiển thị các Destination Recommend từ API
                  Obx(() {
                    if (searchController.searchRecommendations.isEmpty) {
                      return const Center(
                        child: Text("No recommendations found."),
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Row(
                        children: List.generate(
                          searchController.searchRecommendations.length, // Sử dụng danh sách gợi ý
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlaceDetailScreen(
                                      // Chuyển search recommendation vào PlaceDetailScreen
                                      destination: searchController.searchRecommendations[index],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  // Hiển thị ảnh recommendation destination
                                  Container(
                                    width: 200, // Kích thước ảnh
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            searchController.searchRecommendations[index].images.isNotEmpty
                                                ? searchController.searchRecommendations[index].images[0]
                                                : 'https://via.placeholder.com/200x150'), // Placeholder nếu không có ảnh
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Hiển thị tên recommendation destination
                                  Text(
                                    searchController.searchRecommendations[index].name,
                                    style: const TextStyle(
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
                                                  searchController
                                                      .searchRecommendations[index].rating
                                                      .floor()
                                              ? const Color(0xFF13357B) // Màu chính: 13357B
                                              : (i ==
                                                          searchController
                                                                  .searchRecommendations[index]
                                                                  .rating
                                                                  .floor() +
                                                              1 &&
                                                      searchController
                                                              .searchRecommendations[index]
                                                              .rating -
                                                          searchController
                                                              .searchRecommendations[index]
                                                              .rating
                                                              .floor() >=
                                                          0.5)
                                                  ? const Color(0xFF13357B).withOpacity(
                                                      0.5) // Màu nửa cho rating lẻ
                                                  : Colors.grey, // Màu xám cho phần còn lại
                                        ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${searchController.searchRecommendations[index].rating.toStringAsFixed(1)} ★",
                                        style:
                                            const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "(${searchController.searchRecommendations[index].numOfReviews} reviews)", // Số lượng reviews từ reviewCount
                                        style:
                                            const TextStyle(fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 5),

                               // Hiển thị các features (opentime, age, price_bottom-price_top)
                              Wrap(
                                spacing: 4,
                                children: [
                                  // Hiển thị thời gian mở cửa
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      "Open: ${searchController.searchRecommendations[index].openTime}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),

                                  // // Hiển thị độ tuổi
                                  // Container(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.black.withOpacity(0.1),
                                  //     borderRadius: BorderRadius.circular(15),
                                  //   ),
                                  //   child: Text(
                                  //     "Age: ${searchController.searchRecommendations[index].age}",
                                  //     style: const TextStyle(
                                  //       fontSize: 12,
                                  //       color: Colors.black87,
                                  //     ),
                                  //   ),
                                  // ),

                                  // Hiển thị giá (price_bottom-price_top)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      "Price: ${searchController.searchRecommendations[index].priceBottom} - ${searchController.searchRecommendations[index].priceTop} \$",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

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
