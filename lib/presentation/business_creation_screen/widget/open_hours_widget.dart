import 'package:flutter/material.dart';

class OpeningHoursInput extends StatefulWidget {
  final ValueChanged<String> onOpeningTimeChanged;
  final ValueChanged<String> onClosingTimeChanged;

  OpeningHoursInput({
    required this.onOpeningTimeChanged,
    required this.onClosingTimeChanged,
  });

  @override
  _OpeningHoursInputState createState() => _OpeningHoursInputState();
}

class _OpeningHoursInputState extends State<OpeningHoursInput> {
  TimeOfDay? openingTime; // Thời gian mở cửa
  TimeOfDay? closingTime; // Thời gian đóng cửa

  Future<void> _selectTime(BuildContext context, bool isOpeningTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isOpeningTime) {
          openingTime = picked;
          widget.onOpeningTimeChanged(openingTime!.format(context)); // Gọi callback
        } else {
          closingTime = picked;
          widget.onClosingTimeChanged(closingTime!.format(context)); // Gọi callback
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Open hour',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimePickerField(
              label: openingTime != null
                  ? openingTime!.format(context)
                  : 'Open time',
              onTap: () => _selectTime(context, true),
            ),
            SizedBox(width: 16),
            _buildTimePickerField(
              label: closingTime != null
                  ? closingTime!.format(context)
                  : 'Close time',
              onTap: () => _selectTime(context, false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimePickerField({required String label, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Điều chỉnh khoảng cách bên trong
            ),
          ),
        ),
      ),
    );
  }
}
