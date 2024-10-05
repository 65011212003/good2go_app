import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:good2go_app/sender/add_product_sender.dart';
import 'package:good2go_app/sender/picture_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good2go_app/services/apiServices.dart';

class DeliveryDetail extends ConsumerStatefulWidget {
  final Map<String, dynamic> receiver;

  const DeliveryDetail({Key? key, required this.receiver}) : super(key: key);

  @override
  ConsumerState<DeliveryDetail> createState() => _DeliveryDetailState();
}

class _DeliveryDetailState extends ConsumerState<DeliveryDetail> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    final apiService = ref.read(apiServiceProvider);

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
                    onPressed: () => Navigator.pop(context),
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
                                    Text(widget.receiver['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const Text('ที่อยู่รับ :'),
                                    Text(widget.receiver['address']),
                                    Text('โทรศัพท์ : ${widget.receiver['phone_number']}'),
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
                        activeStep: activeStep,
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
                        onStepReached: (index) => setState(() => activeStep = index),
                      ),
                      const SizedBox(height: 24),
                      
                      // Delivery Items
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('รายการจัดส่ง (0)', style: TextStyle(fontSize: 16)),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddProductSender()),
                              );
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
                  onPressed: () async {
                    try {
                      // Create delivery using API
                      Map<String, dynamic> deliveryData = {
                        'receiver_id': widget.receiver['id'],
                        // Add other necessary delivery data
                      };
                      await apiService.createDelivery(deliveryData);
                      
                      final createdDelivery = await apiService.createDelivery(deliveryData);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PictureSender(deliveryId: createdDelivery['id'], receiver: widget.receiver)),
                      );
                    } catch (e) {
                      // Handle error
                      print('Failed to create delivery: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create delivery: ${e.toString()}')),
                      );
                      // Show error message to user
                    }
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