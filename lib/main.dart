import 'package:flutter/material.dart';
import 'package:good2go_app/rider/rider_home.dart';
import 'package:good2go_app/sender/sender_home.dart';
import 'package:good2go_app/register_chose.dart';
import 'package:good2go_app/services/apiServices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:provider/provider.dart' as provider;
import 'package:get/get.dart';

void main() {
  runApp(
    riverpod.ProviderScope(
      child: provider.ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: const MyApp(),
      ),
    ),
  );
}

class AppState extends ChangeNotifier {
  // Add your app state variables and methods here
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Good2Go',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const LoginPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6E6FA), // Light lavender
              Color(0xFF5300F9), // Deep purple
            ],
          ),
        ),
        child: const Center(
          child: Text(
            'Good2Go',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final apiService = Get.find<ApiService>();
      final user = await apiService.login(
        phoneController.text,
        passwordController.text,
      );
      if (user['is_rider']) {
        Get.off(() => const RiderHome());
      } else {
        Get.off(() => const SenderHome());
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6E6FA), // Light lavender
              Color(0xFF5300F9), // Deep purple
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Good2Go',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller.phoneController,
                        decoration: const InputDecoration(
                          labelText: 'เบอร์โทรศัพท์',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontFamily: 'Roboto'),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controller.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'รหัสผ่าน',
                          border: OutlineInputBorder(),
                          labelStyle: TextStyle(fontFamily: 'Roboto'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: controller.login,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF5300F9),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(fontFamily: 'Roboto'),
                              ),
                            )),
                      const SizedBox(height: 10),
                      Obx(() => controller.errorMessage.value != null
                          ? Text(
                              controller.errorMessage.value!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontFamily: 'Roboto',
                              ),
                            )
                          : const SizedBox.shrink()),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const RegisterSelectPage());
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF5300F9),
                        ),
                        child: const Text(
                          'สมัครสมาชิก',
                          style: TextStyle(fontFamily: 'Roboto'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
