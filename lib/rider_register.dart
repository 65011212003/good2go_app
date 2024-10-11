import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good2go_app/services/apiServices.dart';

class RiderRegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final addressController = TextEditingController();
  final vehicleRegistrationController = TextEditingController();

  final ApiService apiService = Get.find<ApiService>();

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    vehicleRegistrationController.dispose();
    super.onClose();
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      try {
        final userData = {
          'phone_number': phoneController.text,
          'name': nameController.text,
          'password': passwordController.text,
          'address': addressController.text,
          'vehicle_registration': vehicleRegistrationController.text,
          'user_type': 'rider',
        };
        await apiService.createUser(userData);
        Get.snackbar('สำเร็จ', 'ลงทะเบียนสำเร็จ');
        Get.back();
      } catch (e) {
        Get.snackbar('ข้อผิดพลาด', 'เกิดข้อผิดพลาด: ${e.toString()}');
      }
    }
  }
}

class RiderRegister extends GetView<RiderRegisterController> {
  const RiderRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RiderRegisterController());

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
                                  'สมัครสมาชิก(ไรเดอร์)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildTextField('เบอร์โทรศัพท์', controller.phoneController),
                                _buildTextField('ชื่อ - สกุล', controller.nameController),
                                _buildTextField('รหัสผ่าน', controller.passwordController, isPassword: true),
                                _buildTextField('ยืนยันรหัสผ่าน', controller.confirmPasswordController, isPassword: true),
                                _buildTextField('ที่อยู่', controller.addressController, maxLines: 3),
                                _buildTextField('ทะเบียนรถ', controller.vehicleRegistrationController),
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
                        onPressed: () => Get.back(),
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
          if (isPassword && controller == this.controller.confirmPasswordController) {
            if (value != this.controller.passwordController.text) {
              return 'รหัสผ่านไม่ตรงกัน';
            }
          }
          return null;
        },
      ),
    );
  }
}