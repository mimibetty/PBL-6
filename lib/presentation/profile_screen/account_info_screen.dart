import 'dart:io';
import 'package:flutter/material.dart';
import 'package:travelappflutter/core/app_export.dart';
import 'package:travelappflutter/presentation/common_views/avatar_image_picker_widget.dart';
import 'package:travelappflutter/presentation/profile_screen/controller/profile_controller.dart';
import 'package:travelappflutter/presentation/navigation/custom_bottom_nav_bar.dart';

class AccountInfoScreen extends StatefulWidget {
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final ProfileController profileController = Get.find<ProfileController>();
  final _formKey = GlobalKey<FormState>();
  List<File> selectedImages = []; // Danh sách hình ảnh đã chọn

  late TextEditingController nameController;
  late TextEditingController contactNumberController;
  late TextEditingController aboutController;

  @override
  void initState() {
    super.initState();
    profileController.fetchUserProfile();

    nameController = TextEditingController(text: profileController.profileModelObj.value.username);
    contactNumberController = TextEditingController(text: profileController.profileModelObj.value.userInfo?.phoneNumber ?? '');
    profileController.streetController.text = profileController.profileModelObj.value.userInfo?.address.street ?? '';
    profileController.wardController.text = profileController.profileModelObj.value.userInfo?.address.ward ?? '';
    profileController.districtController.text = profileController.profileModelObj.value.userInfo?.address.district ?? '';
    aboutController = TextEditingController(text: profileController.profileModelObj.value.userInfo?.description ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    contactNumberController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      nameController.text = '';
      contactNumberController.text = '';
      aboutController.text = '';
      profileController.streetController.text = '';
      profileController.wardController.text = '';
      profileController.districtController.text = '';
      profileController.selectedCityId.value = null;
      selectedImages.clear();
    });
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      final addressInput = '${profileController.streetController.text}, '
          '${profileController.wardController.text}, '
          '${profileController.districtController.text}';
      print("Address: " + addressInput);
      profileController.updateAddressFromFields();
      final updatedUserInfo = profileController.profileModelObj.value.userInfo?.copyWith(
        description: aboutController.text,
        phoneNumber: contactNumberController.text,
        address: profileController.profileModelObj.value.userInfo?.address.copyWith(
          cityId: profileController.selectedCityId.value ?? 0,
        ),
      );

      profileController.profileModelObj.value = profileController.profileModelObj.value.copyWith(
        username: nameController.text,
        userInfo: updatedUserInfo,
      );

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
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownCityType() {
    return Obx(() {
      if (profileController.isCitiesLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (profileController.selectedCityId.value != null &&
          !profileController.citiesMap.containsKey(profileController.selectedCityId.value)) {
        profileController.selectedCityId.value = null;
      }

      return DropdownButtonFormField<int>(
        value: profileController.selectedCityId.value,
        decoration: InputDecoration(
          labelText: 'Choose your city',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: profileController.citiesMap.entries
            .map((entry) => DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            profileController.selectedCityId.value = value;
          }
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a city';
          }
          return null;
        },
      );
    });
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Màu nổi bật
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Bo góc
        ),
        elevation: 5.0, // Hiệu ứng nổi
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white, // Màu chữ
          fontWeight: FontWeight.bold, // Đậm hơn
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _displayProfileImage() {
    final imageUrl = profileController.profileModelObj.value.userInfo?.imageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent, width: 4), // Viền xanh nổi bật
            ),
            child: ClipOval(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.account_circle, size: 100, color: Colors.grey);
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          ),
          Icon(Icons.account_circle, size: 100, color: Colors.grey),
        ],
      );
    }
  }

Widget _loadingOverlay(String message) {
  return Center(
    child: Container(
      width: 150.0, // Chiều rộng nhỏ gọn
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Nền trắng gọn gàng
        borderRadius: BorderRadius.circular(12.0), // Bo góc mềm mại
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Bóng mờ nhẹ
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            strokeWidth: 3.0, // Tăng độ mỏng của thanh tải
          ),
          SizedBox(height: 12.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.0, // Font nhỏ gọn hơn
              fontWeight: FontWeight.w400, // Kiểu chữ nhẹ nhàng
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildBody() {
    return Obx(() {
      if (!profileController.isProfileReady.value) {
        return Center(child: CircularProgressIndicator());
      }

      // Hiển thị UI loading khi đang cập nhật
      if (profileController.isLoading.value) {
        return _loadingOverlay("Update User Info...");
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //_displayProfileImage(),
              AvatarPickerWidget(
                selectedImages: selectedImages,
                onImagesPicked: (images) {
                  setState(() {
                    selectedImages = images;
                  });
                },
              ),
              SizedBox(height: 20),
              _buildTextInput('Name', nameController),
              SizedBox(height: 16),
              _buildTextInput('Contact Number', contactNumberController),
              SizedBox(height: 16),
              _buildTextInput('Street', profileController.streetController),
              SizedBox(height: 16),
              _buildTextInput('Ward', profileController.wardController),
              SizedBox(height: 16),
              _buildTextInput('District', profileController.districtController),
              SizedBox(height: 16),
              _buildDropdownCityType(),
              SizedBox(height: 16),
              _buildTextInput('About You', aboutController),
              SizedBox(height: 32),
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
      );
    });
  }
}
