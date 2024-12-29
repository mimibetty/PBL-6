import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  // Observable để lưu userId
  RxInt userId = 0.obs;

  // Instance của GetStorage
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Khởi tạo trạng thái từ local storage
    userId.value = storage.read<int>('userId') ?? 0;
  }

  // Phương thức cập nhật userId sau khi đăng nhập
  void updateUserId(int newUserId) {
    print("checking userId: $newUserId");
    userId.value = newUserId;
    storage.write('userId', newUserId); // Lưu vào local storage
  }

  // Kiểm tra xem người dùng đã đăng nhập chưa
  bool get isLoggedIn => userId.value != 0;

  // Đăng xuất
  void logout() {
    userId.value = 0;
    storage.remove('userId'); // Xóa thông tin đăng nhập khỏi local storage
  }
}
