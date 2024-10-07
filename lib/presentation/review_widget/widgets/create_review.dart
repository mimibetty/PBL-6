import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io'; // Import dart:io to handle File
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

class ReviewFormPage extends StatefulWidget {
  final int destinationId;

  ReviewFormPage({Key? key, required this.destinationId}) : super(key: key);

  @override
  _ReviewFormPageState createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final TextEditingController _contextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double _rating = 0;
  List<File> _selectedImages = []; // Biến để lưu trữ danh sách các file ảnh đã chọn (tối đa 3)

  @override
  void dispose() {
    _contextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
  if (_selectedImages.length >= 3) {
    Get.snackbar('Limit reached', 'You can only select up to 3 images.');
    return;
  }

  final ImagePicker picker = ImagePicker(); // Tạo đối tượng ImagePicker
  final List<XFile>? pickedFiles = await picker.pickMultiImage(); // Chọn nhiều ảnh từ thư viện

  if (pickedFiles != null && pickedFiles.isNotEmpty) {
    setState(() {
      for (var pickedFile in pickedFiles) {
        if (_selectedImages.length < 3) {
          _selectedImages.add(File(pickedFile.path)); // Lưu file ảnh
        }
      }
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar và thông tin người dùng
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[300],
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),

              // TextField để nhập review content
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _contextController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: "What's on your mind?",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                    ),
                    maxLines: 10,
                    minLines: 1,
                    onTap: () {
                      FocusScope.of(context).requestFocus(_focusNode);
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Hiển thị tối đa 3 ảnh trên một hàng
              if (_selectedImages.isNotEmpty)
                Container(
                  height: 100, // Đặt chiều cao container cho ảnh
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _selectedImages.map((image) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Image.file(
                            image,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              SizedBox(height: 20),

              // Rating bar để người dùng chọn số sao
              Row(
                children: [
                  Text(
                    'Rating:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Dòng để thêm các thông tin khác
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo_library, color: Colors.black),
                        onPressed: _pickImages, // Chọn ảnh từ thư viện
                      ),
                      IconButton(
                        icon: Icon(Icons.people, color: Colors.black),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.tag_faces, color: Colors.black),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.location_on, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: () {
                      if (_contextController.text.isEmpty || _rating == 0) {
                        Get.snackbar('Error', 'All fields are required');
                        return;
                      }

                      // Submit logic
                    },
                    child: Text('Post', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
