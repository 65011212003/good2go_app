import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

final appDataProvider = StateNotifierProvider<AppDataNotifier, AppData>((ref) => AppDataNotifier());

class AppData {
  final String userId;
  final String username;
  final String userType;
  final String profileImageUrl;
  final List<DeliveryItem> tempDeliveryItems;

  AppData({
    this.userId = '',
    this.username = '',
    this.userType = '',
    this.profileImageUrl = '',
    List<DeliveryItem>? tempDeliveryItems,
  }) : tempDeliveryItems = tempDeliveryItems ?? [];

  AppData copyWith({
    String? userId,
    String? username,
    String? userType,
    String? profileImageUrl,
    List<DeliveryItem>? tempDeliveryItems,
  }) {
    return AppData(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      tempDeliveryItems: tempDeliveryItems ?? this.tempDeliveryItems,
    );
  }
}

class AppDataNotifier extends StateNotifier<AppData> {
  AppDataNotifier() : super(AppData());

  void setUserData({
    required String id,
    required String name,
    required String type,
    String? imageUrl,
  }) {
    state = state.copyWith(
      userId: id,
      username: name,
      userType: type,
      profileImageUrl: imageUrl ?? '',
    );
  }

  void clearUserData() {
    state = AppData();
  }

  void addTempDeliveryItem(DeliveryItem item) {
    developer.log('Adding temp delivery item: $item');
    state = state.copyWith(
      tempDeliveryItems: [...state.tempDeliveryItems, item],
    );
    developer.log('New state: $state');
  }

  void clearTempDeliveryItems() {
    state = state.copyWith(tempDeliveryItems: []);
  }

  void removeTempDeliveryItem(int index) {
    final updatedItems = List<DeliveryItem>.from(state.tempDeliveryItems);
    updatedItems.removeAt(index);
    state = state.copyWith(tempDeliveryItems: updatedItems);
  }
}

class DeliveryItem {
  final String itemName;
  final String? itemDescription;
  final String? itemPhotoUrl;

  DeliveryItem({
    required this.itemName,
    this.itemDescription,
    this.itemPhotoUrl,
  });

  @override
  String toString() {
    return 'DeliveryItem(itemName: $itemName, itemDescription: $itemDescription, itemPhotoUrl: $itemPhotoUrl)';
  }
}
