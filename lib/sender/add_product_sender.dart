import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good2go_app/app_data.dart';

class AddProductSenderController extends GetxController {
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  final Rx<File?> image = Rx<File?>(null);
  final RxString imageUrl = RxString('');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      await uploadImage(image.value!);
    }
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      String fileName = const Uuid().v4();
      Reference ref = _storage.ref().child('product_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrl.value = downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Failed to upload image. Please try again.');
    }
  }

  Future<void> deleteImage() async {
    if (imageUrl.isNotEmpty) {
      try {
        await FirebaseStorage.instance.refFromURL(imageUrl.value).delete();
        imageUrl.value = '';
        image.value = null;
      } catch (e) {
        print('Error deleting image: $e');
        Get.snackbar('Error', 'Failed to delete image. Please try again.');
      }
    }
  }

  void addProduct(WidgetRef ref) async {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a product name');
      return;
    }

    final appDataNotifier = ref.read(appDataProvider.notifier);
    DeliveryItem newItem = DeliveryItem(
      itemName: nameController.text,
      itemDescription: detailsController.text,
      itemPhotoUrl: imageUrl.value,
    );

    // Add to Firestore
    try {
      await _firestore.collection('products').add({
        'name': newItem.itemName,
        'description': newItem.itemDescription,
        'imageUrl': imageUrl.value,
        'createdAt': FieldValue.serverTimestamp(),
      });

      appDataNotifier.addTempDeliveryItem(newItem);

      Get.snackbar('Success', 'Product added successfully');
      Get.back(result: true);
    } catch (e) {
      print('Error adding product to Firestore: $e');
      Get.snackbar('Error', 'Failed to add product. Please try again.');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    detailsController.dispose();
    super.onClose();
  }
}

class AddProductSender extends ConsumerWidget {
  const AddProductSender({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        child: Obx(() => controller.imageUrl.isNotEmpty
                            ? Image.network(
                                controller.imageUrl.value,
                                height: 200,
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                'https://m.media-amazon.com/images/I/81hyQ4lDygL._AC_UF894,1000_QL80_.jpg', // Replace with actual placeholder image URL
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
                              onPressed: () {
                                controller.deleteImage();
                                Get.back();
                              },
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
                              onPressed: () {
                                controller.addProduct(ref);
                              },
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