import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_order.freezed.dart';
part 'service_order.g.dart';

@freezed
class ServiceOrder with _$ServiceOrder {
  const factory ServiceOrder({
    @Default('') String id,
    @Default('') String vehicleId,
    @Default('') String customerId,
    @Default('') String serviceType,
    @Default('') String description,
    @Default([]) List<String> partsUsed,
    @Default(0.0) double laborCost,
    @Default(0.0) double partsCost,
    @Default(0.0) double totalCost,
    @Default('pending') String status, // 'pending', 'in_progress', 'completed', 'cancelled'
    DateTime? createdAt,
    DateTime? completedAt,
    @Default([]) List<String> beforePhotos,
    @Default([]) List<String> afterPhotos,
    String? notes,
  }) = _ServiceOrder;

  factory ServiceOrder.fromJson(Map<String, dynamic> json) => _$ServiceOrderFromJson(json);
}
