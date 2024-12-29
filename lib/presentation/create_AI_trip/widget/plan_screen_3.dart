import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travelappflutter/presentation/create_AI_trip/controller/plan_screen_controller.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_4.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/trip_data.dart';

class PlanScreen3 extends StatefulWidget {
  @override
  _PlanScreen3State createState() => _PlanScreen3State();
}

class _PlanScreen3State extends State<PlanScreen3> {
  final PlanScreenController planScreenController = Get.find<PlanScreenController>();
  DateTime? _selectedStartDate;

  // Calculate the end date based on the selected start date and trip length
  DateTime? get _calculatedEndDate {
    if (_selectedStartDate == null) return null;
    return _selectedStartDate!.add(Duration(days: planScreenController.tripLength.value));
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Ensure dates start from today
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        planScreenController.monthTime.value = DateFormat('MMMM').format(picked);
      });
    }
  }

  void _navigateToNextPage(BuildContext context) {
    if (_selectedStartDate != null) {
      // Save dates in the singleton
      TripDates().startDate = _selectedStartDate;
      TripDates().endDate = _calculatedEndDate;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlanScreen4()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a start date first.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Your Trip',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose a start date and trip length',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Date Picker Button
            ElevatedButton(
              onPressed: () => _selectStartDate(context),
              child: Text(
                'Select Start Date',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(height: 10),

            // Selected Start Date Display
            if (_selectedStartDate != null)
              Text(
                'Start Date (dd/MM/yyyy): ${DateFormat('dd/MM/yyyy').format(_selectedStartDate!)}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),

            // Trip Length Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Trip Length:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (planScreenController.tripLength.value > 1) {
                          setState(() {
                            planScreenController.tripLength.value--;
                          });
                        }
                      },
                    ),
                    Obx(() => Text('${planScreenController.tripLength.value}', style: TextStyle(fontSize: 20))),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (planScreenController.tripLength.value < 7) {
                          setState(() {
                            planScreenController.tripLength.value++;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Calculated End Date Display
            if (_selectedStartDate != null)
              Text(
                'End Date (dd/MM/yyyy): ${DateFormat('dd/MM/yyyy').format(_calculatedEndDate!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

            Spacer(),

            // Next Button
            Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanScreen4(),
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
      ),
    );
  }
}