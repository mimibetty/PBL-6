import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/common_views/heart_icon_widget.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';

class FavouriteScreen extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    // Fetch liked destinations when the screen is opened
    final userId = profileController.profileModelObj.value.id;
    profileController.fetchLikedDestinations(userId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text('Favourite Destinations'),
      ),
      body: Obx(() {
        // Wait for the user ID to be available
        if (profileController.profileModelObj.value.id == 0) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Fetch liked destinations if not already fetched
        if (profileController.likedDestinations.isEmpty) {
          return const Center(
            child: Text(
              'No favourite destinations found!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: profileController.likedDestinations.length,
            itemBuilder: (context, index) {
              var destination = profileController.likedDestinations[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to place detail screen
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailScreen(destination: destination),
                  //   ),
                  // );
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
                        // Image with heart icon
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
                        // Content
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
