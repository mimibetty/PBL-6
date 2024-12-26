import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/home_screen/models/tour_model.dart';
class TourOptionsScreen extends StatefulWidget {
  final Tour tour;
  const TourOptionsScreen({Key? key, required this.tour}) : super(key: key);

  @override
  _TourOptionsScreenState createState() => _TourOptionsScreenState();
}

class _TourOptionsScreenState extends State<TourOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Row(
            children: [
              const Icon(
                Icons.timer,
                color: Colors.black,
                size: 12, // Make the icon smaller
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.tour.duration}h',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.black),
                const SizedBox(width: 4),
                Text(
                  '${widget.tour.destinations.length}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.tour.destinations.length} Destination(s) in this Tour',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              children: widget.tour.destinations.map((destination) {
                return Column(
                  children: [
                    _buildOptionCard(
                      title: destination.name,
                      isPopular:
                          destination.rating >= 4.0 && destination.numOfReviews >= 3,
                      description: destination.description,
                      pricePerAdult: destination.priceBottom.toDouble(),
                      totalPrice: destination.priceTop.toDouble(),
                      times: _formatOpenTimes(destination.openTime),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required bool isPopular,
    required String description,
    required double pricePerAdult,
    required double totalPrice,
    required List<String> times,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: times.map((time) {
                return Chip(
                  label: Text(
                    time,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blueAccent,
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min: \$${pricePerAdult.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  'Max: \$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              '(Price includes taxes and booking fees)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

List<String> _formatOpenTimes(String openTime) {
  List<String> times = openTime.split(',');

  return times.map((time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    String period = hour < 12 ? 'AM' : 'PM';
    if (hour > 12) hour -= 12;
    return '$hour:${parts[1]} $period';
  }).toList();
}
