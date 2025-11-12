import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chat_app/models/part_item.dart';
import 'package:chat_app/models/converters/part_item_list_converter.dart';

part 'service_order.freezed.dart';
part 'service_order.g.dart';

@Freezed(toJson: true, fromJson: true)
class ServiceOrder with _$ServiceOrder {
  const factory ServiceOrder({
    @Default('') String id,
    @Default('') String vehicleId,
    @Default('') String customerId,
    @Default('') String serviceType,
    @Default('') String description,
    @Default([])
    List<String> partsUsed, // Deprecated: kept for backward compatibility
    @Default([])
    @PartItemListConverter()
    List<PartItem> parts, // New: parts with individual costs
    @Default(0.0) double laborCost,
    @Default(0.0) double partsCost,
    @Default(0.0) double totalCost,
    @Default('pending')
    String status, // 'pending', 'in_progress', 'completed', 'cancelled'
    DateTime? createdAt,
    DateTime? completedAt,
    @Default([]) List<String> beforePhotos,
    @Default([]) List<String> afterPhotos,
    String? notes,
    String? mechanicNotes,
  }) = _ServiceOrder;

  factory ServiceOrder.fromJson(Map<String, dynamic> json) =>
      _$ServiceOrderFromJson(json);
}
