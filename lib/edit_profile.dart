import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good2go_app/main.dart';
import 'package:good2go_app/providers/delivery_provider.dart';
import 'package:good2go_app/services/apiServices.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  Map<String, dynamic>? _userData;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final apiService = ref.read(apiServiceProvider);
    try {
      // Assuming you have the user ID stored somewhere, replace 1 with the actual user ID
      final userData = await apiService.getUser(1);
      setState(() {
        _userData = userData;
        _nameController.text = userData['name'] ?? '';
        _phoneController.text = userData['phone_number'] ?? '';
        _addressController.text = userData['address'] ?? '';
        // Don't set the password, as it's likely not returned from the API for security reasons
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch user data: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
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
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(_image!, fit: BoxFit.cover),
                            )
                          : _userData!['profile_picture'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    _userData!['profile_picture'],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person, size: 80, color: Colors.black54);
                                    },
                                  ),
                                )
                              : const Icon(Icons.person, size: 80, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildImageButton(Icons.photo_library, 'เลือกรูป', () => _getImage(ImageSource.gallery)),
                      const SizedBox(width: 20),
                      _buildImageButton(Icons.camera_alt, 'ถ่ายรูป', () => _getImage(ImageSource.camera)),
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
                        _buildTextField('Name', _nameController),
                        _buildTextField('Phone', _phoneController),
                        _buildTextField('Delivery address', _addressController),
                        _buildTextField('Password', _passwordController, isPassword: true),
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

  Widget _buildImageButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
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

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        final apiService = ref.read(apiServiceProvider);
        try {
          if (_userData == null || _userData!['id'] == null) {
            throw Exception('User data is not available');
          }
          final updatedUserData = {
            if (_nameController.text.isNotEmpty) 'name': _nameController.text,
            if (_phoneController.text.isNotEmpty) 'phone_number': _phoneController.text,
            if (_addressController.text.isNotEmpty) 'address': _addressController.text,
            if (_passwordController.text.isNotEmpty) 'password': _passwordController.text,
          };
          if (updatedUserData.isEmpty && _image == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No changes to update')),
            );
            return;
          }
          await apiService.updateUser(_userData!['id'], updatedUserData, profilePicture: _image);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        } catch (e) {
          String errorMessage = 'Failed to update profile';
          if (e.toString().contains('Failed to upload image to Imgur')) {
            errorMessage = 'Failed to upload profile picture. Please try again.';
          } else if (e.toString().contains('User not found')) {
            errorMessage = 'User not found. Please log in again.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
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
        // Reset providers
        ref.read(deliveryProvider.notifier).clearItems();
        // Add more provider resets here if needed

        // Perform logout
        // You may want to call a logout method from your auth service here

        // Navigate to login page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
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