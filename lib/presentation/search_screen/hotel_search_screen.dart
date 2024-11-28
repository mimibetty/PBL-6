import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/home_screen/hotel_detail.dart';
import 'package:travelappflutter/presentation/search_screen/controller/hotel_search_controller.dart';
import 'package:travelappflutter/presentation/search_screen/models/hotel_model.dart';

class HotelSearchScreen extends StatefulWidget {
  final List<int> hotelIDs;
  final String cityNames;
  final int cityID;

  const HotelSearchScreen({
    Key? key,
    required this.hotelIDs,
    required this.cityNames,
    required this.cityID,
  }) : super(key: key);

  @override
  _HotelSearchScreenState createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends State<HotelSearchScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late List<Hotel> filteredHotels = []; // Changed to late initialization
  late final HotelController hotelController;
  String selectedSortOption = "Rating";
  @override
  void initState() {
    super.initState();
    hotelController = Get.put(HotelController());
    for (int hotelID in widget.hotelIDs) {
      hotelController.fetchHotelData(hotelID.toString());
    }
  void _filterHotels() {
    filteredHotels = hotelController.hotels
        .where((hotel) => hotel.rating > 0.0 && hotel.reviewCount > 0)
        .toList();
    if (mounted) { // Kiểm tra xem widget có còn trong cây không
      setState(() {}); // Cập nhật giao diện khi hoàn tất lọc
    }
  }

    // Đảm bảo gọi _filterHotels() sau khi hàm đã được định nghĩa
    ever(hotelController.hotels, (_) {
      _filterHotels();
    });
  }
  @override
  void dispose() {
    Get.delete<HotelController>(); // Hủy lắng nghe controller khi widget bị hủy
    print('disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels'),
        leading: BackButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterMenu(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top Hotels in ${widget.cityNames}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${filteredHotels.length}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " result match your filter", 
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort by: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedSortOption, // Gắn giá trị biến trạng thái
                    items: <String>[
                      'Rating',
                      'Name',
                      'Review Count',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedSortOption = newValue; // Cập nhật giá trị được chọn
                        });
                        _sortHotels(newValue); // Gọi hàm sort
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHotels.length,
              itemBuilder: (context, index) {
                final hotel = filteredHotels[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HotelDetailScreen(hotel: hotel),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(hotel.images[0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel.hotelName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Address: ${hotel.hotelLocation}",
                                    style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      for (int i = 1; i <= 5; i++)
                                        Icon(
                                          Icons.circle,
                                          size: 12,
                                          color: i <= hotel.rating.floor()
                                              ? Color(0xFF13357B)
                                              : (i ==
                                                          hotel.rating.floor() + 1 &&
                                                      hotel.rating - hotel.rating.floor() >= 0.5)
                                                  ? Color(0xFF13357B).withOpacity(0.5)
                                                  : Colors.grey,
                                        ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${hotel.rating.toStringAsFixed(1)} ★", // Làm tròn đến 1 chữ số
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          "(${hotel.reviewCount} reviews)",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Divider(thickness: 1, color: Colors.black26),
                                  const SizedBox(height: 5),
                                  Wrap(
                                    spacing: 4,
                                    children: hotel.roomFeatures
                                        .map((feature) => Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Text(
                                                feature,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black87),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                FormBuilderDateRangePicker(
                  name: 'date_range',
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  decoration: InputDecoration(
                    labelText: 'Select Check-in & Check-out Dates',
                  ),
                ),
                const SizedBox(height: 16),
                _buildCheckboxGroup('Price Range', 'price', [
                  'Low',
                  'Medium',
                  'High',
                ]),
                _buildCheckboxGroup('Amenities', 'amenities', [
                  'Free Wifi',
                  'Breakfast Included',
                  'Parking',
                  'Pool',
                ]),
                const SizedBox(height: 16),
                
                const SizedBox(height: 16),
                _buildCheckboxGroup('Hotel Star', 'hotel_star', [
                  '1 Star',
                  '2 Star',
                  '3 Star',
                  '4 Star',
                  '5 Star',
                ]),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      var selectedFilters = _formKey.currentState!.value;
                      _applyFilters(selectedFilters); // Gọi hàm áp dụng bộ lọc
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Apply Filters'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  Widget _buildCheckboxGroup(String title, String name, List<String> options) {
    return FormBuilderCheckboxGroup(
      decoration: InputDecoration(labelText: title),
      name: name,
      options: options
          .map((option) => FormBuilderFieldOption(value: option))
          .toList(),
    );
  }

void _applyFilters(Map<String, dynamic> filters) {
  // Thu thập các giá trị đã chọn từ filters
  List<String> selectedFilters = [];

  // Gộp các giá trị từ từng nhóm checkbox
  if (filters['price'] != null) {
    selectedFilters.addAll((filters['price'] as List<dynamic>).map((e) => 'Price: $e').toList());
  }
  if (filters['amenities'] != null) {
    selectedFilters.addAll((filters['amenities'] as List<dynamic>).map((e) => 'Amenity: $e').toList());
  }
  if (filters['hotel_star'] != null) {
    selectedFilters.addAll((filters['hotel_star'] as List<dynamic>).map((e) => 'Star: $e').toList());
  }

  // Chuyển đổi danh sách thành một chuỗi
  String filterString = selectedFilters.join(', ');
  // Gửi chuỗi đến Controller
 hotelController.filterHotels(filterString, widget.cityID);
  // Cập nhật giao diện
  setState(() {});
}


  void _sortHotels(String? newValue) {
    if (newValue == null) return;

    // Gọi trực tiếp sortHotels từ controller
    hotelController.sortHotels(newValue, ascending: false);

    // Cập nhật danh sách filteredHotels sau khi sắp xếp
    filteredHotels = hotelController.hotels.toList();
    // Làm mới giao diện
    if (mounted) {
      setState(() {});
    }
  }
}
