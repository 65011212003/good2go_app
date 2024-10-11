import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:good2go_app/sender/add_product_sender.dart';
import 'package:good2go_app/sender/picture_sender.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good2go_app/app_data.dart';
import 'dart:developer' as developer;

class DeliveryDetail extends ConsumerWidget {
  final Map<String, dynamic> receiver;

  DeliveryDetail({Key? key, required this.receiver}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appData = ref.watch(appDataProvider);

    // Add print statements for debugging
    developer.log('Building DeliveryDetail');
    developer.log('Receiver: $receiver');
    developer.log('AppData: $appData');
    developer.log('TempDeliveryItems: ${appData.tempDeliveryItems}');

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
                                child: receiver['profile_picture'] != null && receiver['profile_picture'].isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.network(
                                          receiver['profile_picture'],
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                        ),
                                      )
                                    : const Icon(Icons.person, color: Colors.white, size: 40),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(receiver['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const Text('ที่อยู่รับ :'),
                                    Text(receiver['address']),
                                    Text('โทรศัพท์ : ${receiver['phone_number']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Status Icons using EasyStepper
                      EasyStepper(
                        activeStep: 0,
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
                        onStepReached: (index) {},
                      ),
                      const SizedBox(height: 24),
                      
                      // Delivery Items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('รายการจัดส่ง (${appData.tempDeliveryItems.length})', style: TextStyle(fontSize: 16)),
                          ElevatedButton.icon(
                            onPressed: () async {
                              developer.log('Adding new product');
                              final result = await Get.to(() => const AddProductSender());
                              developer.log('Result from AddProductSender: $result');
                              if (result == true) {
                                // Refresh the list if a new item was added
                                ref.refresh(appDataProvider);
                                developer.log('AppData refreshed');
                              }
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('เพิ่ม', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Display the list of added items
                      Consumer(
                        builder: (context, ref, child) {
                          final appData = ref.watch(appDataProvider);
                          developer.log('Rebuilding ListView: ${appData.tempDeliveryItems.length} items');
                          return appData.tempDeliveryItems.isEmpty
                              ? Text('No items added yet.', style: TextStyle(fontSize: 16))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: appData.tempDeliveryItems.length,
                                  itemBuilder: (context, index) {
                                    final item = appData.tempDeliveryItems[index];
                                    developer.log('Building item: $item');
                                    return Card(
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        leading: item.itemPhotoUrl != null && item.itemPhotoUrl!.isNotEmpty
                                            ? Image.network(item.itemPhotoUrl!, width: 50, height: 50, fit: BoxFit.cover)
                                            : Icon(Icons.image_not_supported),
                                        title: Text(item.itemName),
                                        subtitle: Text(item.itemDescription ?? ''),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            final appDataNotifier = ref.read(appDataProvider.notifier);
                                            appDataNotifier.removeTempDeliveryItem(index);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Send Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => PictureSender());
                  },
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('ส่งสินค้า', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xBF5300F9),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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