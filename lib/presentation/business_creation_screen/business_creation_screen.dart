import 'dart:io';
import 'package:flutter/material.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/business_creation_screen/business_post_screen.dart';
import 'package:travelappflutter/presentation/business_creation_screen/controller/business_creation_controller.dart';
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/open_hours_widget.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/price_slide_widget.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/start_rating_widget.dart';
import 'package:travelappflutter/presentation/business_creation_screen/widget/ticket_requirement_widget.dart';
import 'package:travelappflutter/presentation/common_views/image_picker_widget.dart';
import 'package:travelappflutter/presentation/common_views/selected_chip_widget.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';

import '../sign_in_screen/controller/auth_controller.dart';

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
  List<Map<String, dynamic>> cities = []; // List to store city data
  String? selectedCityName;
  Business businessA1 = getBusinessById("A1");

  String name = '';
  String phoneNumber = '';
  String district = '';
  String street = '';
  String ward = '';
  String cityId = '';
  String website = '';
  String openingHours = '';
  String closingHours = '';
  String hotelStyles = '';
  String hotelClass = '';
  List<String> selectedHotelFeatures = [];
  List<String> selectedRestaurantFeatures = [];
  String cuisine = '';
  String meal = '';
  String email = '';
  String priceRange = '0 - 1000'; // Giá trị mặc định
  String overview = '';
  String guide = '';
  bool ticketRequired = false;
  String age = '';
  String duration = '';
  String whatIncluded = '';
  String whatNotIncluded = '';
  String additionalInfo = '';
  String description = '';
  List<String> selectedCuisine = [];
  List<String> roomFeatures = [];
  List<String> roomTypes = [];
  String language = '';
  final int userId = Get.find<AuthController>().userId.value;

  void initState() {
    super.initState();
    _fetchCities(); // Fetch city data when the screen is loaded
  }

  Future<void> _fetchCities() async {
    // Assuming DestinationController().getCities() fetches the list of cities
    final fetchedCities = await DestinationController().getCities();

    setState(() {
      cities = fetchedCities; // Assuming it returns a list of cities
    });
  }

  List<String> errors = []; // List to hold error messages

  String? validateField(String fieldName, String value) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  void validateForm(BuildContext context) {
    bool isValid = true;

    // Clear previous errors
    errors.clear();

    // Check if all fields are valid
    final fields = {
      'Name': name,
      'Phone Number': phoneNumber,
      'District': district,
      'Street': street,
      'Ward': ward,
      'City ID': cityId,
      'Website': website,
      'Opening Hours': openingHours,
      'Closing Hours': closingHours,
      'Hotel Styles': hotelStyles,
      'Hotel Class': hotelClass,
      'Cuisine': cuisine,
      'Meal': meal,
      'Email': email,
      'Price Range': priceRange,
      'Overview': overview,
      'Guide': guide,
      'Age': age,
      'Duration': duration,
      'What is Included': whatIncluded,
      'What is Not Included': whatNotIncluded,
      'Additional Info': additionalInfo,
      'Description': description,
      'Language': language,
    };

    // Validate each field and add errors if any
    fields.forEach((field, value) {
      String? error = validateField(field, value);
      if (error != null) {
        isValid = false;
        errors.add(error);
      }
    });

    // Check if lists are empty
    if (selectedHotelFeatures.isEmpty) {
      isValid = false;
      errors.add('Hotel Features are required');
    }
    if (selectedRestaurantFeatures.isEmpty) {
      isValid = false;
      errors.add('Restaurant Features are required');
    }
    if (selectedCuisine.isEmpty) {
      isValid = false;
      errors.add('Cuisine is required');
    }
    if (roomFeatures.isEmpty) {
      isValid = false;
      errors.add('Room Features are required');
    }
    if (roomTypes.isEmpty) {
      isValid = false;
      errors.add('Room Types are required');
    }

    // If all fields are valid, show a success message
    if (isValid) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are valid')),
      );
    } else {
      // Show error messages
      String errorMessages = errors.join('\n');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please fill in the required fields:\n$errorMessages')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      selectedBusinessType = null;
      name = '';
      phoneNumber = '';
      website = '';
      openingHours = '';
      closingHours = '';
      hotelStyles = '';
      hotelClass = '';
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
      selectedCuisine.clear();
      roomFeatures.clear();
      roomTypes.clear();
      language = '';
    });
  }

  void _updatePriceRange(String range) {
    setState(() {
      priceRange = range; // Cập nhật khoảng giá
    });
  }

  void _createBusiness() async {
    if (_formKey.currentState!.validate()) {
      print("Business Information:");

      // Parse price range
      final priceRangeParts = priceRange.split('-');
      int priceBottom = 0;
      int priceTop = 0;

      if (priceRangeParts.length == 2) {
        priceBottom = int.tryParse(priceRangeParts[0].trim()) ?? 0;
        priceTop = int.tryParse(priceRangeParts[1].trim()) ?? 0;
      }

      // Call your createDestination function here with the priceBottom and priceTop
      int? destinationId = await DestinationController().createDestination(
        userId: userId,
        name: name,
        district: district,
        street: street,
        ward: ward,
        cityId: int.tryParse(cityId) ?? 0,
        priceBottom: priceBottom,
        priceTop: priceTop,
        dateCreate: DateTime.now(),
        age: int.tryParse(age) ?? 0,
        openTime: openingHours,
        duration: int.tryParse(duration) ?? 0,
        description: description,
        images: selectedImages,
      );
      print("Destination ID: $destinationId");
      if (destinationId != null) {
        print("Destination created with ID: $destinationId");
      } else {
        print("Failed to create destination.");
      }
    } else {
      print('Form is invalid. Please fill in all required fields.');
    }
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
                  builder: (context) =>
                      BusinessPostScreen(business: businessA1),
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
                _buildTextInput('District', (value) => district = value),
                SizedBox(height: 16.0),
                _buildTextInput('Street', (value) => street = value),
                SizedBox(height: 16.0),
                _buildTextInput('Ward', (value) => ward = value),
                SizedBox(height: 16.0),
                CityDropdownWidget(
                  cities: cities,
                  selectedCityName: selectedCityName,
                  onChanged: (value) {
                    setState(() {
                      selectedCityName = value;
                      cityId = cities
                          .firstWhere((city) => city['name'] == value)['id']
                          .toString();
                      print("City ID: $cityId");
                    });
                  },
                ),
                SizedBox(height: 16.0),
                SizedBox(height: 16.0),
                _buildTextInput('Website', (value) => website = value),
                SizedBox(height: 16.0),
                _buildTextInput('Email', (value) => email = value),
                SizedBox(height: 16.0),
                _buildTextInput('description', (value) => description = value),
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
                        selectedHotelFeatures = selectedLabels;
                      });
                    },
                    initialSelectedLabels: [],
                  ),
                  SizedBox(height: 30.0),
                  // Room Features and Room Types Fields
                  Text(
                    'Select Room Features',
                    style: TextStyle(
                      fontSize: 18, // Kích thước font chữ
                      fontWeight: FontWeight.bold, // Đặt văn bản in đậm
                    ),
                    textAlign: TextAlign.left, // Căn trái
                  ),
                  SelectableChipWidget(
                    labels: [
                      'King-sized Bed',
                      'Ocean View',
                      'Balcony',
                      'Air Conditioning',
                      'Free Wi-Fi',
                      'Private Bathroom',
                      'Mini Bar',
                      'Shower',
                      'Bathtub',
                    ],
                    onSelectionChanged: (selectedLabels) {
                      setState(() {
                        roomFeatures =
                            selectedLabels; // Update the selected room features
                      });
                    },
                    initialSelectedLabels: [], // Initially no features are selected
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'Select Room Types',
                    style: TextStyle(
                      fontSize: 18, // Kích thước font chữ
                      fontWeight: FontWeight.bold, // Đặt văn bản in đậm
                    ),
                    textAlign: TextAlign.left, // Căn trái
                  ),
                  SelectableChipWidget(
                    labels: [
                      'Single Room',
                      'Double Room',
                      'Suite',
                      'Penthouse',
                      'Family Room',
                      'Deluxe Room',
                      'Studio',
                    ],
                    onSelectionChanged: (selectedLabels) {
                      setState(() {
                        roomTypes =
                            selectedLabels; // Update the selected room types
                      });
                    },
                    initialSelectedLabels: [], // Initially no room types are selected
                  ),
                  SizedBox(height: 30.0),
                  _buildDropdownLanguage(),
                  SizedBox(height: 30.0),

                  _buildTextInput(
                      'Hotel Styles', (value) => hotelStyles = value),
                  StarRatingWidget(
                    onRatingUpdate: (rating) {
                      setState(() {
                        hotelClass =
                            rating.toString(); // Cập nhật giá trị đánh giá
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PriceRangeSlider(onPriceRangeChanged: _updatePriceRange),
                  SizedBox(
                    height: 10,
                  ),
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
                  StarRatingWidget(
                    onRatingUpdate: (rating) {
                      setState(() {
                        hotelClass =
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
                        _createBusiness(); // Call _createBusiness when "Create Post" button is pressed
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

  Widget _buildDropdownLanguage() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Language',
        filled: true,
        fillColor: Colors.white, // White background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
          borderSide: BorderSide(
            color: Colors.grey, // Border color
            width: 1.0,
          ),
        ),
      ),
      hint: Text('Select language'), // Placeholder text
      items: [
        DropdownMenuItem(value: 'Korean', child: Text('Korean')),
        DropdownMenuItem(value: 'Japanese', child: Text('Japanese')),
        DropdownMenuItem(value: 'English', child: Text('English')),
        DropdownMenuItem(value: 'Vietnamese', child: Text('Vietnamese')),
        DropdownMenuItem(value: 'Thai', child: Text('Thai')),
        DropdownMenuItem(value: 'Chinese', child: Text('Chinese')),
        DropdownMenuItem(value: 'French', child: Text('French')),
      ],
      onChanged: (value) {
        setState(() {
          language = value!;
        });
      },
      validator: (value) {
        if (value == null) return 'Please select a language';
        return null;
      },
      isExpanded: true, // Ensure the dropdown takes the full width
    );
  }
}

class CityDropdownWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cities; // List of cities to display
  final String? selectedCityName; // The currently selected city name
  final Function(String?)
      onChanged; // Callback to handle changes to the selected city

  CityDropdownWidget({
    required this.cities,
    required this.selectedCityName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return cities.isEmpty
        ? CircularProgressIndicator() // Show a loader while cities are being fetched
        : DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Select City',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            value: selectedCityName,
            items: cities.map((city) {
              return DropdownMenuItem<String>(
                value: city['name'],
                child: Text(city['name']),
              );
            }).toList(),
            onChanged: onChanged,
            hint: Text('Select City'),
          );
  }
}
