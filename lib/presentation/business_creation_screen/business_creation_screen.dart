import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/business_creation_screen/business_post_screen.dart';
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/open_hours_widget.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/price_slide_widget.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/start_rating_widget.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/ticket_requirement_widget.dart';
import 'package:travelappflutter/presentation/common_views/image_picker_widget.dart';
import 'package:travelappflutter/presentation/common_views/selected_chip_widget.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';

class CreateBusinessPostScreen extends StatefulWidget {
  @override
  _CreateBusinessPostScreenState createState() =>
      _CreateBusinessPostScreenState();
}
Business getBusinessById(String id) {
  return mockBusinessDatabase.firstWhere(
    (business) => business.id == id,
   
  );
}
class _CreateBusinessPostScreenState extends State<CreateBusinessPostScreen> {
  String? selectedBusinessType;
  final _formKey = GlobalKey<FormState>();

  final List<String> hotelFeatures = ["WiFi", "Bể bơi", "Gym"];
  final List<String> restaurantFeatures = ["Ăn nhanh", "Giao hàng", "Đặt bàn"];
  final List<String> cuisines = ["Việt Nam", "Trung Quốc", "Nhật Bản"];
  List<File> selectedImages = []; // Danh sách hình ảnh đã chọn
  
  Business businessA1 = getBusinessById("A1");

  String name = '';
  String phoneNumber = '';
  String location = '';
  String website = '';
  String openingHours = '';
  String closingHours = '';
  String description = '';
  String starRating = '';
  List<String> selectedHotelFeatures = [];
  List<String> selectedRestaurantFeatures = [];
  String cuisine = '';
  String meal = '';
  String priceRange = '';
  String overview = '';
  String guide = '';
  bool ticketRequired = false;
  String age = '';
  String duration = '';
  String whatIncluded = '';
  String whatNotIncluded = '';
  String additionalInfo = '';
  List<String> selectedCuisine = [];

  void _updatePriceRange(String range) {
    setState(() {
      priceRange = range; // Cập nhật khoảng giá
    });
  }

  void _resetForm() {
    setState(() {
      selectedBusinessType = null;
      name = '';
      phoneNumber = '';
      location = '';
      website = '';
      openingHours = '';
      closingHours = '';
      description = '';
      starRating = '';
      selectedHotelFeatures.clear();
      selectedRestaurantFeatures.clear();
      cuisine = '';
      meal = '';
      priceRange = '';
      overview = '';
      guide = '';
      ticketRequired = false;
      age = '';
      duration = '';
      whatIncluded = '';
      whatNotIncluded = '';
      additionalInfo = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Creation Screen'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              // Replace this with the actual Business object

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BusinessPostScreen(business: businessA1),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100], // Màu nền xám nhạt
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildDropdownBusinessType(),
                SizedBox(height: 25.0),
                _buildTextInput('Name', (value) => name = value),
                SizedBox(height: 16.0),
                _buildTextInput(
                    'Contact Number', (value) => phoneNumber = value),
                SizedBox(height: 16.0),
                _buildTextInput('Location', (value) => location = value),
                SizedBox(height: 16.0),
                _buildTextInput('Website', (value) => website = value),
                SizedBox(height: 16.0),
                OpeningHoursInput(
                  onOpeningTimeChanged: (time) {
                    setState(() {
                      openingHours = time; // Cập nhật giờ mở cửa
                    });
                  },
                  onClosingTimeChanged: (time) {
                    setState(() {
                      closingHours = time; // Cập nhật giờ đóng cửa
                    });
                  },
                ),
                SizedBox(height: 32.0),
                
                if (selectedBusinessType == 'hotel') ...[
                  Container(
                    alignment:
                        Alignment.centerLeft, // Căn toàn bộ container sang trái
                    child: Text(
                      'Select Hotel Features',
                      style: TextStyle(
                        fontSize: 18, // Kích thước font chữ
                        fontWeight: FontWeight.bold, // Đặt văn bản in đậm
                      ),
                      textAlign: TextAlign.left, // Căn trái
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SelectableChipWidget(
                    labels: [
                      'Sea View',
                      'Free Wi-Fi',
                      'Breakfast Included',
                      'Rooftop Bar',
                      'Infinity Pool',
                      'Private Beach',
                      'Luxury Amenities',
                    ],
                    onSelectionChanged: (selectedLabels) {
                      setState(() {
                        selectedRestaurantFeatures = selectedLabels;
                      });
                    }, 
                    initialSelectedLabels: [],
                  ),
                  SizedBox(height: 30.0),
                  _buildTextInput(
                      'Description', (value) => description = value),
                  StarRatingWidget(
                    onRatingUpdate: (rating) {
                      setState(() {
                        starRating =
                            rating.toString(); // Cập nhật giá trị đánh giá
                      });
                    },
                  ),
                  SizedBox(height: 10,)
                ] else if (selectedBusinessType == 'restaurant') ...[
                  Container(
                    alignment:
                        Alignment.centerLeft, // Căn toàn bộ container sang trái
                    child: Text(
                      'Select Cuisines',
                      style: TextStyle(
                        fontSize: 18, // Kích thước font chữ
                        fontWeight: FontWeight.bold, // Đặt văn bản in đậm
                      ),
                      textAlign: TextAlign.left, // Căn trái
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SelectableChipWidget(
                    labels: [
                      'Chinese',
                      'Vietnamese',
                      'French',
                      'Korean',
                    ],
                    onSelectionChanged: (selectedLabels) {
                      setState(() {
                        selectedCuisine = selectedLabels;
                      });
                    }, 
                    initialSelectedLabels: [],
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    alignment:
                        Alignment.centerLeft, // Căn toàn bộ container sang trái
                    child: Text(
                      'Select Restaurant Features',
                      style: TextStyle(
                        fontSize: 18, // Kích thước font chữ
                        fontWeight: FontWeight.bold, // Đặt văn bản in đậm
                      ),
                      textAlign: TextAlign.left, // Căn trái
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SelectableChipWidget(
                    labels: [
                      "Vegetarian Options",
                      "Outdoor Seating",
                      "Fine Dining",
                      "Luxury",
                      "Sea View",
                      "Fresh Seafood",
                      "Family Friendly",
                      "Traditional Cuisine",
                      "Rooftop Bar",
                      "Live Music",
                    ],
                    onSelectionChanged: (selectedLabels) {
                      setState(() {
                        selectedRestaurantFeatures = selectedLabels;
                      });
                    }, 
                    initialSelectedLabels: [],
                  ),
                  SizedBox(height: 16.0),
                  _buildTextInput('Special Diets', (value) => meal = value),
                  SizedBox(height: 16.0),

                  PriceRangeSlider(onPriceRangeChanged: _updatePriceRange),
                  StarRatingWidget(
                    onRatingUpdate: (rating) {
                      setState(() {
                        starRating =
                            rating.toString(); // Cập nhật giá trị đánh giá
                      });
                    },
                  ),
                ] else if (selectedBusinessType == 'thing_to_do') ...[
                  _buildTextInput('Overview', (value) => overview = value),
                  SizedBox(height: 16.0),
                  _buildTextInput('Live guide', (value) => guide = value),
                  SizedBox(height: 16.0),
                  TicketRequirementWidget(
                    ticketRequired: ticketRequired,
                    onChanged: (value) {
                      setState(() {
                        ticketRequired = value; // Cập nhật giá trị
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildTextInput('Ages', (value) => age = value),
                  SizedBox(height: 16.0),
                  _buildTextInput(
                      'Duration (Hour)', (value) => duration = value),
                  SizedBox(height: 16.0),
                  _buildTextInput(
                      'What is included', (value) => whatIncluded = value),
                  SizedBox(height: 16.0),
                  _buildTextInput('What is not included',
                      (value) => whatNotIncluded = value),
                  SizedBox(height: 16.0),
                  _buildTextInput('Additional Information',
                      (value) => additionalInfo = value),
                ],
                ImagePickerWidget(
                  selectedImages: selectedImages,
                  onImagesPicked: (images) {
                    setState(() {
                      selectedImages = images;
                    });
                  },
                  action: "create",
                ),
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
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Nền đen
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white), // Chữ trắng
      ),
    );
  }

  Widget _buildDropdownBusinessType() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Business Type',
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
