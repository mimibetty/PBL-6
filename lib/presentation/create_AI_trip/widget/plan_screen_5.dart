import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_6.dart';
import 'package:travelappflutter/presentation/search_screen/controller/things_to_do_controller.dart';

class PlanScreen5 extends StatefulWidget {
  @override
  _PlanScreen5State createState() => _PlanScreen5State();
}

class _PlanScreen5State extends State<PlanScreen5> {
  final ThingsToDoController thingsToDoController = Get.put(ThingsToDoController());
  final PlanScreenController planScreenController = Get.put(PlanScreenController());

  @override
  void initState() {
    super.initState();
    // Clear selected tags when the screen is initialized
    if (planScreenController.tagsSelected.isNotEmpty) {
      planScreenController.tagsSelected.clear();
    }
    // Fetch tags for a specific city (replace with actual city ID)
    thingsToDoController.fetchTags(planScreenController.cityId.value);
  }

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
              "${planScreenController.cityName.value} Itinerary",
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
                  Obx(() {
                    if (thingsToDoController.isLoadingForTags.value) {
                      return Center(child: CircularProgressIndicator(color: Colors.blue));
                    } else if (thingsToDoController.tags.isEmpty) {
                      return Center(child: Text('No tags found', style: TextStyle(color: Colors.black)));
                    } else {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: thingsToDoController.tags.map((tag) => choiceChip(tag.name)).toList(),
                      );
                    }
                  }),
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
    bool isSelected = planScreenController.tagsSelected.any((tag) => tag.name == label);

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          final tag = thingsToDoController.tags.firstWhere((tag) => tag.name == label);
          if (selected) {
            planScreenController.addTag(tag);
          } else {
            planScreenController.removeTag(tag);
          }
        });
      },
      selectedColor: Colors.blue,
      backgroundColor: Colors.white,
      shape: StadiumBorder(side: BorderSide(color: Colors.black)),
    );
  }
}