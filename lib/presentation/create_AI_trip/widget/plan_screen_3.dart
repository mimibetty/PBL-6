import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelappflutter/presentation/create_AI_trip/widget/plan_screen_4.dart';

class PlanScreen3 extends StatefulWidget {
  @override
  _PlanScreen3State createState() => _PlanScreen3State();
}

class _PlanScreen3State extends State<PlanScreen3> {
  DateTime? _selectedStartDate;
  int _tripLength = 1; // Default trip length (1 day)

  // Calculate the end date based on the selected start date and trip length
  DateTime? get _calculatedEndDate {
    if (_selectedStartDate == null) return null;
    return _selectedStartDate!.add(Duration(days: _tripLength - 1));
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
      });
    }
  }

  void _navigateToNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanScreen4()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Your Trip',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                        if (_tripLength > 1) {
                          setState(() {
                            _tripLength--;
                          });
                        }
                      },
                    ),
                    Text('$_tripLength', style: TextStyle(fontSize: 20)),
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

            // Calculated End Date Display
            if (_selectedStartDate != null)
              Text(
                'End Date (dd/MM/yyyy): ${DateFormat('dd/MM/yyyy').format(_calculatedEndDate!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

            Spacer(),

            // Next Button
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 30.0), // Adjust the bottom padding
              child: ElevatedButton(
                onPressed: () => _navigateToNextPage(context),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Text color set to white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor:
                      Colors.blue, // Button background color set to green
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
