import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good2go_app/main.dart';
import 'package:good2go_app/rider_register.dart';
import 'package:good2go_app/services/apiServices.dart';
import 'package:good2go_app/user_register.dart';

class RegisterSelectPage extends StatelessWidget {
  const RegisterSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize ApiService
    Get.put(ApiService());

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildOptionCard(
                            icon: Icons.delivery_dining,
                            label: 'โรเดอร์',
                            onTap: () => Get.to(() => const RiderRegister()),
                          ),
                          _buildOptionCard(
                            icon: Icons.group,
                            label: 'ผู้ใช้ทั่วไป',
                            onTap: () => Get.to(() => const UserRegister()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Handle continue button press
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF5300F9),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('ดำเนินการต่อ'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Get.to(() => const LoginPage()),
                  child: const Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: const Color(0xFF5300F9)),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontFamily: 'Roboto')),
            ],
          ),
        ),
      ),
    );
  }
}
