import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good2go_app/receiver/delivery_detail.dart';
import 'package:good2go_app/services/apiServices.dart';
import 'dart:developer' as developer;

class SelectReceiverController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  RxList<Map<String, dynamic>> receivers = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReceivers();
  }

  Future<void> fetchReceivers() async {
    try {
      final fetchedReceivers = await apiService.getAllUsers();
      receivers.assignAll(fetchedReceivers);
      developer.log('Successfully fetched ${fetchedReceivers.length} receivers');
    } catch (e) {
      developer.log('Failed to fetch receivers: $e');
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    developer.log('Search query updated: $query');
  }

  List<Map<String, dynamic>> get filteredReceivers {
    final filtered = receivers.where((receiver) {
      final name = receiver['name'].toString().toLowerCase();
      final phone = receiver['phone_number'].toString().toLowerCase();
      final query = searchQuery.value.toLowerCase();
      return name.contains(query) || phone.contains(query);
    }).toList();
    developer.log('Filtered receivers: ${filtered.length}');
    return filtered;
  }
}

class SelectReceiver extends GetView<SelectReceiverController> {
  const SelectReceiver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SelectReceiverController());
    developer.log('Building SelectReceiver widget');

    return Scaffold(
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
                    onPressed: () {
                      developer.log('Back button pressed');
                      Get.back();
                    },
                  ),
                  const Text(
                    'เบอร์โทรศัพท์ผู้รับ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          developer.log('Search text changed: $value');
                          controller.updateSearchQuery(value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xBF5300F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.menu, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // List of Receivers
            Expanded(
              child: Obx(() {
                developer.log('Rebuilding ListView with ${controller.filteredReceivers.length} items');
                return ListView.builder(
                  itemCount: controller.filteredReceivers.length,
                  itemBuilder: (context, index) {
                    return ReceiverCard(receiver: controller.filteredReceivers[index]);
                  },
                );
              }),
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
                    onPressed: () {
                      developer.log('Home button pressed');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.white),
                    onPressed: () {
                      developer.log('Person button pressed');
                    },
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

class ReceiverCard extends StatelessWidget {
  final Map<String, dynamic> receiver;

  const ReceiverCard({Key? key, required this.receiver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    developer.log('Building ReceiverCard for ${receiver['name']}');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xBF5300F9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(receiver['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('ที่อยู่รับ :'),
                  Text(receiver['address']),
                  Text('โทรศัพท์ : ${receiver['phone_number']}'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                developer.log('Send button pressed for ${receiver['name']}');
                Get.to(() => DeliveryDetail(receiver: receiver));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('ส่งสินค้า', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}