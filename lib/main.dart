import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travelappflutter/presentation/sign_in_screen/controller/auth_controller.dart';
import 'core/app_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo GetStorage để sử dụng local storage
  await GetStorage.init();

  // Đăng ký AuthController để sử dụng toàn cục
  Get.put(AuthController());

  // Đặt chế độ hiển thị dọc
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Khởi tạo Logger
  Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);

  // Chạy ứng dụng
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppLocalization(),
      locale: Get.deviceLocale, // for setting localization strings
      fallbackLocale: Locale('en', 'US'),
      title: 'travelappflutter',
      initialBinding: InitialBindings(),
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
