import 'package:flutter/material.dart';

class TourOverviewWidget extends StatelessWidget {
  const TourOverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About Section
            _buildAboutSection(),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),
            // What's Included Section
            _buildExpansionTile(
              title: "What's included",
              items: _getIncludedItems(),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),
            // What's Not Included Section
            _buildExpansionTile(
              title: "What's not included",
              items: _getNotIncludedItems(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    final List<String> aboutDetails = [
      "Ages 1-99, max of 12 per group",
      "Duration: 9h",
      "Start time: Check availability",
      "Mobile ticket",
      "Live guide: English",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: aboutDetails.map((detail) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            detail,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpansionTile({required String title, required List<String> items}) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "• ",
                style: TextStyle(fontSize: 16),
              ),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<String> _getIncludedItems() {
    return [
      "A two ways hotel transfers pick up and drop off (120km round trip...)",
      "Return cable car ticket 950,000 VND/adult (if you select the option with cable cars)",
      "Buffet lunch 350,000 VND/adult (if you select the option with buffet lunch)",
      "English Speaking guide & water for drinking",
      "Golden hand bridge - Games in Fantasy Park & outdoor activities",
      "Note: The only way to reach Ba Na Hills and Golden Bridge via Cable Cars",
    ];
  }

  List<String> _getNotIncludedItems() {
    return [
      "Personal expenses",
      "Travel insurance",
    ];
  }
}
