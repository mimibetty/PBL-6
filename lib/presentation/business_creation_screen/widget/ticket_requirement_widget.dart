import 'package:flutter/material.dart';

class TicketRequirementWidget extends StatelessWidget {
  final bool ticketRequired;
  final ValueChanged<bool> onChanged;

  TicketRequirementWidget({
    required this.ticketRequired,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket Requirement',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: Text('Yes'),
                value: true,
                groupValue: ticketRequired,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: Text('No'),
                value: false,
                groupValue: ticketRequired,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
