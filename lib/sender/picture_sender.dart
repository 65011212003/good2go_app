import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:good2go_app/sender/finish_sender.dart';
import 'package:get/get.dart';
import 'package:good2go_app/services/apiServices.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PictureSenderController extends GetxController {
  final int deliveryId;
  final Map<String, dynamic> receiver;
  final RxInt activeStep = 1.obs;
  final Rx<File?> deliveryPhoto = Rx<File?>(null);
  final picker = ImagePicker();

  PictureSenderController({required this.deliveryId, required this.receiver});

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      deliveryPhoto.value = File(pickedFile.path);
    }
  }

  Future<void> createDelivery() async {
    if (deliveryPhoto.value == null) {
      Get.snackbar('Error', 'Please take a picture first');
      return;
    }

    try {
      final apiService = Get.find<ApiService>();
      Get.to(() => FinishSender(deliveryId: deliveryId));
    } catch (e) {
      Get.snackbar('Error', 'Failed to create delivery: $e');
    }
  }
}

class PictureSender extends GetView<PictureSenderController> {
  const PictureSender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // User Info Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xBF5300F9),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(Icons.person, color: Colors.white, size: 40),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(controller.receiver['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const Text('ที่อยู่รับ :'),
                                    Text(controller.receiver['address']),
                                    Text('โทรศัพท์ : ${controller.receiver['phone_number']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Status Icons using EasyStepper
                      Obx(() => EasyStepper(
                        activeStep: controller.activeStep.value,
                        stepShape: StepShape.circle,
                        stepBorderRadius: 15,
                        borderThickness: 2,
                        padding: const EdgeInsets.all(20),
                        stepRadius: 28,
                        finishedStepBorderColor: const Color(0xBF5300F9),
                        finishedStepTextColor: const Color(0xBF5300F9),
                        finishedStepBackgroundColor: const Color(0xBF5300F9),
                        activeStepIconColor: const Color(0xBF5300F9),
                        loadingAnimation: 'loading',
                        steps: const [
                          EasyStep(
                            icon: Icon(Icons.add_box_outlined),
                            title: 'รายการส่ง',
                          ),
                          EasyStep(
                            icon: Icon(Icons.camera_alt_outlined),
                            title: 'ภาพประกอบสินค้า',
                          ),
                          EasyStep(
                            icon: Icon(Icons.check_circle),
                            title: 'ส่งเสร็จ',
                          ),
                        ],
                        onStepReached: (index) => controller.activeStep.value = index,
                      )),
                      const SizedBox(height: 24),
                      
                      // Take Picture Button
                      ElevatedButton.icon(
                        onPressed: controller.getImage,
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text('ถ่ายใหม่อีกครั้ง', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xBF5300F9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Delivery Image
                      Obx(() => ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: controller.deliveryPhoto.value != null
                            ? Image.file(
                                controller.deliveryPhoto.value!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                'https://cdn.pixabay.com/photo/2017/11/10/05/24/add-2935429_960_720.png',
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      )),
                      const SizedBox(height: 24),
                      
                      // Create List Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.createDelivery,
                          child: const Text('สร้างรายการ', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xBF5300F9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
              color: const Color(0xBF5300F9),
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
}