import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/feature/inventory/data/repository/inventory_repository.dart';
import 'package:chat_app/feature/inventory/presentation/controller/inventory_controller.dart';
import 'package:chat_app/models/inventory_item.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inventoryAsync = ref.watch(inventoryStreamProvider);
    final lowStockAsync = ref.watch(lowStockItemsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          lowStockAsync.when(
            data: (items) => items.isNotEmpty
                ? Badge(
                    label: Text('${items.length}'),
                    child: IconButton(
                      icon: const Icon(Icons.warning_amber),
                      onPressed: () => _showLowStockDialog(context, items),
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: inventoryAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64,
                      color: isDark ? AppColors.gray600 : AppColors.gray400),
                  const SizedBox(height: 16),
                  Text('No Inventory Items', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.textPrimary)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isLowStock = item.quantity <= item.minStockLevel;
              
              return Container(
                key: ValueKey('inventory_${item.id}'),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isLowStock ? Border.all(color: AppColors.error, width: 2) : null,
                  boxShadow: [BoxShadow(
                      color: isDark ? Colors.black26 : AppColors.gray300.withOpacity(0.3),
                      blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(item.name, style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.white : AppColors.textPrimary)),
                              ),
                              if (isLowStock)
                                Icon(Icons.warning_amber, color: AppColors.error, size: 20),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('Part #: ${item.partNumber}', style: TextStyle(
                              fontSize: 12, color: isDark ? AppColors.gray400 : AppColors.textSecondary)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isLowStock
                                      ? AppColors.error.withOpacity(0.1)
                                      : AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('Qty: ${item.quantity}', style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold,
                                    color: isLowStock ? AppColors.error : AppColors.success)),
                              ),
                              const SizedBox(width: 8),
                              Text('\$${item.unitPrice.toStringAsFixed(2)}', style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.white : AppColors.textPrimary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primaryBlue,
                      onPressed: () => _showUpdateStockDialog(context, ref, item),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _showAddItemDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  void _showLowStockDialog(BuildContext context, List<InventoryItem> items) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Low Stock Alert'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) => ListTile(
            leading: const Icon(Icons.warning_amber, color: AppColors.error),
            title: Text(item.name),
            subtitle: Text('Quantity: ${item.quantity}'),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStockDialog(BuildContext context, WidgetRef ref, InventoryItem item) {
    final quantityController = TextEditingController(text: item.quantity.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock: ${item.name}'),
        content: TextField(
          controller: quantityController,
          decoration: const InputDecoration(labelText: 'New Quantity'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newQuantity = int.tryParse(quantityController.text) ?? item.quantity;
              ref.read(inventoryControllerProvider).updateStock(context, item.id, newQuantity);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final partNumberController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();
    final minStockController = TextEditingController(text: '10');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Inventory Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController,
                  decoration: const InputDecoration(labelText: 'Item Name')),
              const SizedBox(height: 16),
              TextField(controller: partNumberController,
                  decoration: const InputDecoration(labelText: 'Part Number')),
              const SizedBox(height: 16),
              TextField(controller: quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextField(controller: priceController,
                  decoration: const InputDecoration(labelText: 'Unit Price'),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextField(controller: minStockController,
                  decoration: const InputDecoration(labelText: 'Min Stock Level'),
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty || partNumberController.text.isEmpty) return;
              
              final item = InventoryItem(
                name: nameController.text,
                partNumber: partNumberController.text,
                quantity: int.tryParse(quantityController.text) ?? 0,
                unitPrice: double.tryParse(priceController.text) ?? 0,
                minStockLevel: int.tryParse(minStockController.text) ?? 10,
              );

              ref.read(inventoryControllerProvider).createInventoryItem(context, item);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

