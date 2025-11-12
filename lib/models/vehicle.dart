import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

@freezed
class Vehicle with _$Vehicle {
  const factory Vehicle({
    @Default('') String id,
    @Default('') String customerId,
    @Default('') String numberPlate,
    @Default('') String make,
    @Default('') String model,
    @Default('') String year,
    String? fuelType,
    String? vin,
    String? color,
    String? imageUrl,
    DateTime? lastServiceDate,
    @Default('completed')
    String serviceStatus, // 'active', 'pending', 'completed'
    int? mileage,
    DateTime? createdAt,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);
}
