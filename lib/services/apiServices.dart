    // Start Generation Here
    import 'dart:convert';
    import 'package:http/http.dart' as http;

    class ApiService {
      final String baseUrl = 'https://rider-version2.onrender.com';

      // Create a new user
      Future<UserCreate> createUser(UserCreate user) async {
        final response = await http.post(
          Uri.parse('$baseUrl/users/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(user.toJson()),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          return UserCreate.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to create user');
        }
      }

      // Create a new rider
      Future<RiderCreate> createRider(RiderCreate rider) async {
        final response = await http.post(
          Uri.parse('$baseUrl/riders/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(rider.toJson()),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          return RiderCreate.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to create rider');
        }
      }

      // Create a new delivery
      Future<DeliveryResponse> createDelivery(DeliveryCreate delivery) async {
        final response = await http.post(
          Uri.parse('$baseUrl/deliveries/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(delivery.toJson()),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          return DeliveryResponse.fromJson(jsonDecode(response.body));
        } else {
          throw Exception('Failed to create delivery');
        }
      }

      // Upload waiting photo
      Future<void> uploadWaitingPhoto(int deliveryId, String filePath) async {
        var uri = Uri.parse('$baseUrl/deliveries/$deliveryId/waiting_photo');
        var request = http.MultipartRequest('POST', uri);
        request.files.add(await http.MultipartFile.fromPath('photo', filePath));

        var response = await request.send();

        if (response.statusCode != 200) {
          throw Exception('Failed to upload waiting photo');
        }
      }

      // Get incoming deliveries for a user
      Future<List<DeliveryResponse>> getIncomingDeliveries(int userId) async {
        final response = await http.get(
          Uri.parse('$baseUrl/users/$userId/incoming_deliveries'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          Iterable list = jsonDecode(response.body);
          return list.map((json) => DeliveryResponse.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch incoming deliveries');
        }
      }

      // Get delivery status
      Future<String> getDeliveryStatus(int deliveryId) async {
        final response = await http.get(
          Uri.parse('$baseUrl/deliveries/$deliveryId/status'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          return data['status'];
        } else {
          throw Exception('Failed to fetch delivery status');
        }
      }

      // Get rider info for a delivery
      Future<RiderInfo?> getDeliveryRiderInfo(int deliveryId) async {
        final response = await http.get(
          Uri.parse('$baseUrl/deliveries/$deliveryId/rider_info'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          return RiderInfo.fromJson(jsonDecode(response.body));
        } else if (response.statusCode == 400) {
          // Handle specific error if needed
          return null;
        } else {
          throw Exception('Failed to fetch rider info');
        }
      }

      // Get available deliveries
      Future<List<DeliveryResponse>> getAvailableDeliveries() async {
        final response = await http.get(
          Uri.parse('$baseUrl/deliveries/available'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          Iterable list = jsonDecode(response.body);
          return list.map((json) => DeliveryResponse.fromJson(json)).toList();
        } else {
          throw Exception('Failed to fetch available deliveries');
        }
      }

      // Rider accepts a delivery
      Future<void> acceptDelivery(int riderId, int deliveryId) async {
        final response = await http.post(
          Uri.parse('$baseUrl/riders/$riderId/accept_delivery/$deliveryId'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to accept delivery');
        }
      }

      // Update delivery status
      Future<void> updateDeliveryStatus(int riderId, String status) async {
        final response = await http.post(
          Uri.parse('$baseUrl/riders/$riderId/update_delivery_status'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'status': status}),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update delivery status');
        }
      }

      // Upload delivery photo
      Future<void> uploadDeliveryPhoto(int riderId, String status, String filePath) async {
        var uri = Uri.parse('$baseUrl/riders/$riderId/upload_photo');
        var request = http.MultipartRequest('POST', uri);
        request.fields['status'] = status;
        request.files.add(await http.MultipartFile.fromPath('photo', filePath));

        var response = await request.send();

        if (response.statusCode != 200) {
          throw Exception('Failed to upload delivery photo');
        }
      }

      // Get rider's current delivery
      Future<DeliveryResponse?> getRiderCurrentDelivery(int riderId) async {
        final response = await http.get(
          Uri.parse('$baseUrl/riders/$riderId/current_delivery'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data != null) {
            return DeliveryResponse.fromJson(data);
          }
          return null;
        } else {
          throw Exception('Failed to fetch current delivery');
        }
      }

      // Update rider location
      Future<void> updateRiderLocation(int riderId, double latitude, double longitude) async {
        final response = await http.put(
          Uri.parse('$baseUrl/riders/$riderId/location'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update rider location');
        }
      }
    }

    // Models
    class UserCreate {
      final String phoneNumber;
      final String password;
      final String name;
      final String profilePicture;
      final String address;
      final double gpsLatitude;
      final double gpsLongitude;

      UserCreate({
        required this.phoneNumber,
        required this.password,
        required this.name,
        required this.profilePicture,
        required this.address,
        required this.gpsLatitude,
        required this.gpsLongitude,
      });

      Map<String, dynamic> toJson() => {
            'phone_number': phoneNumber,
            'password': password,
            'name': name,
            'profile_picture': profilePicture,
            'address': address,
            'gps_latitude': gpsLatitude,
            'gps_longitude': gpsLongitude,
          };

      factory UserCreate.fromJson(Map<String, dynamic> json) => UserCreate(
            phoneNumber: json['phone_number'],
            password: json['password'],
            name: json['name'],
            profilePicture: json['profile_picture'],
            address: json['address'],
            gpsLatitude: json['gps_latitude'],
            gpsLongitude: json['gps_longitude'],
          );
    }

    class RiderCreate {
      final String phoneNumber;
      final String password;
      final String name;
      final String profilePicture;
      final String vehiclePlate;

      RiderCreate({
        required this.phoneNumber,
        required this.password,
        required this.name,
        required this.profilePicture,
        required this.vehiclePlate,
      });

      Map<String, dynamic> toJson() => {
            'phone_number': phoneNumber,
            'password': password,
            'name': name,
            'profile_picture': profilePicture,
            'vehicle_plate': vehiclePlate,
          };

      factory RiderCreate.fromJson(Map<String, dynamic> json) => RiderCreate(
            phoneNumber: json['phone_number'],
            password: json['password'],
            name: json['name'],
            profilePicture: json['profile_picture'],
            vehiclePlate: json['vehicle_plate'],
          );
    }

    class DeliveryCreate {
      final String senderPhone;
      final String receiverPhone;
      final String itemName;
      final String itemDescription;
      final String itemPhoto;

      DeliveryCreate({
        required this.senderPhone,
        required this.receiverPhone,
        required this.itemName,
        required this.itemDescription,
        required this.itemPhoto,
      });

      Map<String, dynamic> toJson() => {
            'sender_phone': senderPhone,
            'receiver_phone': receiverPhone,
            'item_name': itemName,
            'item_description': itemDescription,
            'item_photo': itemPhoto,
          };

      factory DeliveryCreate.fromJson(Map<String, dynamic> json) => DeliveryCreate(
            senderPhone: json['sender_phone'],
            receiverPhone: json['receiver_phone'],
            itemName: json['item_name'],
            itemDescription: json['item_description'],
            itemPhoto: json['item_photo'],
          );
    }

    class DeliveryResponse {
      final int id;
      final String status;
      final DateTime createdAt;
      final String itemName;
      final String itemDescription;
      final String itemPhoto;
      final UserCreate sender;
      final UserCreate receiver;
      final RiderResponse? rider;

      DeliveryResponse({
        required this.id,
        required this.status,
        required this.createdAt,
        required this.itemName,
        required this.itemDescription,
        required this.itemPhoto,
        required this.sender,
        required this.receiver,
        this.rider,
      });

      factory DeliveryResponse.fromJson(Map<String, dynamic> json) => DeliveryResponse(
            id: json['id'],
            status: json['status'],
            createdAt: DateTime.parse(json['created_at']),
            itemName: json['item_name'],
            itemDescription: json['item_description'],
            itemPhoto: json['item_photo'],
            sender: UserCreate.fromJson(json['sender']),
            receiver: UserCreate.fromJson(json['receiver']),
            rider: json['rider'] != null ? RiderResponse.fromJson(json['rider']) : null,
          );
    }

    class RiderResponse {
      final int id;
      final String name;
      final String phoneNumber;
      final String profilePicture;
      final String vehiclePlate;
      final double currentLatitude;
      final double currentLongitude;
      final bool isAvailable;
      final int? currentDeliveryId;

      RiderResponse({
        required this.id,
        required this.name,
        required this.phoneNumber,
        required this.profilePicture,
        required this.vehiclePlate,
        required this.currentLatitude,
        required this.currentLongitude,
        required this.isAvailable,
        this.currentDeliveryId,
      });

      factory RiderResponse.fromJson(Map<String, dynamic> json) => RiderResponse(
            id: json['id'],
            name: json['name'],
            phoneNumber: json['phone_number'],
            profilePicture: json['profile_picture'],
            vehiclePlate: json['vehicle_plate'],
            currentLatitude: json['current_latitude'],
            currentLongitude: json['current_longitude'],
            isAvailable: json['is_available'],
            currentDeliveryId: json['current_delivery_id'],
          );
    }

    class RiderInfo {
      final int riderId;
      final String name;
      final String phoneNumber;
      final String vehiclePlate;
      final double currentLatitude;
      final double currentLongitude;

      RiderInfo({
        required this.riderId,
        required this.name,
        required this.phoneNumber,
        required this.vehiclePlate,
        required this.currentLatitude,
        required this.currentLongitude,
      });

      factory RiderInfo.fromJson(Map<String, dynamic> json) => RiderInfo(
            riderId: json['rider_id'],
            name: json['name'],
            phoneNumber: json['phone_number'],
            vehiclePlate: json['vehicle_plate'],
            currentLatitude: json['current_latitude'],
            currentLongitude: json['current_longitude'],
          );
    }
