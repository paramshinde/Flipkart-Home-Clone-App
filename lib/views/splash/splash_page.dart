
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/constants/app_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
      _startApp();
    });
  }

  Future<void> _startApp() async {
    final startedAt = DateTime.now();

    await Get.find<HomeController>().fetchHome();

    final elapsed = DateTime.now().difference(startedAt);
    final remaining = AppConstants.splashMinimumDuration - elapsed;

    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }

    if (mounted) Get.offNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE500),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_mark.png',
              width: MediaQuery.sizeOf(context).shortestSide * 0.31,
            ),

            const SizedBox(height: 18),

            const Text(
              'Flipkart',
              style: TextStyle(
                color: Color(0xFF1746B5),
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Shopping made easy',
              style: TextStyle(
                color: Color(0xFF1746B5),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 32),

            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF1746B5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
