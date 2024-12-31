import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:travelappflutter/presentation/business_creation_screen/models/business_model.dart';
import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';

class BusinessController extends GetxController {
  final RxInt selectedPage = 0.obs;
  final RxBool isLoading = false.obs;
  final Rxn<BusinessMetrics> businessMetrics = Rxn<BusinessMetrics>();
  final RxInt totalReview = 0.obs;
  final RxList<int> top5Ids = <int>[].obs;
  final RxList<TravelDestination> topDestinations = <TravelDestination>[].obs;

  // Biến để lưu thông tin điểm đến cuối cùng
  final RxString name = ''.obs;
  final RxString address = ''.obs;
  final RxDouble averageRating = 0.0.obs;

  final String baseUrl =
      'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net';

  @override
  void onInit() {
    super.onInit();
    selectedPage.value = Get.arguments?['selectedPage'] ?? 0;
    fetchTotalReviews();
    fetchTop5Ids().then((_) {
      fetchTopDestinationDetails();
    });
    fetchBusinessMetrics();
  }

  Future<void> fetchTotalReviews() async {
    final int userId = Get.find<AuthController>().userId.value;

    try {
      final Uri url = Uri.parse('$baseUrl/destination/?user_id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));

        // Tính tổng số đánh giá từ tất cả các điểm đến
        totalReview.value = jsonResponse.fold<int>(
            0, (sum, item) => sum + ((item['review_count'] ?? 0) as int));
        print("Total Reviews: ${totalReview.value}");
      } else {
        print("HTTP Error: ${response.statusCode} - ${response.body}");
        Get.snackbar(
            'Error', 'Failed to fetch total reviews: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  Future<void> fetchTop5Ids() async {
    final int userId = Get.find<AuthController>().userId.value;

    try {
      final Uri url = Uri.parse('$baseUrl/destination/?user_id=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));

        // Sắp xếp theo average_rating và lấy top 5
        List<Map<String, dynamic>> allDestinations =
            jsonResponse.cast<Map<String, dynamic>>();

        allDestinations.sort((a, b) =>
            (b['average_rating'] ?? 0).compareTo(a['average_rating'] ?? 0));
        final top5 = allDestinations.take(5).toList();

        // Lấy danh sách 5 ID
        top5Ids.value = top5.map<int>((item) => item['id'] as int).toList();
        print("Top 5 IDs: $top5Ids");
      } else {
        print("HTTP Error: ${response.statusCode} - ${response.body}");
        Get.snackbar(
            'Error', 'Failed to fetch top 5 IDs: ${response.statusCode}');
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  final RxList<SimpleDestination> simpleDestinations =
      <SimpleDestination>[].obs;

  

 
Future<List<List<double>>> fetchChartData(int destinationId) async {
  try {
    final Uri url = Uri.parse(
        '$baseUrl/dashboard/business/stacked_review?destination_id=$destinationId&year=2024');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));

      // Initialize a list for 5 ratings, each containing 12 months
      final List<List<double>> stackedChartData = List.generate(5, (_) => List.filled(12, 0.0));

      // Iterate over the JSON response and populate the stackedChartData
      jsonResponse.forEach((rating, monthlyData) {
        final ratingIndex = int.parse(rating) - 1; // Convert "1", "2", etc., to 0-based index
        if (ratingIndex >= 0 && ratingIndex < 5) {
          for (int month = 0; month < 12; month++) {
            stackedChartData[ratingIndex][month] = monthlyData[month]?.toDouble() ?? 0.0;
          }
        }
      });

      // print("Chart data for destination $destinationId: $stackedChartData");
      return stackedChartData;
    } else {
      print(
          "Error fetching chart data for destination $destinationId: ${response.statusCode}");
      return List.generate(5, (_) => List.filled(12, 0.0)); // Return empty data for fallback
    }
  } catch (e) {
    print("Exception fetching chart data for destination $destinationId: $e");
    return List.generate(5, (_) => List.filled(12, 0.0)); // Return empty data for fallback
  }
}

Future<void> fetchTopDestinationDetails() async {
  try {
    final List<SimpleDestination> fetchedDestinations = [];
    for (final id in top5Ids) {
      final Uri url = Uri.parse('$baseUrl/destination/$id');
      print("Fetching details for ID: $id");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        final addressData = jsonResponse['address'] ?? {};
        final cityId = addressData['city_id'] ?? 0;

        // Fetch cityName from cityId
        final cityName = await fetchCityName(cityId);

        // Prepare address
        final addressParts = [
          (addressData['street'] ?? '').replaceAll(RegExp(r',\s*$'), ''), // Remove trailing commas
          (addressData['ward'] ?? '').replaceAll(RegExp(r',\s*$'), ''),
          (addressData['district'] ?? '').replaceAll(RegExp(r',\s*$'), ''),
          cityName
        ];
        final address = addressParts.where((part) => part.isNotEmpty).join(', ');

        // Fetch chart data for the destination
        final chartData = await fetchChartData(id);

        // Get the first image URL (if available)
        final imageUrl = (jsonResponse['images'] != null && jsonResponse['images'].isNotEmpty)
            ? jsonResponse['images'][0]['url'] // Fetch the first image URL
            : ''; // Default to empty if no images are available

        // Create SimpleDestination object
        final destination = SimpleDestination(
          name: jsonResponse['name'] ?? 'Unknown Name',
          address: address,
          averageRating: (jsonResponse['average_rating'] ?? 0).toDouble(),
          id: jsonResponse['id'] ?? 0,
          cityId: cityId,
          chartData: chartData, // Pass stacked chart data
          imageUrl: imageUrl, // Add image URL to the destination object
        );

        fetchedDestinations.add(destination);

        // Debug logs
        // print("Name: ${destination.name}");
        // print("Address: ${destination.address}");
        // print("Average Rating: ${destination.averageRating}");
        // print("Chart Data: ${destination.chartData}");
        // print("Image URL: ${destination.imageUrl}"); // Log the image URL
      } else if (response.statusCode == 404) {
        print("ID $id not found. Skipping...");
      } else {
        print("Error fetching ID $id: ${response.statusCode}");
      }
    }

    // Assign destinations to the observable list
    simpleDestinations.value = fetchedDestinations;
    print("Simple Destinations Count: ${simpleDestinations.length}");
  } catch (e) {
    print("Exception: $e");
  }
}



Future<String> fetchCityName(int cityId) async {
  try {
    if (cityId == 0) return 'Unknown City';

    final Uri url = Uri.parse('$baseUrl/city/$cityId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse['name'] ?? 'Unknown City';
    } else {
      print("Error fetching cityName for cityId $cityId: ${response.statusCode}");
      return 'Unknown City';
    }
  } catch (e) {
    print("Exception fetching cityName for cityId $cityId: $e");
    return 'Unknown City';
  }
}


  Future<void> fetchBusinessMetrics() async {
    final int userId = Get.find<AuthController>().userId.value;

    try {
      final Uri url = Uri.parse('$baseUrl/dashboard/business/metrics/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        businessMetrics.value = BusinessMetrics.fromJson(data);
      } else {
        Get.snackbar(
            'Error', 'Failed to load business metrics: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
