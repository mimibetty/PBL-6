import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/common_views/heart_icon_widget.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late List<TravelDestination> randomDestinations;
    bool isLiked = true;

  @override
  void initState() {
    super.initState();
    // Lấy danh sách các điểm đến từ HomeController
    List<TravelDestination> allDestinations =
        Get.find<HomeController>().myDestination.value;
    randomDestinations = _getRandomDestinations(allDestinations);
  }

  // Hàm lấy ngẫu nhiên 2 địa điểm từ danh sách
  List<TravelDestination> _getRandomDestinations(
      List<TravelDestination> destinations) {
    // Nếu danh sách có ít hơn 2 địa điểm, trả về tất cả
    if (destinations.length <= 2) {
      return destinations;
    }

    // Lấy ngẫu nhiên 2 địa điểm
    Random random = Random();
    Set<int> indices = Set<int>();
    while (indices.length < 2) {
      indices.add(random.nextInt(destinations.length));
    }

    return indices.map((index) => destinations[index]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Màu nền trắng
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text('Favourite Destinations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: randomDestinations.length,
          itemBuilder: (context, index) {
            var destination = randomDestinations[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh với biểu tượng trái tim
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            destination.images.isNotEmpty
                                ? destination.images[0]
                                : 'https://experienceleaguecommunities.adobe.com/t5/image/serverpage/image-id/34749i7C7BB1DB5E28E527?v=v2', // ảnh mặc định nếu không có ảnh
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: HeartIconWidget(
                            isLiked: isLiked,
                            onDoubleTap: () {
                              setState(() {
                                isLiked =
                                    !isLiked; // Thay đổi trạng thái nút tim
                              });
                            },
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16),
                    // Nội dung
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            destination.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            destination.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${destination.rating} (${destination.numOfReviews} reviews)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
