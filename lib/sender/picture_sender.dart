import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:good2go_app/sender/finish_sender.dart';

class PictureSender extends StatefulWidget {
  const PictureSender({Key? key}) : super(key: key);

  @override
  State<PictureSender> createState() => _PictureSenderState();
}

class _PictureSenderState extends State<PictureSender> {
  int activeStep = 1; // Set to 1 to highlight the second step (ภาพประกอบสินค้า)

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
                      
                      // Take Picture Button
                      ElevatedButton.icon(
                        onPressed: () {},
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://as1.ftcdn.net/v2/jpg/01/11/51/72/1000_F_111517271_ZPicjRen9mvIhf1BdwW3BIrLBabuLQKl.jpg', // Replace with actual image URL
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Create List Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FinishSender()),
                            );
                          },
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