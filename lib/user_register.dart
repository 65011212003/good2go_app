import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:good2go_app/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:good2go_app/services/apiServices.dart';

class UserRegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final selectedLocation = LatLng(13.7563, 100.5018).obs;
  final image = Rx<File?>(null);
  final picker = ImagePicker();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();
  final base64Image = RxnString();

  final apiService = Get.find<ApiService>();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
      base64Image.value = base64Encode(image.value!.readAsBytesSync());
    }
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      try {
        final userData = {
          'phone_number': phoneController.text,
          'password': passwordController.text,
          'name': nameController.text,
          'profile_picture': base64Image.value ?? '',
          'address': addressController.text,
          'gps_latitude': selectedLocation.value.latitude,
          'gps_longitude': selectedLocation.value.longitude,
        };
        await apiService.createUser(userData);
        Get.snackbar('สำเร็จ', 'ลงทะเบียนสำเร็จ');
        Get.back();
      } catch (e) {
        Get.snackbar('ข้อผิดพลาด', 'เกิดข้อผิดพลาด: ${e.toString()}');
      }
    }
  }

  void updateLocation(LatLng point) {
    selectedLocation.value = point;
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      selectedLocation.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar('ข้อผิดพลาด', 'ไม่สามารถระบุตำแหน่งได้: $e');
    }
  }
}

class UserRegister extends GetView<UserRegisterController> {
  const UserRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserRegisterController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6E6FA), // Light lavender
              Color(0xFF5300F9), // Deep purple
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: Get.height - Get.mediaQuery.padding.top,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Good2Go',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'สมัครสมาชิก(ผู้ใช้ทั่วไป)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildProfileImagePicker(),
                                _buildTextField('เบอร์โทรศัพท์', controller.phoneController),
                                _buildTextField('ชื่อ - สกุล', controller.nameController),
                                _buildTextField('รหัสผ่าน', controller.passwordController, isPassword: true),
                                _buildTextField('ยืนยันรหัสผ่าน', controller.confirmPasswordController, isPassword: true),
                                _buildTextField('ที่อยู่', controller.addressController, maxLines: 3),
                                _buildLocationMap(),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: controller.register,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF5300F9),
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('สมัครสมาชิก'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.off(() => const LoginPage()),
                        child: const Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Column(
      children: [
        Obx(() => CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: controller.image.value != null
                  ? FileImage(controller.image.value!)
                  : null,
              child: controller.image.value == null
                  ? Icon(Icons.person, size: 50, color: Colors.grey[800])
                  : null,
            )),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => controller.getImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('กล้อง'),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => controller.getImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('แกลเลอรี่'),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอก$label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLocationMap() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Obx(() => FlutterMap(
                options: MapOptions(
                  initialCenter: controller.selectedLocation.value,
                  initialZoom: 13.0,
                  onTap: (tapPosition, point) {
                    controller.updateLocation(point);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: controller.selectedLocation.value,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: controller.getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
