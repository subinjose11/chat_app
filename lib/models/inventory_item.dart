import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

@freezed
class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    @Default('') String id,
    required String name,
    required String partNumber,
    String? description,
    @Default(0) int quantity,
    @Default(0) int minStockLevel,
    required double unitPrice,
    String? supplier,
    String? category, // engine, brake, electrical, body, fluid, etc.
    String? location, // shelf/bin location
    DateTime? lastRestocked,
    DateTime? createdAt,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
}

