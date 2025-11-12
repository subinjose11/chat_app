import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/models/inventory_item.dart';

final inventoryRepositoryProvider = Provider((ref) {
  return InventoryRepository(
    firestore: FirebaseFirestore.instance,
  );
});

final inventoryStreamProvider = StreamProvider.autoDispose<List<InventoryItem>>((ref) {
  return ref.read(inventoryRepositoryProvider).getInventoryStream();
});

final lowStockItemsStreamProvider = StreamProvider.autoDispose<List<InventoryItem>>((ref) {
  return ref.read(inventoryRepositoryProvider).getLowStockItemsStream();
});

class InventoryRepository {
  final FirebaseFirestore firestore;

  InventoryRepository({required this.firestore});

  // Create Inventory Item
  Future<void> createInventoryItem(BuildContext context, InventoryItem item) async {
    try {
      final docId = item.id.isNotEmpty
          ? item.id
          : firestore.collection('inventory').doc().id;
      final docRef = firestore.collection('inventory').doc(docId);
      final itemWithId = item.copyWith(
        id: docId,
        createdAt: DateTime.now(),
      );
      await docRef.set(itemWithId.toJson());
      if (context.mounted) {
        showSnackBar(context: context, content: 'Item added to inventory');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Get All Inventory Stream
  Stream<List<InventoryItem>> getInventoryStream() {
    return firestore
        .collection('inventory')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return InventoryItem.fromJson(doc.data());
      }).toList();
    });
  }

  // Get Low Stock Items Stream
  Stream<List<InventoryItem>> getLowStockItemsStream() {
    return firestore
        .collection('inventory')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => InventoryItem.fromJson(doc.data()))
          .where((item) => item.quantity <= item.minStockLevel)
          .toList();
    });
  }

  // Update Inventory Item
  Future<void> updateInventoryItem(BuildContext context, InventoryItem item) async {
    try {
      await firestore
          .collection('inventory')
          .doc(item.id)
          .update(item.toJson());
      if (context.mounted) {
        showSnackBar(context: context, content: 'Item updated successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Delete Inventory Item
  Future<void> deleteInventoryItem(BuildContext context, String itemId) async {
    try {
      await firestore.collection('inventory').doc(itemId).delete();
      if (context.mounted) {
        showSnackBar(context: context, content: 'Item deleted successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

  // Update Stock Quantity
  Future<void> updateStock(BuildContext context, String itemId, int newQuantity) async {
    try {
      await firestore.collection('inventory').doc(itemId).update({
        'quantity': newQuantity,
        'lastRestocked': DateTime.now().toIso8601String(),
      });
      if (context.mounted) {
        showSnackBar(context: context, content: 'Stock updated successfully');
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }
}

