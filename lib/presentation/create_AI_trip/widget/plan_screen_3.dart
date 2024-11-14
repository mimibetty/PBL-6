import 'package:flutter/material.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_4.dart';

class PlanScreen3 extends StatefulWidget {
  @override
  _PlanScreen3State createState() => _PlanScreen3State();
}

class _PlanScreen3State extends State<PlanScreen3>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _selectedStartDate;
  int _tripLength = 1; // Default trip length (1 day)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedStartDate)
      setState(() {
        _selectedStartDate = picked;
      });
  }

  // Hàm điều hướng đến trang mới khi chọn tháng

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Where do you want to go?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa toàn bộ
          children: [
            Center(
              child: Text(
                'Choose a day/date range (up to 7 days)',
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 10),
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Dates(MM/DD)'),
                Tab(text: 'Trip Length'),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // First tab - "Chọn ngày bắt đầu"
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _selectStartDate(context),
                          child: Text(
                            'Start Day -> End Day',
                            style: TextStyle(
                                color: Colors
                                    .white), // Setting the text color to white
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor:
                                Colors.blue, // Button's background color
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Second tab - "Chọn số ngày chuyến đi"
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total days:',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    if (_tripLength > 1) {
                                      setState(() {
                                        _tripLength--;
                                      });
                                    }
                                  },
                                ),
                                Text('$_tripLength',
                                    style: TextStyle(fontSize: 20)),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    if (_tripLength < 7) {
                                      setState(() {
                                        _tripLength++;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'During what month?',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          children: List.generate(12, (index) {
                            return ChoiceChip(
                              label: Text(
                                [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun',
                                  'Jul',
                                  'Aug',
                                  'Sep',
                                  'Oct',
                                  'Nov',
                                  'Dec'
                                ][index],
                                style: TextStyle(color: Colors.white),
                              ),
                              selected: false,
                              onSelected: (selected) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlanScreen4()),
                                );
                              },
                              backgroundColor: Colors.grey,
                              selectedColor: Colors.blue,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
