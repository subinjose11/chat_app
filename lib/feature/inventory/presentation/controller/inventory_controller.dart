import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/feature/inventory/data/repository/inventory_repository.dart';
import 'package:chat_app/models/inventory_item.dart';

final inventoryControllerProvider = Provider((ref) {
  return InventoryController(
    inventoryRepository: ref.read(inventoryRepositoryProvider),
  );
});

class InventoryController {
  final InventoryRepository inventoryRepository;

  InventoryController({required this.inventoryRepository});

  void createInventoryItem(BuildContext context, InventoryItem item) {
    inventoryRepository.createInventoryItem(context, item);
  }

  void updateInventoryItem(BuildContext context, InventoryItem item) {
    inventoryRepository.updateInventoryItem(context, item);
  }

  void deleteInventoryItem(BuildContext context, String itemId) {
    inventoryRepository.deleteInventoryItem(context, itemId);
  }

  void updateStock(BuildContext context, String itemId, int newQuantity) {
    inventoryRepository.updateStock(context, itemId, newQuantity);
  }
}

