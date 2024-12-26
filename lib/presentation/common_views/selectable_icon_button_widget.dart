import 'package:flutter/material.dart';

class SelectableIconButtonWidget extends StatefulWidget {
  final List<Map<String, dynamic>> buttonData; // Dữ liệu cho các button (có label và icon)
  final Function(String) onSelectionChanged; // Callback khi thay đổi lựa chọn

  SelectableIconButtonWidget({
    Key? key,
    required this.buttonData,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _SelectableIconButtonWidgetState createState() =>
      _SelectableIconButtonWidgetState();
}

class _SelectableIconButtonWidgetState
    extends State<SelectableIconButtonWidget> {
  String? selectedLabel; // Biến lưu trữ label của button được chọn

  void _selectButton(String label) {
    setState(() {
      // Chọn lại button mới hoặc bỏ chọn nếu đã chọn
      selectedLabel = selectedLabel == label ? null : label;
    });

    // Gọi callback để trả về label của button được chọn
    widget.onSelectionChanged(selectedLabel ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Thêm padding tổng thể 10
      child: Align(
        alignment: Alignment.centerLeft, // Căn lề trái
        child: Wrap(
          spacing: 8.0,
          children: widget.buttonData.map((data) {
            final isSelected = selectedLabel == data['label'];

            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    data['icon'],
                    color: isSelected ? Colors.white : Colors.black,
                    size: 16.0,
                  ),
                  SizedBox(width: 8),
                  Text(
                    data['label'],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "(${data['count']})", // Hiển thị số lượng
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (_) => _selectButton(data['label']),
              selectedColor: Colors.blue, // Màu khi được chọn
              backgroundColor: Colors.white, // Màu khi không được chọn
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
            );
          }).toList(),
        ),
      ),
    );
  }
}
