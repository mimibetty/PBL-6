import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPickerWidget extends StatefulWidget {
  final List<File> selectedImages;
  final Function(List<File>) onImagesPicked;

  AvatarPickerWidget({required this.selectedImages, required this.onImagesPicked});

  @override
  _AvatarPickerWidgetState createState() => _AvatarPickerWidgetState();
}

class _AvatarPickerWidgetState extends State<AvatarPickerWidget> {
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File image = File(pickedFile.path);
      widget.onImagesPicked([image]); // Call onImagesPicked with the selected image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Choose an avatar',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          
          // Use GestureDetector to make the icon or image tappable
          GestureDetector(
            onTap: _pickImage,
            child: widget.selectedImages.isNotEmpty
                ? ClipOval(
                    child: Image.file(
                      widget.selectedImages[0],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey[600],
                  ),
          ),
          
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
