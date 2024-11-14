import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_2.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import '../../navigation/custom_bottom_nav_bar.dart';

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
                bottom:
                    120), // Để trống khoảng dưới để tránh trùng với các nút cố định
            itemCount:
                4, // Giả sử có 10 ảnh, bạn có thể thay đổi số lượng này tùy ý
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcCTiMLa0YKxfi_tXVlrESpwTQA5yndoPY_Q&s', // Thay bằng URL ảnh của bạn
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Icon(Icons.lock, color: Colors.white),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child:
                              Icon(Icons.favorite_border, color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Image Name $index', // Thay bằng tên ảnh của bạn
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${index + 1} days', // Thay bằng số ngày tương ứng
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút "Create a Trip"
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Màu nền xanh cho nút trên
                      minimumSize: Size(double.infinity,
                          50), // Chiều rộng full và chiều cao 50
                    ),
                    child: Text(
                      '+ Create a Trip',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 8), // Khoảng cách giữa hai nút
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlanScreen2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white, // Màu nền trắng cho nút dưới
                      minimumSize: Size(double.infinity, 50),
                      side: BorderSide(
                          color: Colors.blue), // Viền màu xanh cho nút dưới
                    ),
                    child: Text(
                      'Build a Trip with AI',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        controller: HomeController(),
      ),
    );
  }
}
