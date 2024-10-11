import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good2go_app/sender/select_receiver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendPackageController extends GetxController {
  static const Color primaryColor = Color(0xBF5300F9);
  RxList<Map<String, dynamic>> packages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      final response = await http.get(Uri.parse('YOUR_API_ENDPOINT_HERE'));
      if (response.statusCode == 200) {
        packages.value = List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load packages');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load packages: $e');
    }
  }
}

class SendPackage extends GetView<SendPackageController> {
  const SendPackage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SendPackageController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Obx(() => Text(
                      'รายการจัดส่งสินค้าทั้งหมด (${controller.packages.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SendPackageController.primaryColor,
                      ),
                    )),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Get.to(() => const SelectReceiver()),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('เพิ่มรายการ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.packages.length,
                itemBuilder: (context, index) {
                  return buildCard(controller.packages[index]);
                },
              )),
            ),
            
            // Bottom Navigation
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
  
  Widget buildCard(Map<String, dynamic> package) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tracking ID',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ผู้ส่ง : ${package['sender_name']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '#${package['tracking_id']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ผู้รับ : ${package['receiver_name']}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'ที่อยู่ผู้รับ : ${package['receiver_address']}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'โทรศัพท์ : ${package['receiver_phone']}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'สิ่งของทั้งหมด',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Here you can add images if they are provided in the API response
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add functionality for confirming delivery
              },
              child: const Text('โอเคส่งสินค้าแล้ว'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const SizedBox(width: 4),
                Text('คนขับ : ${package['driver_name']}'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text('จัดส่งวันที่ : ${package['delivery_date']}'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text('ส่งถึงผู้รับ : ${package['estimated_arrival']}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}