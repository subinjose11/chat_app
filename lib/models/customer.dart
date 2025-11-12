import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class Customer with _$Customer {
  const factory Customer({
    @Default('') String id,
    @Default('') String name,
    @Default('') String phone,
    @Default('') String email,
    String? address,
    DateTime? createdAt,
    @Default([]) List<String> vehicleIds,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}
