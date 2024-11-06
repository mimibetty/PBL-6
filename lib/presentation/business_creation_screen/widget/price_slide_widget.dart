import 'package:flutter/material.dart';

class PriceRangeSlider extends StatefulWidget {
  final Function(String) onPriceRangeChanged; // Callback để lấy khoảng giá

  PriceRangeSlider({required this.onPriceRangeChanged}); // Constructor

  @override
  _PriceRangeSliderState createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  double _minPrice = 0; // Giá tối thiểu
  double _maxPrice = 1000; // Giá tối đa
  RangeValues _currentRangeValues = RangeValues(0, 1000); // Giá hiện tại

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price range',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        RangeSlider(
          values: _currentRangeValues,
          min: _minPrice,
          max: _maxPrice,
          divisions: 100, // Số phân chia giữa giá tối thiểu và tối đa
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values; // Cập nhật giá trị hiện tại
              // Cập nhật khoảng giá và gọi callback
              String priceRange = '${values.start.round()} - ${values.end.round()}';
              widget.onPriceRangeChanged(priceRange);
            });
          },
        ),
        SizedBox(height: 16),
        Text(
          'Price: ${_currentRangeValues.start.round()} - ${_currentRangeValues.end.round()}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
