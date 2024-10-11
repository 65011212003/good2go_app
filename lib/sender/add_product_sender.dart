import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:good2go_app/providers/delivery_provider.dart';

class AddProductSenderController extends GetxController {
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  final Rx<File?> image = Rx<File?>(null);

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  void addProduct() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a product name');
      return;
    }

    final deliveryProvider = Get.find<DeliveryNotifier>();
    deliveryProvider.addItem(
      DeliveryItem(
        itemName: nameController.text,
        itemDescription: detailsController.text,
        itemPhoto: image.value,
      ),
    );

    Get.snackbar('Success', 'Product added successfully');
    Get.back();
  }
}

class AddProductSender extends GetView<AddProductSenderController> {
  const AddProductSender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductSenderController());

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
                    'สินค้าของคุณ',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.getImage(ImageSource.gallery),
                              icon: const Icon(Icons.image, color: Colors.white),
                              label: const Text('เลือกรูป', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xBF5300F9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.getImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt, color: Colors.white),
                              label: const Text('ถ่ายรูป', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xBF5300F9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Product Image
                      Center(
                        child: Obx(() => controller.image.value != null
                            ? Image.file(
                                controller.image.value!,
                                height: 200,
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                'https://m.media-amazon.com/images/I/81hyQ4lDygL._AC_UF894,1000_QL80_.jpg', // Replace with actual image URL
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Product Details
                      const Text(
                        'รายละเอียดสินค้า',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: controller.detailsController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Product Name
                      TextField(
                        controller: controller.nameController,
                        decoration: const InputDecoration(
                          labelText: 'ชื่อสินค้า',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Get.back(),
                              child: const Text('ยกเลิก', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controller.addProduct,
                              child: const Text('เพิ่ม', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
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