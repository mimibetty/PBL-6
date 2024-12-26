import 'dart:io';
import 'package:flutter/material.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/common_views/avatar_image_picker_widget.dart';
import 'package:travelappflutter/presentation/home_screen/controller/home_controller.dart';
import 'package:travelappflutter/presentation/profile_screen/models/profile_model.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';

class AccountInfoScreen extends StatefulWidget {
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  String? selectedBusinessType;
  final _formKey = GlobalKey<FormState>();
  List<File> selectedImages = []; // Danh sách hình ảnh đã chọn

  // Tạo TextEditingController cho từng trường để đặt giá trị ban đầu
  late TextEditingController nameController;
  late TextEditingController contactNumberController;
  late TextEditingController locationController;
  late TextEditingController aboutController;

  @override
  void initState() {
    super.initState();
    
    // Fetch profile data initially
    profileController.fetchUserProfile();
    // Khởi tạo các controller với giá trị từ ProfileController
    nameController = TextEditingController(text: profileController.profileModelObj.value.username);
    contactNumberController = TextEditingController(text: profileController.profileModelObj.value.userInfo?.phoneNumber ?? '');
    locationController = TextEditingController(
      text: profileController.profileModelObj.value.userInfo?.address.formattedAddress() ?? '',
    );
    aboutController = TextEditingController(text: profileController.profileModelObj.value.userInfo?.description ?? '');
    print("Name: " +  profileController.profileModelObj.value.username);
    print("ID: " +  profileController.profileModelObj.value.id.toString());
    print("User Info ID: " +  (profileController.profileModelObj.value.userInfo?.id.toString() ?? 'null'));
  }

  @override
  void dispose() {
    // Giải phóng controller khi không còn sử dụng
    nameController.dispose();
    contactNumberController.dispose();
    locationController.dispose();
    aboutController.dispose();
    super.dispose();
  }


  // Phương thức reset form 
void _resetForm() {
  setState(() {
    // Gán lại profileModelObj với giá trị mặc định
    profileController.profileModelObj.value = ProfileModel(
      id: profileController.profileModelObj.value.id, // ID mặc định
      username: '', // Tên đăng nhập rỗng
      email: '', // Email rỗng
      role: profileController.profileModelObj.value.role, // Vai trò rỗng
      status: '', // Trạng thái rỗng
      userInfo: UserInfo.empty(), // UserInfo mặc định
    );

    // Gán lại giá trị rỗng cho các TextEditingController
    nameController.text = '';
    contactNumberController.text = '';
    locationController.text = '';
    aboutController.text = '';

    // Reset dropdown city
    profileController.selectedCityId.value = null;

    // Xóa danh sách hình ảnh đã chọn
    selectedImages = [];
  });
}



  // Phương thức Update Information profile
  // Khi gọi hàm Update sẽ lưu cityId tương ứng vào profileModelObj và gọi API
void _handleUpdate() {
  if (_formKey.currentState!.validate()) {
    // Cập nhật địa chỉ từ chuỗi nhập vào
    profileController.updateAddressFromString(locationController.text);

    // Cập nhật các trường trong UserInfo
    final updatedUserInfo = profileController.profileModelObj.value.userInfo?.copyWith(
      description: aboutController.text,
      phoneNumber: contactNumberController.text,
      address: profileController.profileModelObj.value.userInfo?.address.copyWith(
        cityId: profileController.selectedCityId.value ?? 0, // Gán cityId đã chọn
      ),
    );

    // Cập nhật ProfileModel với UserInfo mới
    profileController.profileModelObj.value = profileController.profileModelObj.value.copyWith(
      username: nameController.text,
      userInfo: updatedUserInfo,
    );

    // Gọi API để cập nhật dữ liệu
    profileController.updateUserInfo(selectedImages);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Info Screen'),
        backgroundColor: Colors.white,
      ),
       body: Obx(() {
      // Chờ khi dữ liệu sẵn sàng
        if (!profileController.isProfileReady.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          color: Colors.grey[100], // Màu nền xám nhạt
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _displayProfileImage(), // Display profile image at the top
                  AvatarPickerWidget(
                    selectedImages: selectedImages,
                    onImagesPicked: (images) {
                      setState(() {
                        selectedImages = images;
                      });
                    },
                  ),
                  SizedBox(height: 25.0),
                  _buildTextInput('Name', nameController),
                  // tạm thời ẩn Name vì chưa có bên API
                  SizedBox(height: 16.0),
                  _buildTextInput('Contact Number', contactNumberController),
                  SizedBox(height: 16.0),
                  // _buildDropdownCityType(),
                  SizedBox(height: 27.0),
                  _buildTextInput('Location', locationController),
                  SizedBox(height: 16.0),
                  _buildTextInput('About you', aboutController),
                  SizedBox(height: 32.0),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildElevatedButton('Reset', _resetForm),
                      SizedBox(width: 16),
                      _buildElevatedButton('Update', _handleUpdate),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: CustomBottomNavBar(controller: HomeController()),
    );
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Nền đen
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white), // Chữ trắng
      ),
    );
  }

//  Widget _buildDropdownCityType() {
//   return Obx(() {
//     if (profileController.isCitiesLoading.value) {
//       return CircularProgressIndicator();
//     }

//     return DropdownButtonFormField<int>(
//       value: profileController.selectedCityId.value,
//       decoration: InputDecoration(
//         labelText: 'Choose your city',
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: BorderSide(color: Colors.grey, width: 1.0),
//         ),
//       ),
//       items: profileController.citiesMap.entries
//           .map((entry) => DropdownMenuItem<int>(
//                 value: entry.key,
//                 child: Text(entry.value),
//               ))
//           .toList(),
//       onChanged: (value) {
//         profileController.selectedCityId.value = value;

//         // Cập nhật cityId trong ProfileModel nếu userInfo không null
//         final currentUserInfo = profileController.profileModelObj.value.userInfo;
//         if (currentUserInfo != null) {
//           final updatedUserInfo = currentUserInfo.copyWith(
//             address: currentUserInfo.address.copyWith(cityId: value ?? 0),
//           );
//           profileController.profileModelObj.value = profileController.profileModelObj.value.copyWith(
//             userInfo: updatedUserInfo,
//           );
//         }
//       },
//       validator: (value) {
//         if (value == null) {
//           return 'Please select a city';
//         }
//         return null;
//       },
//       isExpanded: true,
//     );
//   });
// }



  Widget _buildTextInput(
    String label,
    TextEditingController controller, { // Sử dụng TextEditingController thay vì Function(String)
    double height = 50.0, // Chiều cao tối thiểu của trường nhập liệu
    double width = double.infinity, // Chiều rộng mặc định
  }) {
    return Container(
      width: width, // Sử dụng chiều rộng tùy chỉnh
      margin: const EdgeInsets.only(
          bottom: 16.0), // Thêm khoảng cách dưới mỗi trường
      child: TextFormField(
        controller: controller, // Gán TextEditingController vào đây
        minLines: 1, // Số dòng tối thiểu
        maxLines: null, // Không giới hạn số dòng tối đa
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white, // Màu nền trắng
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Không bo góc
            borderSide: BorderSide(
              color: Colors.grey, // Màu viền
              width: 1.0,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập thông tin';
          }
          return null;
        },
      ),
    );
  }


  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required List<String> selectedItems,
    required Function(List<String>) onChanged,
  }) {
    return DropdownButtonFormField<List<String>>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem<List<String>>(
          value: [item],
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        onChanged(value ?? []);
      },
    );
  }
  Widget _displayProfileImage() {
    final imageUrl = profileController.profileModelObj.value.userInfo?.imageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Display icon if image fails to load
          return Icon(Icons.account_circle, size: 100, color: Colors.grey);
        },
      );
    } else {
      // Show placeholder icon if no imageUrl is available
      return Icon(Icons.account_circle, size: 100, color: Colors.grey);
    }
  }

}
