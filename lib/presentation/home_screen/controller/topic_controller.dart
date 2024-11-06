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
            apiUrl = 'https://example.com/api/topic1/destinations';
            break;
        case 'Shopping':
            apiUrl = 'https://example.com/api/topic2/destinations';
            break;
        case 'Must-see Attractions':
            apiUrl = 'https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net/destination/?sort_by_reviews=true&get_rating=true';
            break;
        default:
            apiUrl = 'https://example.com/api/default/destinations';
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
