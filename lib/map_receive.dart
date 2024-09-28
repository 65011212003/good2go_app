import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:timeline_tile/timeline_tile.dart';

class MapReceive extends StatefulWidget {
  const MapReceive({Key? key}) : super(key: key);

  @override
  State<MapReceive> createState() => _MapReceiveState();
}

class _MapReceiveState extends State<MapReceive> {
  final MapController mapController = MapController();

  final latlong.LatLng _center = latlong.LatLng(13.7563, 100.5018); // Bangkok coordinates

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Receiver Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ผู้รับ : Joe', style: TextStyle(fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'โอนสินค้าสำเร็จ',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Map
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: _center,
                            initialZoom: 11.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
                              userAgentPackageName: 'com.example.app',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Tracking ID
                      const Text('Tracking ID #16623566', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      
                      // Timeline
                      _buildTimeline(),
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

  Widget _buildTimeline() {
    return Column(
      children: [
        _buildTimelineTile(
          isFirst: true,
          isLast: false,
          eventTitle: '21/9/2567 เวลา 10:00 โอนสินค้าสำเร็จ',
          imagePath: 'assets/images/delivery_man.jpg',
          indicatorColor: Colors.green,
        ),
        _buildTimelineTile(
          isFirst: false,
          isLast: false,
          eventTitle: '21/9/2567 เวลา 10:00 ส่งรถบรรทุก',
          imagePath: null,
          indicatorColor: Colors.green,
        ),
        _buildTimelineTile(
          isFirst: false,
          isLast: false,
          eventTitle: '21/9/2567 เวลา 10:00 ส่งรถบรรทุกในพื้นที่และเตรียมจัดส่งสินค้า',
          imagePath: 'assets/images/delivery_man.jpg',
          indicatorColor: Colors.red,
        ),
        _buildTimelineTile(
          isFirst: false,
          isLast: true,
          eventTitle: '21/9/2567 เวลา 10:00 โอนสินค้าสำเร็จ',
          imagePath: 'assets/images/delivery_man.jpg',
          indicatorColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildTimelineTile({
    required bool isFirst,
    required bool isLast,
    required String eventTitle,
    required String? imagePath,
    required Color indicatorColor,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: indicatorColor,
        padding: const EdgeInsets.all(6),
      ),
      endChild: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(eventTitle, style: const TextStyle(fontSize: 14)),
            ),
          ),
          if (imagePath != null)
            Image.asset(imagePath, width: 50, height: 50),
        ],
      ),
      beforeLineStyle: LineStyle(color: Colors.grey.shade300),
    );
  }
}