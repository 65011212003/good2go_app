import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
 // Start of Selection
import 'dart:convert';
import 'dart:io';

final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  static const String baseUrl = 'https://your-fastapi-server-url.com';

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
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorBody = json.decode(response.body);
        if (errorBody['detail'] is List && errorBody['detail'].isNotEmpty) {
          final firstError = errorBody['detail'][0];
          throw Exception('Failed to create user: ${firstError['msg']} at ${firstError['loc'].join('.')}');
        } else {
          throw Exception('Failed to create user: ${response.body}');
        }
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  Future<Map<String, dynamic>> createDelivery(Map<String, dynamic> deliveryData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/deliveries/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(deliveryData),
    );

    if (response.statusCode == 201) { // Changed from 200 to 201 for resource creation
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create delivery: ${response.statusCode} - ${response.body}');
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

    userData.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        request.fields[key] = value.toString();
      }
    });

    if (profilePicture != null) {
      var profilePictureStream = http.ByteStream(profilePicture.openRead());
      var length = await profilePicture.length();
      var multipartFile = http.MultipartFile('profile_picture', profilePictureStream, length, filename: 'profile_picture.jpg');
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return json.decode(responseBody);
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to update user: ${response.statusCode} - $responseBody');
    }
  }

  Future<Map<String, dynamic>> addItem(Map<String, dynamic> itemData, File? itemImage) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/items'));

    itemData.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        request.fields[key] = value.toString();
      }
    });

    if (itemImage != null) {
      var itemImageStream = http.ByteStream(itemImage.openRead());
      var length = await itemImage.length();
      var multipartFile = http.MultipartFile('item_image', itemImageStream, length, filename: 'item_image.jpg');
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to add item: ${response.statusCode} - $responseBody');
    }
  }

  Future<Map<String, dynamic>> uploadWaitingPhoto(int deliveryId, List<int> photoBytes, String fileName) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/deliveries/$deliveryId/waiting_photo'));
    request.files.add(http.MultipartFile.fromBytes('photo', photoBytes, filename: fileName));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to upload waiting photo');
    }
  }

  Future<Map<String, dynamic>> createRider(Map<String, dynamic> riderData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/riders/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(riderData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create rider');
    }
  }

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> loginUser(String phoneNumber, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone_number': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createSending(int userId, Map<String, dynamic> sendingData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sendings/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        ...sendingData,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create sending: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getUserSendings(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId/sendings/'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to get user sendings: ${response.body}');
    }
  }

  Future<WebSocket> connectToRiderTracking() async {
    final wsUrl = Uri.parse('wss://your-fastapi-server-url.com/ws/track-riders');
    return await WebSocket.connect(wsUrl.toString());
  }
  }
