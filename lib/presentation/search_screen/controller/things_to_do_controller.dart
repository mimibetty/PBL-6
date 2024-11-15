import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'dart:convert';
import 'package:travelappflutter/presentation/search_screen/models/things_to_do_model.dart';

class ThingsToDoController extends GetxController {
  RxList<Tag> tags = <Tag>[].obs; // Danh sách các tag
  RxList<TravelDestination> thingsToDoList = <TravelDestination>[].obs; // Danh sách ThingsToDo theo tag
  RxBool isLoading = false.obs; // Trạng thái loading
  RxInt selectedTagId = 0.obs; // ID của tag được chọn (0 nghĩa là không chọn tag nào)

  final String apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net'; // API URL gốc

  // Phương thức lấy tất cả các tag từ API
  Future<void> fetchTags() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/tag/'));
      if (response.statusCode == 200) {
        List<dynamic> apiTags = json.decode(response.body);
        tags.value = apiTags.map((tag) => Tag.fromJson(tag)).toList();
      } else {
        print("Failed to load tags: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching tags: $e");
    }
  }

  // Phương thức lấy danh sách ThingsToDo theo tagId
  Future<void> fetchThingsToDoByTag(int tagId) async {
    isLoading.value = true;
    selectedTagId.value = tagId;
    try {
      final response = await http.get(Uri.parse('$apiUrl/destination/by_tags?tag_ids=$tagId'));
      if (response.statusCode == 200) {
        List<dynamic> apiData = json.decode(response.body);
        thingsToDoList.value = apiData.map((data) => TravelDestination.fromJson(data)).toList();
      } else {
        print("Failed to load things to do by tag: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching things to do by tag: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Phương thức để lấy tất cả các ThingsToDo khi không lọc theo tag
  Future<void> fetchAllThingsToDo() async {
    isLoading.value = true;
    selectedTagId.value = 0; // Đặt lại selectedTagId về 0 khi tải toàn bộ
    try {
      final response = await http.get(Uri.parse('$apiUrl/destination/?is_popular=true&get_rating=true'));
      if (response.statusCode == 200) {
        List<dynamic> apiData = json.decode(response.body);
        thingsToDoList.value = apiData.map((data) => TravelDestination.fromJson(data)).toList();
      } else {
        print("Failed to load all things to do: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching all things to do: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Phương thức để làm mới danh sách ThingsToDo dựa trên tag đã chọn
  void refreshThingsToDo() {
    if (selectedTagId.value == 0) {
      fetchAllThingsToDo();
    } else {
      fetchThingsToDoByTag(selectedTagId.value);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTags(); // Lấy danh sách tag khi khởi tạo controller
    fetchAllThingsToDo(); // Tải toàn bộ ThingsToDo mặc định khi khởi tạo
  }
}
