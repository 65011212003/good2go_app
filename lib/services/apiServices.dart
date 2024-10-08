import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  static const String baseUrl = 'https://rider-version2.onrender.com';

  Future<Map<String, dynamic>> login(String phoneNumber, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$phoneNumber:$password'))}'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 200) { // Changed from 200 to 201 for resource creation
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createDelivery(Map<String, dynamic> deliveryData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deliveries/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(deliveryData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create delivery');
    }
  }

  Future<List<Map<String, dynamic>>> getIncomingDeliveries(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId/incoming_deliveries'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to get incoming deliveries');
    }
  }

  Future<Map<String, dynamic>> getDeliveryStatus(int deliveryId) async {
    final response = await http.get(Uri.parse('$baseUrl/deliveries/$deliveryId/status'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get delivery status');
    }
  }

  Future<Map<String, dynamic>> getRiderInfo(int deliveryId) async {
    final response = await http.get(Uri.parse('$baseUrl/deliveries/$deliveryId/rider_info'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get rider info');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableDeliveries() async {
    final response = await http.get(Uri.parse('$baseUrl/deliveries/available'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to get available deliveries');
    }
  }

  Future<Map<String, dynamic>> acceptDelivery(int riderId, int deliveryId) async {
    final response = await http.post(Uri.parse('$baseUrl/riders/$riderId/accept_delivery/$deliveryId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to accept delivery');
    }
  }

  Future<Map<String, dynamic>> updateDeliveryStatus(int riderId, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/riders/$riderId/update_delivery_status'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update delivery status');
    }
  }

  Future<Map<String, dynamic>> uploadDeliveryPhoto(int riderId, String status, List<int> photoBytes, String fileName) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/riders/$riderId/upload_photo'));
    request.fields['status'] = status;
    request.files.add(http.MultipartFile.fromBytes('photo', photoBytes, filename: fileName));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to upload delivery photo');
    }
  }

  Future<Map<String, dynamic>?> getRiderCurrentDelivery(int riderId) async {
    final response = await http.get(Uri.parse('$baseUrl/riders/$riderId/current_delivery'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else {
      throw Exception('Failed to get rider current delivery');
    }
  }

  Future<Map<String, dynamic>> updateRiderLocation(int riderId, double latitude, double longitude) async {
    final response = await http.put(
      Uri.parse('$baseUrl/riders/$riderId/location'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'latitude': latitude, 'longitude': longitude}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update rider location');
    }
  }


  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      return usersJson.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get all users');
    }
  }

  Future<Map<String, dynamic>> getUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to get user');
    }
  }
  

}
