import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final List<File> selectedImages;
  final Function(List<File>) onImagesPicked;

  ImagePickerWidget({required this.selectedImages, required this.onImagesPicked});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      final List<File> images = pickedFiles.map((file) => File(file.path)).toList();
      widget.onImagesPicked(images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0), // Padding cho widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị hình ảnh đã chọn
          if (widget.selectedImages.isNotEmpty) 
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.selectedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0), // Bo góc cho hình ảnh
                      child: Image.file(
                        widget.selectedImages[index],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          
          SizedBox(height: 10), // Khoảng cách dưới hình ảnh
          Text('Add some photos',
                style: TextStyle(fontSize: 17)),
                SizedBox(height: 10,),
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                height: 100,
                color: Colors.grey[200],
                child: Center(
                    child: Text('Click to add photos or drag and drop')),
              ),
            ),
        ],
      ),
    );
  }
}
