import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:good2go_app/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good2go_app/services/apiServices.dart';

class UserRegister extends ConsumerStatefulWidget {
  const UserRegister({super.key});

  @override
  ConsumerState<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends ConsumerState<UserRegister> {
  final _formKey = GlobalKey<FormState>();
  LatLng _selectedLocation = LatLng(13.7563, 100.5018); // Default to Bangkok
  File? _image;
  final picker = ImagePicker();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final apiService = ref.read(apiServiceProvider);
        final userData = {
          'phone_number': _phoneController.text,
          'name': _nameController.text,
          'password': _passwordController.text,
          'address': _addressController.text,
          'latitude': _selectedLocation.latitude,
          'longitude': _selectedLocation.longitude,
          'user_type': 'user',
        };
        await apiService.createUser(userData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ลงทะเบียนสำเร็จ')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
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
                            key: _formKey,
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
                                _buildTextField('เบอร์โทรศัพท์', _phoneController),
                                _buildTextField('ชื่อ - สกุล', _nameController),
                                _buildTextField('รหัสผ่าน', _passwordController, isPassword: true),
                                _buildTextField('ยืนยันรหัสผ่าน', _confirmPasswordController, isPassword: true),
                                _buildTextField('ที่อยู่', _addressController, maxLines: 3),
                                _buildLocationMap(),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: _register,
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
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
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
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[200],
          backgroundImage: _image != null ? FileImage(_image!) : null,
          child: _image == null
              ? Icon(Icons.person, size: 50, color: Colors.grey[800])
              : null,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => getImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('กล้อง'),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () => getImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('แกลเลอรี่'),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false, int maxLines = 1}) {
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
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
          FlutterMap(
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 13.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _selectedLocation,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () async {
                try {
                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high
                  );
                  setState(() {
                    _selectedLocation = LatLng(position.latitude, position.longitude);
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ไม่สามารถระบุตำแหน่งได้: $e')),
                  );
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}