import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/home_screen/const.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/home_screen/controller/welcome_controller.dart';
import 'package:travelappflutter/presentation/home_screen/home_screen.dart';
import 'package:travelappflutter/presentation/home_screen/models/cities_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/topic_model.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/recomendate_city.dart';
import 'package:travelappflutter/presentation/home_screen/widgets/topic.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
//import './models/travel_model.dart'; // add this package first for icon

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _TravelWelcomeScreenState();
}

class _TravelWelcomeScreenState extends State<WelcomeScreen> {
  int selectedPage = 0;
  bool showCarousel = true; // Biến để theo dõi hiển thị CarouselSlider
  String currentCity = "Loading..."; // Biến để lưu trữ thành phố hiện tại
  bool showAllCities = false; // Mặc định chỉ hiển thị 6 thành phố

  List<Topic> topics = TopicModel.getTopics(); // Get topics list

  void toggleShowAllCities() {
    setState(() {
      showAllCities = !showAllCities;
    });
  }

  // Hàm lấy tọa độ GPS hiện tại
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra dịch vụ GPS đã bật chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('GPS chưa được bật.');
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Quyền truy cập vị trí bị từ chối.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Quyền truy cập vị trí bị từ chối vĩnh viễn.');
    }

    // Lấy vị trí hiện tại
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Hàm chuyển tọa độ thành địa chỉ
  Future<String> getCityFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        // Lấy thành phố từ Placemark
        return placemarks.first.locality ?? "Không rõ thành phố";
      } else {
        return "Không tìm thấy địa chỉ";
      }
    } catch (e) {
      return "Lỗi khi lấy địa chỉ: $e";
    }
  }

  // Hàm để lấy vị trí hiện tại và cập nhật thành phố
  Future<void> _updateCurrentLocation() async {
    try {
      Position position = await getCurrentLocation();
      String city = await getCityFromCoordinates(position);
      setState(() {
        currentCity = city;
      });
    } catch (e) {
      setState(() {
        currentCity = "Không thể lấy địa chỉ";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateCurrentLocation(); // Lấy vị trí hiện tại khi khởi tạo
  }

  void navigateToProfile() {
    Get.toNamed(AppRoutes.searchScreen);
  }

  @override
  Widget build(BuildContext context) {
    final WelcomeController welcomeController = Get.find<WelcomeController>();
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: headerParts(),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Awesome topic",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                // Text(
                //   "See all",
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: blueTextColor,
                //   ),
                // )
              ],
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              children: List.generate(
                topics.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    onTap: () {
                      // In ra console khi người dùng nhấn vào một topic
                      print("User clicked on topic: ${topics[index].name}");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(
                              cityID: 0,
                              cityName: '',
                              tag: topics[index].name,
                              show: false),
                        ),
                      );
                    },
                    child: TopicWidget(
                      topics[index], // Pass topic object to TopicWidget
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Popular Cities",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                // Text(
                //   "See all",
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: blueTextColor,
                //   ),
                // )
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Sử dụng Obx để quan sát myCities và cập nhật danh sách khi có thay đổi
          Obx(() {
            List<CityModel> popularCities = welcomeController.myCities.value
                .where((city) =>
                    city.name == "Hà Nội" ||
                    city.name == "TP Hồ Chí Minh" ||
                    city.name == "Đà Nẵng" ||
                    city.name == "Thừa Thiên Huế" ||
                    city.name == "Hải Phòng" ||
                    city.name == "Cần Thơ")
                .toList();

            // Nếu không show all, chỉ lấy tối đa 5 thành phố
            List<CityModel> displayedCities =
                showAllCities ? welcomeController.myCities.value : popularCities;

            return Column(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: List.generate(
                      displayedCities.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomeScreen(
                                  cityID: displayedCities[index].id,
                                  cityName: displayedCities[index].name,
                                  tag: null,
                                  show: true,
                                ),
                              ),
                            );
                          },
                          child: RecomendateCity(
                            myCities: displayedCities[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Nút "See All"
                GestureDetector(
                  onTap: toggleShowAllCities, // Gọi hàm toggle trạng thái
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      showAllCities
                          ? "See Less"
                          : "See All", // Đổi text tùy trạng thái
                      style: const TextStyle(
                        fontSize: 16,
                        color: blueTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  AppBar headerParts() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leadingWidth: 180,
      leading: Row(
        children: [
          const SizedBox(width: 15),
          const Icon(
            Iconsax.location,
            color: Colors.black,
          ),
          const SizedBox(width: 5),
          Text(
            'Đà Nẵng', // Hiển thị thành phố hiện tại
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
         
        ],
      ),
    );
  }
}
