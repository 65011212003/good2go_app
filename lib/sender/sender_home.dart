import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good2go_app/app_data.dart';
import 'package:good2go_app/edit_profile.dart';
import 'package:good2go_app/sender/send_package.dart';
import 'package:good2go_app/services/apiServices.dart';

class SenderHomeController extends GetxController {
  final apiService = Get.find<ApiService>();
  final username = ''.obs;
  final profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final appData = Get.find<AppData>();
      final userData = await apiService.getUser(int.parse(appData.userId));
      username.value = userData['username'] ?? 'Username';
      profileImageUrl.value = userData['profileImageUrl'] ?? '';
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}

class SenderHome extends GetView<SenderHomeController> {
  const SenderHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderHomeController());

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'good2go',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.to(() => const EditProfile()),
                            child: Obx(() => CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              backgroundImage: controller.profileImageUrl.isNotEmpty
                                  ? NetworkImage(controller.profileImageUrl.value)
                                  : null,
                              child: controller.profileImageUrl.isEmpty
                                  ? const Icon(Icons.person_outline, color: Colors.black)
                                  : null,
                            )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Order your favourite food!',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Get ready'),
                            const Text(
                              'Move on!',
                              style: TextStyle(
                                color: Color(0xBF5300F9), // 70% opacity
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: Color(0xBF5300F9), // 70% opacity
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '10\nmin',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Image.asset('assets/images/scooter.png', width: 60, height: 60),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Menus',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.person_outline, color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          Obx(() => Text(controller.username.value, style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => Get.to(() => const SendPackage()),
                            icon: const Icon(Icons.list_alt, color: Colors.white),
                            label: const Text('ส่งสินค้า', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xBF5300F9), // 70% opacity
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.check_box, color: Colors.white),
                            label: const Text('รับสินค้า', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xBF4CAF50), // 70% opacity
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 60,
              color: const Color(0xBF5300F9), // 70% opacity
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.home, color: Colors.white),
                  Icon(Icons.person, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}