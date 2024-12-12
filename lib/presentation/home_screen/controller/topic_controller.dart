import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:travelappflutter/presentation/home_screen/models/travel_model.dart';

class TopicController {
  var destinations = <TravelDestination>[].obs;

  // Hàm này sẽ gọi API dựa trên `Topic` được truyền vào
Future<void> fetchDestinationsByTopic(String topic) async {
    String apiUrl;
    // Determine API URL based on topic
    switch (topic) {
        case 'Culture':
            apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/by_tags?tag_ids=2';
            break;
        case 'Shopping':
            apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/by_tags?tag_ids=9';
            break;
        case 'Must-see Attractions':
            apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/by_tags?tag_ids=5';
            break;
        case 'Great Food':
            apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/by_tags?tag_ids=1';          
            break;
        default:
            apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/by_tags?tag_ids=11';
    }

    try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
            List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
            if (data.isEmpty) {
                throw Exception('No destinations found for the topic: $topic');
            }

            destinations.value = data.map((item) => TravelDestination.fromJson(item)).toList();
        } else {
            throw Exception('Failed to load destinations: ${response.statusCode}');
        }
    } catch (error) {
        print('Error fetching destinations: $error');
    }
}

}
