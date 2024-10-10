import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class DeliveryItem {
  final String itemName;
  final String? itemDescription;
  final File? itemPhoto;

  DeliveryItem({required this.itemName, this.itemDescription, this.itemPhoto});
}

class DeliveryState {
  final List<DeliveryItem> items;
  final File? deliveryPhoto;

  DeliveryState({required this.items, this.deliveryPhoto});

  DeliveryState copyWith({List<DeliveryItem>? items, File? deliveryPhoto}) {
    return DeliveryState(
      items: items ?? this.items,
      deliveryPhoto: deliveryPhoto ?? this.deliveryPhoto,
    );
  }
}

class DeliveryNotifier extends StateNotifier<DeliveryState> {
  DeliveryNotifier() : super(DeliveryState(items: []));

  void addItem(DeliveryItem item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  void removeItem(int index) {
    final newItems = List<DeliveryItem>.from(state.items)..removeAt(index);
    state = state.copyWith(items: newItems);
  }

  void clearItems() {
    state = DeliveryState(items: []);
  }

  void setDeliveryPhoto(File photo) {
    state = state.copyWith(deliveryPhoto: photo);
  }
}

final deliveryProvider = StateNotifierProvider<DeliveryNotifier, DeliveryState>((ref) {
  return DeliveryNotifier();
});