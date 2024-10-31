import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';

class BusinessListScreen extends StatelessWidget {
  final List<Business> filteredBusinesses;

  BusinessListScreen({required this.filteredBusinesses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Businesses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredBusinesses.length,
          itemBuilder: (context, index) {
            final business = filteredBusinesses[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Địa chỉ: ${business.address}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Số điện thoại: ${business.phoneNumber}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Mô tả: ${business.description}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    if (business.images.isNotEmpty) ...[
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: business.images.length,
                          itemBuilder: (context, imageIndex) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Image.network(
                                business.images[imageIndex],
                                fit: BoxFit.cover,
                                width: 100, // Chiều rộng cố định cho hình ảnh
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
