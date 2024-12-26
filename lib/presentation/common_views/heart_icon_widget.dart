import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeartIconWidget extends StatefulWidget {
  final bool isLiked;
  final double size;
  final int userId; // ID of the user
  final int destinationId; // ID of the destination

  const HeartIconWidget({
    Key? key,
    required this.isLiked,
    this.size = 26.0,
    required this.userId,
    required this.destinationId,
  }) : super(key: key);

  @override
  _HeartIconWidgetState createState() => _HeartIconWidgetState();
}

class _HeartIconWidgetState extends State<HeartIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _checkLikeStatus(); // Check the initial like status from the API
  }

  final String baseURL = "https://pbl6-travel-fastapi-azfpceg2czdybuh3.eastasia-01.azurewebsites.net";

  Future<void> _checkLikeStatus() async {
    try {
      final Uri url = Uri.parse(
          '$baseURL/user/${widget.userId}/has_liked/${widget.destinationId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final bool status = response.body == 'true';
        setState(() {
          isLiked = status;
        });
      }
    } catch (e) {
      debugPrint('Error checking like status: $e');
    }
  }

  Future<void> _like() async {
    try {
      final Uri url = Uri.parse('$baseURL/user/${widget.userId}/like/${widget.destinationId}');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        setState(() {
          isLiked = true;
        });
      }
    } catch (e) {
      debugPrint('Error liking: $e');
    }
  }

  Future<void> _dislike() async {
    try {
      final Uri url = Uri.parse('$baseURL/user/${widget.userId}/unlike/${widget.destinationId}');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          isLiked = false;
        });
      }
    } catch (e) {
      debugPrint('Error disliking: $e');
    }
  }

  void _toggleHeart() {
    if (isLiked) {
      _controller.reverse(); // Shrink animation on dislike
      _dislike(); // Call API to dislike
    } else {
      _controller.forward(); // Expand animation on like
      _like(); // Call API to like
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleHeart, // Handle single tap
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
                size: widget.size * 0.8, // Scale the icon size
              ),
            ),
          );
        },
      ),
    );
  }
}