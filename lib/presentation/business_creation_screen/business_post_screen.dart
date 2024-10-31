import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:travelappflutter/presentation/business_creation_screen/business_list_screen.dart';
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';

class BusinessPostScreen extends StatefulWidget {
  final Business business;

  BusinessPostScreen({required this.business});

  @override
  _BusinessPostScreenState createState() => _BusinessPostScreenState();
}

class _BusinessPostScreenState extends State<BusinessPostScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.business.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerParts(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.business.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Địa chỉ: ${widget.business.address}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Số điện thoại: ${widget.business.phoneNumber}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
              'Mô tả: ${widget.business.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.business.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        widget.business.images[index],
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                              child: Icon(Icons.error, color: Colors.red));
                        },
                        fit: BoxFit.cover, // Đảm bảo hình ảnh vừa khung
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar headerParts(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[200],
      title:
          Text("Business Details Page", style: TextStyle(color: Colors.black)),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.black, size: 30),
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
          color: Colors.white,
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'Things to do',
                child:
                    Text('Things to do', style: TextStyle(color: Colors.black)),
              ),
              const PopupMenuItem<String>(
                value: 'Hotels',
                child: Text('Hotels', style: TextStyle(color: Colors.black)),
              ),
              const PopupMenuItem<String>(
                value: 'Restaurants',
                child:
                    Text('Restaurants', style: TextStyle(color: Colors.black)),
              ),
            ];
          },
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  void _navigateToFilteredBusinesses(BuildContext context, String type) {
    List<String> businessUnits = widget.business.businessUnits;

    // In ra giá trị của businessUnits để kiểm tra
    print('Business Units: $businessUnits');

    // Kiểm tra xem businessUnits có phải là danh sách chứa các chuỗi ID hay không
    List<int> hotelIds = businessUnits.length > 0
        ? businessUnits[0]
            .split(',')
            .map((id) => int.tryParse(id) ?? 0)
            .toList()
        : [];

    List<int> restaurantIds = businessUnits.length > 1
        ? businessUnits[1]
            .split(',')
            .map((id) => int.tryParse(id) ?? 0)
            .toList()
        : [];

    List<int> thingsToDoIds = businessUnits.length > 2
        ? businessUnits[2]
            .split(',')
            .map((id) => int.tryParse(id) ?? 0)
            .toList()
        : [];

    // Kiểm tra kết quả
    print('Hotel IDs: $hotelIds');
    print('Restaurant IDs: $restaurantIds');
    print('Things to Do IDs: $thingsToDoIds');

    // Lọc doanh nghiệp dựa trên loại
    List<Business> filteredBusinesses;

    switch (type) {
      case 'Restaurants':
        filteredBusinesses = mockBusinessDatabase.where((business) {
          return restaurantIds.contains(int.parse(business.id)); // Lọc theo ID
        }).toList();
        break;

      case 'Hotels':
        filteredBusinesses = mockBusinessDatabase.where((business) {
          return hotelIds.contains(int.parse(business.id)); // Lọc theo ID
        }).toList();
        break;

      case 'Things to do':
        filteredBusinesses = mockBusinessDatabase.where((business) {
          return thingsToDoIds.contains(int.parse(business.id)); // Lọc theo ID
        }).toList();
        break;

      default:
        filteredBusinesses = []; // Trường hợp không xác định
        break;
    }

    // Chuyển đến màn hình danh sách doanh nghiệp
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BusinessListScreen(filteredBusinesses: filteredBusinesses),
      ),
    );
  }
}
