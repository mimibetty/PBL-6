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
  RxBool isLoadingForTags = false.obs; // Trạng thái loading
  final String apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net'; // API URL gốc

  // Phương thức lấy danh sách tag và số lượng điểm đến từ hai API
  Future<void> fetchTags(int cityID) async {
    isLoadingForTags.value = true; // Set loading to true
    try {
      // Fetch full tag list
      final responseTags = await http.get(Uri.parse('$apiUrl/tag/'));
      final responseTagCounts = await http.get(Uri.parse('$apiUrl/tag/destination_num?city_id=$cityID'));

      if (responseTags.statusCode == 200 && responseTagCounts.statusCode == 200) {
        // Parse the responses
        List<dynamic> apiTags = json.decode(utf8.decode(responseTags.bodyBytes));
        List<dynamic> apiTagCounts = json.decode(utf8.decode(responseTagCounts.bodyBytes));

        // Create a map from the destination_num API
        Map<int, int> tagCountsMap = {
          for (var tag in apiTagCounts)
            tag['id']: tag['destination_count']
        };

        // Combine both API responses
        tags.value = apiTags.map((tag) {
          int id = tag['id'];
          return Tag(
            id: id,
            name: tag['name'],
            destinationCount: tagCountsMap[id] ?? 0, // Default to 0 if not found
          );
        }).toList();
      } else {
        print("Failed to load tags or counts: ${responseTags.statusCode}, ${responseTagCounts.statusCode}");
      }
    } catch (e) {
      print("Error fetching tags or counts: $e");
    } finally {
      isLoadingForTags.value = false; // Set loading to false
    }
  }

  // Phương thức lấy danh sách ThingsToDo theo tagId
  Future<void> fetchThingsToDoByTag(int tagId, int cityID) async {
    isLoading.value = true;

    try {
      // Gọi API để lấy danh sách theo tagId
      selectedTagId.value = tagId;
      final response = await http.get(Uri.parse('$apiUrl/destination/by_tags?tag_ids=$tagId&city_id=$cityID'));

      if (response.statusCode == 200) {
        List<dynamic> apiData = json.decode(utf8.decode(response.bodyBytes));
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

  // Phương thức lấy tất cả ThingsToDo
  Future<void> fetchAllThingsToDo(int cityID) async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$apiUrl/destination/?city_id=$cityID'));

      if (response.statusCode == 200) {
        List<dynamic> apiData = json.decode(utf8.decode(response.bodyBytes));
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
  void refreshThingsToDo(int cityID) {
    print("Refreshing things to do ");
    fetchAllThingsToDo(cityID);
  }

  @override
  void onInit() {
    super.onInit();
    //fetchTags(); // Lấy danh sách tag khi khởi tạo controller
    //fetchAllThingsToDo(); // Tải toàn bộ ThingsToDo mặc định khi khởi tạo
  }
}
