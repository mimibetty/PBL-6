import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/business_creation_screen/business_post_screen.dart';
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/open_hours_widget.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/price_slide_widget.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/start_rating_widget.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/ticket_requirement_widget.dart';
import 'package:travelappflutter/presentation/common_views/avatar_image_picker_widget.dart';
import 'package:travelappflutter/presentation/common_views/image_picker_widget.dart';
import 'package:travelappflutter/presentation/common_views/selected_chip_widget.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';

class AccountInfoScreen extends StatefulWidget {
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  String? selectedBusinessType;
  final _formKey = GlobalKey<FormState>();
  List<File> selectedImages = []; // Danh sách hình ảnh đã chọn

  String name = '';
  String phoneNumber = '';
  String location = '';
  String website = '';
  String about = '';

  void _resetForm() {
    setState(() {
      name = '';
      phoneNumber = '';
      location = '';
      website = '';
      about = '';
      selectedImages=[];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Info Screen'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[100], // Màu nền xám nhạt
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AvatarPickerWidget(
                  selectedImages: selectedImages,
                  onImagesPicked: (images) {
                    setState(() {
                      selectedImages = images;
                    });
                  },
                ),
                SizedBox(height: 25.0),
                _buildTextInput('Name', (value) => name = value),
                SizedBox(height: 16.0),
                _buildTextInput(
                    'Contact Number', (value) => phoneNumber = value),
                SizedBox(height: 16.0),
                _buildDropdownCityType(),
                SizedBox(height: 27.0),
                _buildTextInput('Location', (value) => location = value),
                SizedBox(height: 16.0),
                _buildTextInput('About you', (value) => about = value),
                SizedBox(height: 32.0),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildElevatedButton('Reset', _resetForm),
                    SizedBox(width: 16), // Khoảng cách giữa hai nút
                    _buildElevatedButton('Create post', () {
                      if (_formKey.currentState!.validate()) {
                        // Xử lý lưu dữ liệu
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(controller: HomeController()),
    );
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // Nền đen
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white), // Chữ trắng
      ),
    );
  }

  Widget _buildDropdownCityType() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Choose your cities',
        filled: true,
        fillColor: Colors.white, // Màu nền trắng
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Bo góc
          borderSide: BorderSide(
            color: Colors.grey, // Màu viền
            width: 1.0,
          ),
        ),
      ),
      hint: Text('Select one'), // Văn bản hướng dẫn
      items: [
        DropdownMenuItem(value: 'hotel', child: Text('Hotels')),
        DropdownMenuItem(value: 'restaurant', child: Text('Restaurants')),
        DropdownMenuItem(value: 'thing_to_do', child: Text('Things to do')),
      ],
      onChanged: (value) {
        setState(() {
          selectedBusinessType = value;
        });
      },
      validator: (value) {
        if (value == null) return 'Vui lòng chọn loại doanh nghiệp';
        return null;
      },
      isExpanded: true, // Đảm bảo dropdown có chiều rộng tối đa
    );
  }

  Widget _buildTextInput(
    String label,
    Function(String) onChanged, {
    double height = 50.0, // Chiều cao tối thiểu của trường nhập liệu
    double width = double.infinity, // Chiều rộng mặc định
  }) {
    return Container(
      width: width, // Sử dụng chiều rộng tùy chỉnh
      margin: const EdgeInsets.only(
          bottom: 16.0), // Thêm khoảng cách dưới mỗi trường
      child: TextFormField(
        minLines: 1, // Số dòng tối thiểu
        maxLines: null, // Không giới hạn số dòng tối đa
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white, // Màu nền trắng
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Không bo góc
            borderSide: BorderSide(
              color: Colors.grey, // Màu viền
              width: 1.0,
            ),
          ),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập thông tin';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onChanged,
  }) {
    return DropdownButtonFormField<List<String>>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem<List<String>>(
          value: [item],
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        onChanged(value ?? []);
      },
    );
  }
}
