import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/business_creation_screen/controller/business_info_controller.dart';
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/open_hours_widget.dart';
import 'package:travelappflutter/presentation/common_views/selected_chip_widget.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';


class EditBusinessPostScreen extends StatefulWidget {
  @override
  _EditBusinessPostScreenState createState() => _EditBusinessPostScreenState();
}

class _EditBusinessPostScreenState extends State<EditBusinessPostScreen> {
  
  final BusinessInfoController businessController = Get.put(BusinessInfoController());
  late Business thisBusiness;

  String? selectedBusinessType;
  final _formKey = GlobalKey<FormState>();

  final List<String> hotelFeatures = ["WiFi", "Bể bơi", "Gym"];
  final List<String> restaurantFeatures = ["Ăn nhanh", "Giao hàng", "Đặt bàn"];
  final List<String> cuisines = ["Việt Nam", "Trung Quốc", "Nhật Bản"];
  List<File> selectedImages = [];
  
  Business? businessA1;

  String name = '';
  String phoneNumber = '';
  String location = '';
  String email = '';
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

  @override
  void initState() {
    super.initState();
    thisBusiness = businessController.business.value;
  }
  void _resetForm() {
    setState(() {
      selectedBusinessType = null;
      name = '';
      phoneNumber = '';
      location = '';
      email = '';
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
    // Show a loading indicator while business data is being fetched
    if (businessA1 == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Edit Business")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Business'),
        backgroundColor: Colors.white,
        
      ),
      body: Container(
        color: Colors.grey[100],
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
                _buildTextInput('Contact Number', (value) => phoneNumber = value),
                SizedBox(height: 16.0),
                _buildTextInput('Location', (value) => location = value),
                SizedBox(height: 16.0),
                _buildTextInput('Email', (value) => email = value),
                SizedBox(height: 16.0),
                OpeningHoursInput(
                  onOpeningTimeChanged: (time) {
                    setState(() {
                      openingHours = time;
                    });
                  },
                  onClosingTimeChanged: (time) {
                    setState(() {
                      closingHours = time;
                    });
                  },
                ),
                SizedBox(height: 32.0),
                if (selectedBusinessType == 'hotel') ...[
                  // Hotel specific fields
                  SelectableChipWidget(
                    labels: ['Sea View', 'Free Wi-Fi', 'Breakfast Included'],
                    initialSelectedLabels: selectedHotelFeatures,
                    onSelectionChanged: (selectedLabels) {
                      setState(() {
                        selectedHotelFeatures = selectedLabels;
                      });
                    },
                  ),
                ] else if (selectedBusinessType == 'restaurant') ...[
                  // Restaurant specific fields
                  SelectableChipWidget(
                    labels: ['Chinese', 'Vietnamese', 'French'],
                    initialSelectedLabels: selectedCuisine,
                    onSelectionChanged: (selectedLabels) {
                      setState(() {
                        selectedCuisine = selectedLabels;
                      });
                    },
                  ),
                ],
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildElevatedButton('Reset', _resetForm),
                    SizedBox(width: 16),
                    _buildElevatedButton('Save Changes', () {
                      if (_formKey.currentState!.validate()) {
                        // Save the updated business data
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
        backgroundColor: Colors.blue,
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDropdownBusinessType() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Business Type',
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
      hint: Text('Select one'),
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
        if (value == null) return 'Please select a business type';
        return null;
      },
      isExpanded: true,
    );
  }

  Widget _buildTextInput(String label, Function(String) onChanged) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please fill out this field';
          }
          return null;
        },
      ),
    );
  }
}
