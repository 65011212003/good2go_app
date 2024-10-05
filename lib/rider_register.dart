import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:good2go_app/services/apiServices.dart';

class RiderRegister extends ConsumerStatefulWidget {
  const RiderRegister({super.key});

  @override
  ConsumerState<RiderRegister> createState() => _RiderRegisterState();
}

class _RiderRegisterState extends ConsumerState<RiderRegister> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _vehicleRegistrationController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _vehicleRegistrationController.dispose();
    super.dispose();
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
          'vehicle_registration': _vehicleRegistrationController.text,
          'user_type': 'rider',
        };
        await apiService.createUser(userData);
        // Handle successful registration
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ลงทะเบียนสำเร็จ')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        // Handle registration error
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
                                  'สมัครสมาชิก(ไรเดอร์)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildTextField('เบอร์โทรศัพท์', _phoneController),
                                _buildTextField('ชื่อ - สกุล', _nameController),
                                _buildTextField('รหัสผ่าน', _passwordController, isPassword: true),
                                _buildTextField('ยืนยันรหัสผ่าน', _confirmPasswordController, isPassword: true),
                                _buildTextField('ที่อยู่', _addressController, maxLines: 3),
                                _buildTextField('ทะเบียนรถ', _vehicleRegistrationController),
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
                          Navigator.pop(context);
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
          if (isPassword && controller == _confirmPasswordController) {
            if (value != _passwordController.text) {
              return 'รหัสผ่านไม่ตรงกัน';
            }
          }
          return null;
        },
      ),
    );
  }
}