import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_5.dart';

class PlanScreen4 extends StatefulWidget {
  @override
  _PlanScreen4State createState() => _PlanScreen4State();
}

class _PlanScreen4State extends State<PlanScreen4> {
  final PlanScreenController planScreenController = Get.find<PlanScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Who is coming with you?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose one:',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),

            GridView.count(
              shrinkWrap: true, // Điều chỉnh kích thước của GridView
              crossAxisCount: 2, // 2 cột
              crossAxisSpacing: 16, // Khoảng cách giữa các cột
              mainAxisSpacing: 16, // Khoảng cách giữa các hàng
              children: [
                _buildChoiceOption(Icons.person, 'Going Solo'),
                _buildChoiceOption(Icons.favorite, 'Partner'),
                _buildChoiceOption(Icons.group, 'Friends'),
                _buildChoiceOption(Icons.family_restroom, 'Family'),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget để xây dựng mỗi lựa chọn với biểu tượng và văn bản
  Widget _buildChoiceOption(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          planScreenController.setCompanionOption(label); // Cập nhật lựa chọn khi người dùng chọn
        });
        print('Selected: $label');
        
        // Điều hướng đến màn hình tiếp theo khi chọn một ô
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanScreen5(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // Màu nền cho ô
          borderRadius: BorderRadius.circular(15), // Bo tròn góc
          border: Border.all(color: Colors.blue, width: 2), // Viền màu xanh
        ),
        padding: EdgeInsets.all(20),
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn icon và text ở hai đầu
          children: [
            // Căn icon trái
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(icon, size: 50, color: Colors.blue),
            ),
            // Căn chữ giữa và nằm ở dưới
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                label,
                textAlign: TextAlign.center, // Căn giữa chữ
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}