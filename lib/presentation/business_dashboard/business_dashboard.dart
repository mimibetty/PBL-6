import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/business_dashboard/rating_screen.dart';

class BusinessDashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<BusinessDashboard> {
  final mockData = [
    {
      'photo':
          'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400',
      'name': 'Cơm mộc Lê Gia',
      'location': 'Số 2 ngõ 59 Mễ Trì, Nguyễn Trãi, Hà Đông, Hà Nội',
      'rating': 5.0,
      'chartData': [2.0, 5.0, 3.0, 7.0, 8.0, 5.0, 6.0, 9.0, 4.0, 8.0, 7.0, 5.0]
    },
    {
      'photo':
          'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400',
      'name': 'Sân Golf Vân Trì',
      'location': 'Kim Nỗ, Xã Kim Nỗ, Đông Anh, Hà Nội',
      'rating': 5.0,
      'chartData': [3.0, 4.0, 2.0, 8.0, 5.0, 6.0, 7.0, 8.0, 4.0, 6.0, 9.0, 7.0]
    },
    {
      'photo':
          'https://images.unsplash.com/photo-1546069901-eacef0df6022?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400',
      'name': 'Yu long - Buffet lẩu nướng',
      'location': '10, lô 10, ngõ 67 Phùng Khoang, Nam Từ Liêm, Hà Nội',
      'rating': 5.0,
      'chartData': [5.0, 6.0, 7.0, 5.0, 4.0, 8.0, 6.0, 7.0, 9.0, 5.0, 8.0, 6.0]
    },
    {
      'photo':
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400',
      'name': 'Somerset West Lake Hà Nội',
      'location': '254D Thuỵ Khuê, Thuỵ Khuê, Tây Hồ, Hà Nội',
      'rating': 5.0,
      'chartData': [4.0, 5.0, 6.0, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 7.0, 6.0, 8.0]
    },
    {
      'photo':
          'https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/473768Xww/reency-ngo-838611.jpg',
      'name': 'Hotel du Monde Art',
      'location': '69 Hoàng Như Tiếp, Bồ Đề, Long Biên',
      'rating': 4.5,
      'chartData': [3.0, 6.0, 8.0, 5.0, 4.0, 6.0, 7.0, 8.0, 9.0, 6.0, 7.0, 5.0]
    },
  ];

  // Track selected data for the chart
  Map<String, dynamic>? selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = mockData[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Dashboard'),
        backgroundColor: Colors.grey[100],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Text(
                  "Welcome to VinGroup Company Dashboard \n\nAnalyze your business performance",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 30.0,
                    runSpacing: 20.0,
                    children: <Widget>[
                      buildDashboardCard("assets/images/places.png",
                          "Total Places", "69 Places"),
                      buildDashboardCard("assets/images/total_tours.png",
                          "Total Tour Packages", "12 Tours"),
                      buildDashboardCard("assets/images/total_review.png",
                          "Total Reviews", "96 Review"),
                      buildDashboardCard("assets/images/total_rating.png",
                          "Average Ratings", "3.6"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  alignment: Alignment.center,
                  height: 400,
                  child: RatingBarChart(
                    chartTitle: selectedLocation!['name'] as String,
                    chartData: selectedLocation!['chartData'] as List<double>,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Top 5 Destinations",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildTopDestinationsTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDashboardCard(String assetPath, String title, String subtitle) {
    return SizedBox(
      width: 160.0,
      height: 160.0,
      child: Card(
        color: Colors.grey[200],
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  assetPath,
                  width: 50.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w200,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopDestinationsTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Adds horizontal spacing
      child: ListView.builder(
        itemCount: mockData.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final location = mockData[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLocation = location;
              });
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        location['photo'] as String,
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image, size: 60.0, color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location['name'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Rating: ${(location['rating'] as double).toString()} ★',
                          ),
                          Text(location['location'] as String),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '#${index + 1}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
