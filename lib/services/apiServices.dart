import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Add this import to resolve the 'File' class issue

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


  Future<Map<String, dynamic>> updateUser(int userId, Map<String, dynamic> userData, {File? profilePicture}) async {
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/users/$userId'));

    // Add user data fields, only if they are not null or empty
    userData.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        request.fields[key] = value.toString();
      }
    });

    // Function to upload image to Imgur and get the link
    Future<String?> uploadImageToImgur(File image) async {
      final uri = Uri.parse('https://api.imgur.com/3/image');
      final imgurRequest = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Client-ID 3202ea3e39b8c9b';
      
      final file = await http.MultipartFile.fromPath('image', image.path);
      imgurRequest.files.add(file);

      try {
        final response = await imgurRequest.send();
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        
        if (response.statusCode == 200 && jsonResponse['success'] == true) {
          return jsonResponse['data']['link'];
        } else {
          print('Failed to upload image to Imgur: ${jsonResponse['data']['error']}');
          return null;
        }
      } catch (e) {
        print('Error uploading image to Imgur: $e');
        return null;
      }
    }

    // If profile picture is provided, upload it to Imgur first
    if (profilePicture != null) {
      try {
        String? imageUrl = await uploadImageToImgur(profilePicture);
        if (imageUrl != null) {
          request.fields['profile_picture'] = imageUrl;
        } else {
          throw Exception('Failed to upload image to Imgur');
        }
      } catch (e) {
        throw Exception('Error uploading image: $e');
      }
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else if (response.statusCode == 404) {
        throw Exception('User not found');
      } else {
        throw Exception('Failed to update user: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }
}
