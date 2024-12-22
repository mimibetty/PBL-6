import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_6.dart';

class PlanScreen5 extends StatefulWidget {
  @override
  _PlanScreen5State createState() => _PlanScreen5State();
}

class _PlanScreen5State extends State<PlanScreen5> {
  List<String> options = [
    "Must-see Attractions",
    "Great Food",
    "Hidden Gems",
    "Central Park Tours",
    "Broadway Shows & NYC Stages",
    "Nightlife Tours in NYC",
    "Art Museums",
    "Broadway Theater",
    "Pizza",
    "Iconic Landmarks",
    "Luxury Shopping",
    "Jazz Clubs",
  ];

  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Da Nang City, Da Nang Itinerary",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.purple, size: 20),
                SizedBox(width: 4),
                Text(
                  "Powered by AI",
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How do you want to spend your time?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Choose as many as you’d like.",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: options.map((option) => choiceChip(option)).toList(),
                  ),
                  SizedBox(height: 80), // Add space to prevent overlap
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanScreen6(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget choiceChip(String label) {
    bool isSelected = selectedOptions.contains(label);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style:
                  TextStyle(color: isSelected ? Colors.white : Colors.black)),
          if (isSelected) ...[
            SizedBox(width: 4),
            Icon(Icons.check, color: Colors.white, size: 18),
          ]
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedOptions.add(label);
          } else {
            selectedOptions.remove(label);
          }
        });
      },
      selectedColor: Colors.blue,
      backgroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: Colors.black)),
    );
  }
}
