import 'package:flutter/material.dart';

class PlanScreen6 extends StatefulWidget {
  @override
  _PlanScreen6State createState() => _PlanScreen6State();
}

class _PlanScreen6State extends State<PlanScreen6> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Da Nang City Itinerary', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: 'Places to stay'),
            Tab(text: 'Day 1'),
            Tab(text: 'Day 2'),
            Tab(text: 'Day 3'),
            Tab(text: 'Day 4'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PlacesToStayTab(),
          ItineraryDayTab(day: 'Day 1', description: 'Welcome to Da Nang City! Get ready for an exciting first day exploring...'),
          ItineraryDayTab(day: 'Day 2', description: 'Explore My Khe Beach and the Dragon Bridge.'),
          ItineraryDayTab(day: 'Day 3', description: 'Discover the vibrant culture in Hoi An.'),
          ItineraryDayTab(day: 'Day 4', description: 'Enjoy a relaxing day with a scenic cruise.'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Save itinerary'),
        icon: Icon(Icons.favorite_border),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PlacesToStayTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'We\'ve also recommended some places to stay during your trip.',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        SizedBox(height: 16),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://vivutour.vn/wp-content/uploads/2024/09/muong-thanh-luxury-anh-sp-1.jpg',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Moxy NYC', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                    Icon(Icons.favorite_border, color: Colors.black),
                  ],
                ),
                Text('4 star hotel · 2.80 mi from location', style: TextStyle(color: Colors.black54)),
                Text('\$209 USD - \$479 USD per night', style: TextStyle(color: Colors.black)),
                SizedBox(height: 8),
                Text(
                  'Perfectly located for exploring Da Nang , this hotel offers small, creative rooms with a modern ambiance and friendly service.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ItineraryDayTab extends StatelessWidget {
  final String day;
  final String description;

  ItineraryDayTab({required this.day, required this.description});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          day,
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(height: 16),
        for (int i = 1; i <= 4; i++)
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ExpansionTile(
              title: Text('Location $i', style: TextStyle(color: Colors.black)),
              subtitle: Text('Description of location $i', style: TextStyle(color: Colors.black54)),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Here is some additional information about Location $i. This can include details such as the history, significance, or tips for visiting.',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
