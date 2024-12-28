import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/common_views/heart_icon_widget.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';

class FavouriteScreen extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final userId = profileController.profileModelObj.value.id;
    profileController.fetchLikedDestinations(userId); // Fetch dữ liệu khi màn hình mở

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text('Favourite Destinations'),
      ),
      body: Obx(() {
        // Hiển thị loading spinner nếu dữ liệu đang được tải
        if (profileController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Hiển thị thông báo nếu danh sách yêu thích rỗng
        if (profileController.likedDestinations.isEmpty) {
          return const Center(
            child: Text(
              'No favourite destinations found!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Hiển thị danh sách điểm đến yêu thích
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: profileController.likedDestinations.length,
            itemBuilder: (context, index) {
              var destination = profileController.likedDestinations[index];
              return GestureDetector(
                onTap: () {
                  // Điều hướng đến màn hình chi tiết
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hình ảnh với icon trái tim
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                destination.images.isNotEmpty
                                    ? destination.images[0]
                                    : 'https://via.placeholder.com/100',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: HeartIconWidget(
                                userId: userId,
                                destinationId: destination.id,
                                isLiked: true,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Nội dung chi tiết
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                destination.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                destination.location,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                destination.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow[700],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${destination.rating.toStringAsFixed(2)} (${destination.numOfReviews} reviews)',
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
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
