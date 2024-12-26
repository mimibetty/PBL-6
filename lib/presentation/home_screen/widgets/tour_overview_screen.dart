import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/models/tour_model.dart';

class TourOverviewWidget extends StatelessWidget {
  final Tour tour;

  const TourOverviewWidget({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About Section
            _buildAboutSection(tour),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),
            // Additional sections can be added here
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(Tour tour) {
    final List<Map<String, dynamic>> aboutDetails = [
      {
        'icon': Icons.child_care,
        'label': "Ages",
        'value': getMinAge(tour).toString(),
      },
      {
        'icon': Icons.schedule,
        'label': "Duration",
        'value': "${tour.duration.toString()} hours",
      },
      {
        'icon': Icons.access_time,
        'label': "Start Time",
        'value': getMinOpenTime(tour),
      },
      {
        'icon': Icons.mobile_friendly,
        'label': "Mobile Ticket",
        'value': "Available",
      },
      {
        'icon': Icons.language,
        'label': "Live Guide",
        'value': "English",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "About this Tour",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 10),
        ...aboutDetails.map((detail) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  detail['icon'],
                  color: Colors.blueAccent,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "${detail['label']}: ",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: detail['value'],
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
