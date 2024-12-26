import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelappflutter/presentation/review_widget/models/review_widget_model.dart';

class ImagePickerWidget extends StatefulWidget {
  final List<File> selectedImages; // Ảnh mới được chọn
  final Function(List<File>) onImagesPicked; // Callback khi chọn ảnh mới
  final String action; // "create" hoặc "update"
  final List<ReviewImage>? existingImages; // Danh sách ảnh cũ từ server (nullable)
  final Function(List<int>)? onImagesRemoved; // Callback để cập nhật danh sách ID ảnh bị xóa (nullable)

  ImagePickerWidget({
    required this.selectedImages,
    required this.onImagesPicked,
    required this.action,
    this.existingImages, // Không bắt buộc
    this.onImagesRemoved, // Không bắt buộc
  });

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<int> pendingRemovedImageIds = []; // Lưu trữ ID ảnh tạm thời bị xóa
  List<File> pendingSelectedImages = []; // Lưu ảnh mới tạm thời

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      final List<File> images = pickedFiles.map((file) => File(file.path)).toList();

      if (widget.action == 'update') {
        if ((widget.existingImages?.length ?? 0) + pendingSelectedImages.length + images.length > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You can only add up to 3 images.')),
          );
          return;
        }
      }

      setState(() {
        // Chỉ thêm ảnh vào pendingSelectedImages, không làm thay đổi widget.selectedImages
        pendingSelectedImages.addAll(images);
      });

      // Gọi callback để cập nhật ảnh mới mà không thêm lại vào pendingSelectedImages
      widget.onImagesPicked(pendingSelectedImages);
    }
  }


  void _markImageForRemoval(int index) {
    setState(() {
      if (widget.existingImages != null && index < widget.existingImages!.length) {
        final imageId = widget.existingImages![index].id;
        if (pendingRemovedImageIds.contains(imageId)) {
          pendingRemovedImageIds.remove(imageId);
        } else {
          pendingRemovedImageIds.add(imageId);
        }
        widget.onImagesRemoved?.call(pendingRemovedImageIds);
      } else {
        // Xóa ảnh mới
        final adjustedIndex = index - (widget.existingImages?.length ?? 0);
        pendingSelectedImages.removeAt(adjustedIndex);
        widget.onImagesPicked(pendingSelectedImages); // Cập nhật callback với danh sách mới
      }
    });
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.existingImages != null && widget.existingImages!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Existing Images:', style: TextStyle(fontSize: 17)),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.existingImages!.length,
                    itemBuilder: (context, index) {
                      final isMarkedForRemoval = pendingRemovedImageIds.contains(widget.existingImages![index].id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: ColorFiltered(
                                colorFilter: isMarkedForRemoval
                                    ? ColorFilter.mode(Colors.grey, BlendMode.saturation)
                                    : ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                                child: Image.network(
                                  widget.existingImages![index].url,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _markImageForRemoval(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isMarkedForRemoval ? Colors.green : Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isMarkedForRemoval ? Icons.undo : Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          if (pendingSelectedImages.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New Images:', style: TextStyle(fontSize: 17)),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pendingSelectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                pendingSelectedImages[index],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _markImageForRemoval(widget.existingImages?.length ?? 0 + index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          Text('Add some photos', style: TextStyle(fontSize: 17)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: widget.action == 'create' ||
                    (pendingSelectedImages.length + (widget.existingImages?.length ?? 0) - pendingRemovedImageIds.length) < 3
                ? _pickImages
                : null,
            child: Container(
              height: 100,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  (pendingSelectedImages.length + (widget.existingImages?.length ?? 0) - pendingRemovedImageIds.length) < 3
                      ? 'Click to add photos or drag and drop'
                      : 'You can only add up to 3 photos',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
