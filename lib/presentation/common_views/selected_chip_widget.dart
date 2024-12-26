import 'package:flutter/material.dart';

class SelectableChipWidget extends StatefulWidget {
  final List<String> labels;
  final Function(List<String>) onSelectionChanged;
  final List<String> initialSelectedLabels;

  SelectableChipWidget({
    Key? key,
    required this.labels,
    required this.onSelectionChanged,
    this.initialSelectedLabels = const [],
  }) : super(key: key);

  @override
  _SelectableChipWidgetState createState() => _SelectableChipWidgetState();
}

class _SelectableChipWidgetState extends State<SelectableChipWidget> {
  Set<String> selectedLabels = <String>{};

  @override
  void initState() {
    super.initState();
    // Remove leading/trailing spaces in initialSelectedLabels and labels
    selectedLabels = widget.initialSelectedLabels
        .map((label) => label.trim())
        .toSet();
  }

  void _toggleSelection(String label) {
    setState(() {
      label = label.trim(); // Ensure the label is trimmed before toggling
      if (selectedLabels.contains(label)) {
        selectedLabels.remove(label);
      } else {
        selectedLabels.add(label);
      }
    });
    widget.onSelectionChanged(selectedLabels.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8.0,
        children: widget.labels.map((label) {
          final trimmedLabel = label.trim(); // Trim each label
          final isSelected = selectedLabels.contains(trimmedLabel);

          return ChoiceChip(
            label: Text(trimmedLabel),
            selected: isSelected,
            onSelected: (_) => _toggleSelection(trimmedLabel),
            selectedColor: Colors.blue,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          );
        }).toList(),
      ),
    );
  }
}
