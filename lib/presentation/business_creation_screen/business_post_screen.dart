import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';
import 'package:travelappflutter/presentation/business_dashboard/business_dashboard.dart';
import 'package:travelappflutter/presentation/common_views/geocoding_service.dart';
import 'package:travelappflutter/presentation/map/map_screen.dart';

class BusinessPostScreen extends StatefulWidget {
  final Business business;

  BusinessPostScreen({required this.business});

  @override
  _BusinessPostScreenState createState() => _BusinessPostScreenState();
}

class _BusinessPostScreenState extends State<BusinessPostScreen> {
  int _currentImageIndex = 0; // Biến để quản lý chỉ báo vị trí
  String _address = '91 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội';


  double? _latitude; // Lưu trữ vĩ độ
  double? _longitude; // Lưu trữ kinh độ

  @override
  void initState() {
    super.initState();
    _getCoordinates(); // Fetch coordinates after init
  }

  void _getCoordinates() async {
    if (_address.isNotEmpty) {
      var coordinates =
          await GeocodingService.getCoordinatesFromAddress(_address);

      if (coordinates != null) {
        setState(() {
          _latitude = coordinates['latitude'];
          _longitude = coordinates['longitude'];
        });
        if (_latitude != null && _longitude != null) {
          print("IN ra: Latitude = $_latitude, Longitude = $_longitude");
        } else {
          print("Latitude hoặc Longitude chưa có giá trị.");
        }
      } else {
        print("Couldn't get coordinates.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBusinessHeader(),
            const SizedBox(height: 20),
            _buildBusinessDetails(),
            const SizedBox(height: 20),
            _buildImagesSlider(),
          ],
        ),
      ),
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
              case 'Things to do':
                _navigateToFilteredBusinesses(context, 'things to do');
                break;
              case 'Hotels':
                _navigateToFilteredBusinesses(context, 'hotel');
                break;
              case 'Restaurants':
                _navigateToFilteredBusinesses(context, 'restaurant');
                break;
            }
          },
          itemBuilder: (context) {
            return [
              _buildPopupMenuItem('Things to do'),
              _buildPopupMenuItem('Hotels'),
              _buildPopupMenuItem('Restaurants'),
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

  Widget _buildBusinessHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.network(
                widget.business.logoUrl,
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
                    widget.business.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.business.address,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Thêm khoảng cách giữa header và bản đồ
        _latitude != null && _longitude != null
            ? Container(
                height: 250,
                child: MapScreen(
                  latitude: 21.0137443130001,
                  longitude:105.798346108,
                ),
              )
            : Center(
                child:
                    CircularProgressIndicator()), // Show loading until coordinates are available
      ],
    );
  }

  Widget _buildBusinessDetails() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.phone, widget.business.phoneNumber),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.info, widget.business.description),
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

  Widget _buildImagesSlider() {
    if (widget.business.images.isEmpty) {
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
          itemCount: widget.business.images.length,
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
                widget.business.images[index],
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
          children: widget.business.images.map((image) {
            int index = widget.business.images.indexOf(image);
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

  void _navigateToFilteredBusinesses(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusinessDashboard(),
      ),
    );
  }
}
