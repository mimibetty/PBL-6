import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:travelappflutter/presentation/business_creation_screen/controller/business_info_controller.dart';
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';
import 'package:travelappflutter/presentation/map/map_screen.dart';

class BusinessPostScreen extends StatefulWidget {
  @override
  _BusinessPostScreenState createState() => _BusinessPostScreenState();
}

class _BusinessPostScreenState extends State<BusinessPostScreen> {
  final BusinessInfoController businessController = Get.put(BusinessInfoController());
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (businessController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final business = businessController.business.value;

        if (business.id == '0') {
          return Center(
            child: Text("No Business Data Available"),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBusinessHeader(business),
              const SizedBox(height: 15),
              _buildBusinessDetails(business),
              const SizedBox(height: 15),
              _buildImagesSlider(business.images),
            ],
          ),
        );
      }),
      // bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 2,
      backgroundColor: Colors.white,
      title: Text(
        "Business Details",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.black),
          onSelected: (value) {
            switch (value) {
              case 'Facilities':
              case 'Hotels':
              case 'Restaurants':
              case 'Tours':
                _navigateToBusinessesFacilities();
                break;
              case 'Business Statistics':
                _navigateToBusinessesDashboard(context, 'restaurant');
                break;
            }
          },
          itemBuilder: (context) {
            return [
              _buildPopupMenuItem('Tours'),
              _buildPopupMenuItem('Facilities'),
              _buildPopupMenuItem('Hotels'),
              _buildPopupMenuItem('Restaurants'),
              _buildPopupMenuItem('Business Statistics'),
            ];
          },
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String text) {
    return PopupMenuItem(
      value: text,
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildBusinessHeader(Business business) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.network(
                business.logoUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.business,
                        size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    business.address,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        business.address.isNotEmpty
            ? Container(
                height: 250,
                child: MapScreen(
                  coordinates: [
                    LatLng(21.0228, 105.855), // Replace with actual coordinates
                  ],
                  zoom: 14.0,
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }

  Widget _buildBusinessDetails(Business business) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.phone, business.phoneNumber),
            const SizedBox(height: 3),
            _buildDetailRow(Icons.email, business.email),
            const SizedBox(height: 3),
            _buildDetailRow(Icons.info, business.description),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesSlider(List<String> images) {
    if (images.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            const SizedBox(height: 10),
            const Text(
              'No Images Available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported,
                      size: 40, color: Colors.grey),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.map((image) {
            int index = images.indexOf(image);
            return Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentImageIndex == index ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Widget _buildBottomNavBar() {
  //   return BottomAppBar(
  //     shape: CircularNotchedRectangle(),
  //     notchMargin: 6.0,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         IconButton(
  //           icon: Icon(Icons.home, color: Colors.blue),
  //           onPressed: () {
  //             // Navigate to Home
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.dashboard, color: Colors.grey),
  //           onPressed: () {
  //             // Navigate to Dashboard
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.person, color: Colors.grey),
  //           onPressed: () {
  //             // Navigate to Profile
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _navigateToBusinessesDashboard(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Container(), // Replace with actual dashboard screen
      ),
    );
  }

  void _navigateToBusinessesFacilities() {
    // Navigation logic for facilities
  }
}
