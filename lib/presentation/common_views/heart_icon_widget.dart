import 'package:flutter/material.dart';

class HeartIconWidget extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onDoubleTap;

  const HeartIconWidget({Key? key, required this.isLiked, required this.onDoubleTap}) : super(key: key);

  @override
  _HeartIconWidgetState createState() => _HeartIconWidgetState();
}

class _HeartIconWidgetState extends State<HeartIconWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Phóng to/thu nhỏ hiệu ứng
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Thêm hiệu ứng lắc trái tim
    _shakeAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0.05, 0.0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  void toggleHeart() {
    if (widget.isLiked) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    widget.onDoubleTap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: toggleHeart,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _shakeAnimation.value, // Thêm hiệu ứng lắc
            child: Transform.scale(
              scale: _scaleAnimation.value, // Phóng to/thu nhỏ
              child: Icon(
                widget.isLiked ? Icons.favorite : Icons.favorite_border,
                color: widget.isLiked ? Colors.red : Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}
