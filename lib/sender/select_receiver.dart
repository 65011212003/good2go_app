import 'package:flutter/material.dart';
import 'package:good2go_app/receiver/delivery_detail.dart';
// ignore: unused_import
import 'package:good2go_app/sender/add_product_sender.dart';
// ignore: unused_import
import 'package:good2go_app/sender/picture_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good2go_app/services/apiServices.dart';

class SelectReceiver extends ConsumerStatefulWidget {
  const SelectReceiver({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectReceiver> createState() => _SelectReceiverState();
}

class _SelectReceiverState extends ConsumerState<SelectReceiver> {
  List<Map<String, dynamic>> receivers = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchReceivers();
  }

  Future<void> fetchReceivers() async {
    try {
      final apiService = ref.read(apiServiceProvider);
      final fetchedReceivers = await apiService.getAllUsers();
      setState(() {
        receivers = fetchedReceivers;
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch receivers: $e');
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<Map<String, dynamic>> get filteredReceivers {
    return receivers.where((receiver) {
      final name = receiver['name'].toString().toLowerCase();
      final phone = receiver['phone_number'].toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return name.contains(query) || phone.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () => Navigator.pop(context),
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
                        onChanged: updateSearchQuery,
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
              child: ListView.builder(
                itemCount: filteredReceivers.length,
                itemBuilder: (context, index) {
                  return ReceiverCard(receiver: filteredReceivers[index]);
                },
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

class ReceiverCard extends StatelessWidget {
  final Map<String, dynamic> receiver;

  const ReceiverCard({Key? key, required this.receiver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeliveryDetail(receiver: receiver)),
                );
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