import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good2go_app/sender/send_package.dart';

class FinishSenderController extends GetxController {
  final int deliveryId;

  FinishSenderController({required this.deliveryId});

  void onConfirmPressed() {
    Get.off(() => const SendPackage());
  }
}

class FinishSender extends GetView<FinishSenderController> {
  const FinishSender({Key? key, required int deliveryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FinishSenderController(deliveryId: Get.arguments['deliveryId']));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  const Text(
                    'ข้อมูลการจัดส่งสินค้า',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // User Info Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5300F9),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(Icons.person, color: Colors.white, size: 40),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Username', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('ที่อยู่รับ :'),
                                    Text('999 หมู่ 10 อ.แห่งหนึ่ง'),
                                    Text('ต.หนึ่งแห่ง จ.นครสวรรค์'),
                                    Text('525456'),
                                    Text('โทรศัพท์ : 0899999999'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Status Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatusIcon(Icons.cable, 'รายการส่ง'),
                          _buildStatusDivider(),
                          _buildStatusIcon(Icons.camera_alt, 'ภาพประกอบสินค้า'),
                          _buildStatusDivider(),
                          _buildStatusIcon(Icons.check_circle, 'ส่งเสร็จ'),
                        ],
                      ),
                      const SizedBox(height: 40),
                      
                      // Checkmark Circle
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Success Text
                      const Text(
                        'สร้างรายการสำเร็จแล้ว!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.onConfirmPressed,
                          child: const Text('ตกลง', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5300F9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Navigation
            Container(
              height: 60,
              color: const Color(0xFF5300F9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFF5300F9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF5300F9))),
      ],
    );
  }

  Widget _buildStatusDivider() {
    return Container(
      width: 40,
      height: 1,
      color: const Color(0xFF5300F9),
    );
  }
}