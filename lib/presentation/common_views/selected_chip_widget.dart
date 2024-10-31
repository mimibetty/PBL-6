import 'package:flutter/material.dart';

class SelectableChipWidget extends StatefulWidget {
  final List<String> labels;
  final Function(List<String>) onSelectionChanged;

  SelectableChipWidget({Key? key, required this.labels, required this.onSelectionChanged}) : super(key: key);

  @override
  _SelectableChipWidgetState createState() => _SelectableChipWidgetState();
}

class _SelectableChipWidgetState extends State<SelectableChipWidget> {
  List<String> selectedLabels = []; // Danh sách các nút được chọn

  void _toggleSelection(String label) {
    setState(() {
      // Nếu label đã được chọn, bỏ chọn; nếu chưa chọn, thêm vào
      if (selectedLabels.contains(label)) {
        selectedLabels.remove(label);
      } else {
        selectedLabels.add(label);
      }
    });

    // Gọi hàm callback để trả về danh sách các nút được chọn
    widget.onSelectionChanged(selectedLabels);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Căn lề trái
      child: Wrap(
        spacing: 8.0,
        children: widget.labels.map((label) {
          final isSelected = selectedLabels.contains(label);

          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => _toggleSelection(label),
            selectedColor: Colors.blue, // Màu khi được chọn
            backgroundColor: Colors.white, // Màu khi không được chọn
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
          );
        }).toList(),
      ),
    );
  }
}
