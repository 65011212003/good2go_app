import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good2go_app/services/apiServices.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final apiService = ref.read(apiServiceProvider);
    try {
      // Assuming you have the user ID stored somewhere, replace 1 with the actual user ID
      final userData = await apiService.getUser(1);
      setState(() {
        _userData = userData;
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5300F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Add settings functionality
            },
          ),
        ],
      ),
      body: _userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF5300F9), width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person, size: 80, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildImageButton(Icons.photo_library, 'เลือกรูป'),
                      const SizedBox(width: 20),
                      _buildImageButton(Icons.camera_alt, 'ถ่ายรูป'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField('Name', _userData!['name'] ?? ''),
                        _buildTextField('Email', _userData!['email'] ?? ''),
                        _buildTextField('Phone', _userData!['phone_number'] ?? ''),
                        _buildTextField('Delivery address', _userData!['address'] ?? ''),
                        _buildTextField('Password', '••••••••', isPassword: true),
                        const SizedBox(height: 20),
                        _buildGPSButton(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildEditProfileButton()),
                            const SizedBox(width: 20),
                            Expanded(child: _buildLogoutButton()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildImageButton(IconData icon, String label) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add functionality
      },
      icon: Icon(icon, color: const Color(0xFF5300F9)),
      label: Text(label, style: const TextStyle(color: Color(0xFF5300F9))),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
      ),
    );
  }

  Widget _buildTextField(String label, String value, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          hintText: value,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildGPSButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Add GPS functionality
      },
      icon: const Icon(Icons.gps_fixed),
      label: const Text('GPS'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5300F9).withOpacity(0.7),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        final apiService = ref.read(apiServiceProvider);
        try {
          // Assuming you have the updated user data
          await apiService.updateUser(_userData!['id'], _userData!);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $e')),
          );
        }
      },
      icon: const Icon(Icons.edit),
      label: const Text('Edit Profile'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5300F9).withOpacity(0.7),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: () {
        // Add logout functionality
      },
      icon: const Icon(Icons.logout),
      label: const Text('Log out'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF5300F9),
        side: BorderSide(color: const Color(0xFF5300F9).withOpacity(0.7)),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}