import 'package:flutter/material.dart';

class TourOptionsScreen extends StatefulWidget {
  const TourOptionsScreen({Key? key}) : super(key: key);

  @override
  _TourOptionsScreenState createState() => _TourOptionsScreenState();
}

class _TourOptionsScreenState extends State<TourOptionsScreen> {
  String? selectedOption; // Variable to store the selected radio button value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
        title: const Text(
          'Wednesday, November 27, 2024',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today_outlined,
                    color: Colors.black),
              ),
              const Text(
                '2',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap everything in SingleChildScrollView for scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '8 options available for 11/27',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                _buildOptionCard(
                  title: 'JEEP & CAR tour - No meal',
                  isPopular: true,
                  description:
                      'PRIVATE JEEP & CAR TOUR: Only your group participates - Travel at flexible pace.',
                  pricePerAdult: 120.0,
                  totalPrice: 240.0,
                  times: ['7:30 AM', '8:00 AM', '8:30 AM'],
                  value: 'JEEP & CAR tour - No meal',
                ),
                const SizedBox(height: 16),
                _buildOptionCard(
                  title: 'CAR tour + With meal',
                  isPopular: false,
                  description:
                      'PRIVATE CAR / VAN TOUR: Only your group participates - Travel at flexible pace.',
                  pricePerAdult: 80.0,
                  totalPrice: 160.0,
                  times: ['7:30 AM', '8:00 AM', '8:30 AM'],
                  value: 'CAR tour + With meal',
                ),
              ],
            ),
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
    required String value,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),

          // Description
          SingleChildScrollView(
            child: Text(
              description,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),

          // Times
          Row(
            children: times.map((time) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(label: Text(time)),
              );
            }).toList(),
          ),

          // Price
          Row(
            children: [
              Text('\$${pricePerAdult.toStringAsFixed(2)}'),
              Spacer(),
            ],
          ),
          Row(
            children: [
              Text(
                'Total + \$${totalPrice.toStringAsFixed(2)}',

                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18, 
                ),
              ),
            ],
          ),

          Row(
            children: [
              Text('(Price includes taxes and booking fees)'),
            ],
          ),
        ],
      ),
    );
  }
}
