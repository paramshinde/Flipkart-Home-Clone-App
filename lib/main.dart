import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';
import 'core/constants/app_constants.dart';
import 'data/services/home_api_service.dart';
import 'views/home/home_page.dart';
import 'views/splash/splash_page.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  Get.put<HomeApiService>(HomeApiService(), permanent: true);
  Get.put<HomeController>(HomeController(Get.find<HomeApiService>()), permanent: true);

  runApp(const FlipkartCloneApp());
}

class FlipkartCloneApp extends StatelessWidget {
  const FlipkartCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flipkart Home Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.brandBlue),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(name: '/home', page: () => const HomePage()),
      ],
    );
  }
}
